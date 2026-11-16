import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'auth_event_bus.dart';

class AppInterceptors extends Interceptor {
  AppInterceptors({this.onUnauthorized});

  final void Function()? onUnauthorized;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final method = options.method.toUpperCase();
    final hasJsonBody = options.data != null && options.data is! FormData;
    if (hasJsonBody && method != 'GET' && method != 'DELETE') {
      options.headers['Content-Type'] = Headers.jsonContentType;
    } else {
      options.headers.remove(Headers.contentTypeHeader);
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      onUnauthorized?.call();
      AuthEventBus.instance.emitUnauthorized();
    }
    if (kDebugMode) {
      debugPrint(
        'API ERROR[${err.response?.statusCode}] ${err.requestOptions.method} '
        '${err.requestOptions.path}',
      );
    }
    handler.next(err);
  }
}
