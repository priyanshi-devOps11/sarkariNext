import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/test_entity.dart';

abstract class TestRepository {
  Future<Either<Failure, List<TestEntity>>> getTests({String? exam, String? subject});
  Future<Either<Failure, TestEntity>>       getTestById(String id);
  Future<Either<Failure, TestResultEntity>> submitTest(
      String testId, Map<int, int> answers, int timeTaken);
}