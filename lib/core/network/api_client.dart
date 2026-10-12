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
    );
  }

  Future<Response<dynamic>> _request(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      return await request();
    } on DioException catch (error) {
      throw _mapException(error);
    }
  }

  AppException _mapException(DioException error) {
    if (error.type == DioExceptionType.badResponse || error.response != null) {
      return ServerException(
        statusCode: error.response?.statusCode,
        message: error.message ?? 'The server returned an error.',
      );
    }

    return NetworkException(error.message ?? 'A network error occurred.');
  }
}
