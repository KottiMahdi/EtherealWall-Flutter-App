import 'package:dio/dio.dart';

abstract class NetworkClient {
  static const String _baseUrl = 'https://api.pexels.com/v1';
  static const String _pexelsApiKey =
      'gnklSvHrozQizmxEsy4kFaYuKmBFyRLeNgL8YunTwdlxng4wZ7k4j0Iu';

  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': _pexelsApiKey,
        },
      ),
    );

    dio.interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
    ]);

    return dio;
  }
}
