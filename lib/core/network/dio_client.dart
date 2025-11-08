import 'package:dio/dio.dart';

class DioClient {
  static const _baseUrl = 'https://pokeapi.co/api/v2/';
  final Dio dio;

  DioClient._internal(this.dio);

  factory DioClient.create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    )..interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

    return DioClient._internal(dio);
  }
}
