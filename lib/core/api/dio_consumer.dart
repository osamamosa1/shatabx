import 'package:dio/dio.dart';

import '../error/exceptions.dart';
import 'status_code.dart';

abstract class DioConsumer {
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters});

  Future<dynamic> post(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
  });
}

class DioConsumerImpl implements DioConsumer {
  DioConsumerImpl({required this.client, this.baseUrl = ''}) {
    client.options
      ..baseUrl = baseUrl
      ..connectTimeout = const Duration(seconds: 30)
      ..receiveTimeout = const Duration(seconds: 30)
      ..responseType = ResponseType.json;
  }

  final Dio client;
  final String baseUrl;

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.get(path, queryParameters: queryParameters);
      return _handle(response);
    } on DioException catch (error) {
      throw _map(error);
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.post(
        path,
        data: body,
        queryParameters: queryParameters,
      );
      return _handle(response);
    } on DioException catch (error) {
      throw _map(error);
    }
  }

  dynamic _handle(Response<dynamic> response) {
    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return response.data;
    }
    throw ServerException(message: 'تعذر إكمال الطلب');
  }

  AppException _map(DioException error) {
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout) {
      return const NetworkException(message: 'تحقق من اتصال الإنترنت');
    }
    return ServerException(message: error.message ?? 'حدث خطأ غير متوقع');
  }
}
