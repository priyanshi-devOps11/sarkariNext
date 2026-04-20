import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/sarkari_entity.dart';
import '../../domain/repositories/sarkari_repository.dart';
import '../models/sarkari_model.dart';

class SarkariRepositoryImpl implements SarkariRepository {
  final _box = Hive.box(AppConstants.cacheBox);

  String _typeParam(SarkariType t) {
    switch (t) {
      case SarkariType.result:    return 'result';
      case SarkariType.admitCard: return 'admit_card';
      case SarkariType.answerKey: return 'answer_key';
      default:                    return 'job';
    }
  }

  String _cacheKey(SarkariType type, int page) =>
      'sarkari_${_typeParam(type)}_$page';

  bool _isCacheValid(String key) {
    final ts = _box.get('${key}_ts') as int?;
    if (ts == null) return false;
    final age = DateTime.now().millisecondsSinceEpoch - ts;
    return age < 30 * 60 * 1000; // 30 minutes TTL
  }

  @override
  Future<Either<Failure, List<SarkariEntity>>> getItems({
    required SarkariType type,
    String? exam,
    int page = 1,
  }) async {
    final key = _cacheKey(type, page);

    // Return cache if valid and it's page 1
    if (page == 1 && _isCacheValid(key)) {
      try {
        final cached = _box.get(key) as String?;
        if (cached != null) {
          final list = (jsonDecode(cached) as List)
              .map((e) => SarkariModel.fromJson(e as Map<String, dynamic>))
              .toList();
          return Right(list);
        }
      } catch (_) {}
    }

    try {
      final resp = await dio.get(
        ApiConstants.sarkariJobs,
        queryParameters: {
          'type': _typeParam(type),
          'page': page,
          'limit': 10,
          if (exam != null) 'exam': exam,
        },
      );
      final list = (resp.data['data'] as List)
          .map((e) => SarkariModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // Cache page 1
      if (page == 1) {
        await _box.put(key, jsonEncode(
            list.map((e) => (e as SarkariModel).toJson()).toList()));
        await _box.put('${key}_ts',
            DateTime.now().millisecondsSinceEpoch);
      }

      return Right(list);
    } on DioException catch (e) {
      // Fallback to cache on network error
      final cached = _box.get(key) as String?;
      if (cached != null) {
        final list = (jsonDecode(cached) as List)
            .map((e) => SarkariModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(list);
      }
      return Left(ServerFailure(
        e.response?.data?['message'] as String? ?? 'Failed to load data',
        e.response?.statusCode ?? 500,
      ));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SarkariEntity>> getItemById(String id) async {
    try {
      final resp = await dio.get('${ApiConstants.sarkariJobs}/$id');
      return Right(SarkariModel.fromJson(
          resp.data['data'] as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(ServerFailure(
        e.response?.data?['message'] as String? ?? 'Not found',
        e.response?.statusCode ?? 500,
      ));
    }
  }
}