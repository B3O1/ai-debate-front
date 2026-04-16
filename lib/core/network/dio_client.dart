import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_constants.dart';

class DioClient {
  const DioClient._();

  static Dio create() {
    return Dio(
        BaseOptions(
          baseUrl: ApiConstants.debateBaseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      )
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            options.extra['requestStartedAt'] = DateTime.now();
            handler.next(options);
          },
          onResponse: (response, handler) {
            _logElapsedTime(response.requestOptions);
            handler.next(response);
          },
          onError: (error, handler) {
            _logElapsedTime(error.requestOptions);
            handler.next(error);
          },
        ),
      )
      ..interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
          logPrint: (object) => debugPrint(object.toString()),
        ),
      );
  }

  static void _logElapsedTime(RequestOptions options) {
    final startedAt = options.extra['requestStartedAt'];
    if (startedAt is! DateTime) {
      return;
    }

    final elapsed = DateTime.now().difference(startedAt).inMilliseconds;
    debugPrint(
      '[Dio] ${options.method} ${options.uri} completed in ${elapsed}ms',
    );
  }
}
