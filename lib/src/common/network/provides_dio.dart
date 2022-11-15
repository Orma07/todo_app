import 'package:dio/dio.dart';

Dio providesDio(String url) {
  BaseOptions options = BaseOptions(
    baseUrl: url,
    headers: {
      'accept': Headers.jsonContentType,
    },
    contentType: Headers.jsonContentType,
    connectTimeout: 120000,
    receiveTimeout: 120000,
  );
  return Dio(options);

}