import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import '../errors/app_exception.dart';

class ApiClient {
  static const String baseUrl = 'https://fakestoreapi.com';

  final Dio _dio;

  ApiClient({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
      () => _dio.get<dynamic>(path, queryParameters: queryParameters),
      'GET $path',
    );
  }

  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
      () => _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
      ),
      'POST $path',
    );
  }

  Future<Response<dynamic>> _request(
    Future<Response<dynamic>> Function() request,
    String label,
  ) async {
    debugPrint('ApiClient: requesting $label');
    try {
      final response = await request();
      debugPrint(
        'ApiClient: $label completed with status ${response.statusCode}',
      );
      return response;
    } on DioException catch (error) {
      debugPrint(
        'ApiClient: $label failed with ${error.type}, '
        'status ${error.response?.statusCode ?? 'none'}',
      );
      throw _mapException(error);
    }
  }

  AppException _mapException(DioException error) {
    if (error.type == DioExceptionType.badResponse || error.response != null) {
      return ServerException(
        statusCode: error.response?.statusCode,
        message: 'The server returned an error. Please try again later.',
      );
    }

    return const NetworkException(
      'Unable to connect to the server. Please check your internet connection.',
    );
  }
}
