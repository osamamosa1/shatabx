import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../error/exceptions.dart';
import '../services/local_storage/app_shared_preferences.dart';
import 'api_constants.dart';
import 'api_response.dart';
import 'app_interceptors.dart';
import 'status_code.dart';

abstract class DioConsumer {
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  });

  Future<dynamic> post(
    String path, {
    dynamic body,
    FormData? formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  });

  Future<dynamic> put(
    String path, {
    dynamic body,
    FormData? formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  });

  Future<dynamic> delete(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  });

  void updateLanguageHeader(String languageCode);
}

class DioConsumerImpl implements DioConsumer {
  DioConsumerImpl({
    required this.client,
    required this.preferences,
    this.onUnauthorized,
  }) {
    client.options.baseUrl = ApiConstants.baseUrl;
    client.options.connectTimeout = ApiConstants.connectTimeout;
    client.options.receiveTimeout = ApiConstants.receiveTimeout;
    client.options.sendTimeout = ApiConstants.sendTimeout;
    client.options.responseType = ResponseType.json;
    client.options.followRedirects = false;
    client.options.validateStatus = (code) => code != null && code < 500;
    client.options.headers = <String, dynamic>{
      Headers.acceptHeader: Headers.jsonContentType,
      HttpHeaders.acceptLanguageHeader: preferences.languageCode,
    };

    client.interceptors.clear();
    client.interceptors.add(AppInterceptors(onUnauthorized: onUnauthorized));
    if (kDebugMode) {
      client.interceptors.add(
        LogInterceptor(
          requestBody: false,
          responseBody: false,
          requestHeader: false,
          responseHeader: false,
          error: true,
        ),
      );
    }
  }

  final Dio client;
  final AppSharedPreferences preferences;
  final void Function()? onUnauthorized;

  Future<void> _attachToken() async {
    final token = preferences.token;
    if (token != null && token.isNotEmpty) {
      client.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    } else {
      client.options.headers.remove(HttpHeaders.authorizationHeader);
    }
  }

  @override
  void updateLanguageHeader(String languageCode) {
    client.options.headers[HttpHeaders.acceptLanguageHeader] = languageCode;
  }

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _request(() async {
      await _attachToken();
      return client.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    });
  }

  @override
  Future<dynamic> post(
    String path, {
    dynamic body,
    FormData? formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _request(() async {
      await _attachToken();
      return client.post(
        path,
        data: formData ?? body,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    });
  }

  @override
  Future<dynamic> put(
    String path, {
    dynamic body,
    FormData? formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _request(() async {
      await _attachToken();
      return client.put(
        path,
        data: formData ?? body,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    });
  }

  @override
  Future<dynamic> delete(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _request(() async {
      await _attachToken();
      return client.delete(
        path,
        data: body,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    });
  }

  Future<dynamic> _request(Future<Response<dynamic>> Function() run) async {
    try {
      final response = await run();
      return _handle(response);
    } on SocketException {
      throw const NetworkException(message: 'تحقق من اتصال الإنترنت');
    } on DioException catch (error) {
      throw _mapDio(error);
    }
  }

  dynamic _handle(Response<dynamic> response) {
    final code = response.statusCode ?? 0;
    final data = response.data;

    if (code == StatusCode.unauthorized) {
      throw UnauthorizedException(
        message: readApiMessage(data) ?? 'Unauthenticated',
      );
    }
    if (code == StatusCode.unprocessable || code == StatusCode.badRequest) {
      throw ValidationException(
        message: readApiMessage(data) ?? 'بيانات غير صالحة',
      );
    }
    if (code == StatusCode.forbidden) {
      throw ServerException(message: readApiMessage(data) ?? 'غير مسموح');
    }
    if (code == StatusCode.notFound) {
      throw ServerException(message: readApiMessage(data) ?? 'غير موجود');
    }
    if (code == StatusCode.ok || code == StatusCode.created) {
      final parsed = ApiResponse.from(data);
      if (!parsed.isSuccess) {
        throw ServerException(
          message: parsed.message ?? readApiMessage(data) ?? 'تعذر إكمال الطلب',
        );
      }
      return data;
    }
    throw ServerException(message: readApiMessage(data) ?? 'تعذر إكمال الطلب');
  }

  AppException _mapDio(DioException error) {
    if (error.type == DioExceptionType.cancel) {
      throw const ServerException(message: 'تم إلغاء الطلب');
    }
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionError) {
      return const NetworkException(message: 'تحقق من اتصال الإنترنت');
    }
    final data = error.response?.data;
    final message =
        readApiMessage(data) ?? error.message ?? 'حدث خطأ غير متوقع';
    final code = error.response?.statusCode;
    if (code == StatusCode.unauthorized) {
      return UnauthorizedException(message: message);
    }
    if (code == StatusCode.unprocessable || code == StatusCode.badRequest) {
      return ValidationException(message: message);
    }
    return ServerException(message: message);
  }
}
