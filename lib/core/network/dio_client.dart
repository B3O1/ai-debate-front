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
    )..interceptors.add(
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
}
