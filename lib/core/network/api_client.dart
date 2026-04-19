import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';

final dio = _createDio();

Dio _createDio() {
  final d = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
  ));
  d.interceptors.addAll([
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final box = Hive.box(AppConstants.userBox);
        final token = box.get('access_token');
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
      onError: (err, handler) {
        if (err.response?.statusCode == 401) {
          Hive.box(AppConstants.userBox).delete('access_token');
        }
        handler.next(err);
      },
    ),
    PrettyDioLogger(requestBody: true, responseBody: true, compact: true),
  ]);
  return d;
}