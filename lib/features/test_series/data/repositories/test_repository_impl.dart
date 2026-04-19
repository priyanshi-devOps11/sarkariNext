import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/test_entity.dart';
import '../../domain/repositories/test_repository.dart';
import '../models/test_model.dart';

class TestRepositoryImpl implements TestRepository {
  @override
  Future<Either<Failure, List<TestEntity>>> getTests({
    String? exam, String? subject}) async {
    try {
      final resp = await dio.get(ApiConstants.tests,
          queryParameters: {
            if (exam    != null) 'exam': exam,
            if (subject != null) 'subject': subject,
          });
      final list = (resp.data['data'] as List)
          .map((e) => TestModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(list);
    } on DioException catch (e) {
      return Left(ServerFailure(
          e.response?.data['message'] ?? 'Failed to load tests',
          e.response?.statusCode ?? 500));
    }
  }

  @override
  Future<Either<Failure, TestEntity>> getTestById(String id) async {
    try {
      final resp = await dio.get('${ApiConstants.tests}/$id');
      return Right(TestModel.fromJson(resp.data['data'] as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(ServerFailure(
          e.response?.data['message'] ?? 'Failed to load test',
          e.response?.statusCode ?? 500));
    }
  }

  @override
  Future<Either<Failure, TestResultEntity>> submitTest(
      String testId, Map<int, int> answers, int timeTaken) async {
    try {
      final resp = await dio.post('${ApiConstants.tests}/$testId/submit',
          data: {'answers': answers, 'timeTaken': timeTaken});
      final d = resp.data['data'] as Map<String, dynamic>;
      return Right(TestResultEntity(
        testId:     testId,
        score:      (d['score']      as num).toDouble(),
        totalMarks: (d['totalMarks'] as num).toDouble(),
        correct:    d['correct']  as int,
        wrong:      d['wrong']    as int,
        skipped:    d['skipped']  as int,
        timeTaken:  timeTaken,
        accuracy:   d['correct'] == 0
            ? 0
            : (d['correct'] as int) /
            ((d['correct'] as int) + (d['wrong'] as int)) * 100,
        details: (d['details'] as List).map((x) {
          final m = x as Map<String, dynamic>;
          return QuestionResultEntity(
            questionIndex:  m['questionIndex']  as int,
            selectedOption: m['selectedOption'] as int?,
            status: m['status'] == 'correct'
                ? AnswerStatus.correct
                : m['status'] == 'wrong'
                ? AnswerStatus.wrong
                : AnswerStatus.skipped,
          );
        }).toList(),
      ));
    } on DioException catch (e) {
      return Left(ServerFailure(
          e.response?.data['message'] ?? 'Submit failed',
          e.response?.statusCode ?? 500));
    }
  }
}