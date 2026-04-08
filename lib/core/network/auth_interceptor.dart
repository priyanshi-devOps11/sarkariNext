import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

class AuthInterceptor extends Interceptor {
  final Ref _ref;
  AuthInterceptor(this._ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final box = Hive.box(AppConstants.userBox);
    final token = box.get('access_token');

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Auto-logout on 401
    if (err.response?.statusCode == 401) {
      final box = Hive.box(AppConstants.userBox);
      box.delete('access_token');
    }
    handler.next(err);
  }
}