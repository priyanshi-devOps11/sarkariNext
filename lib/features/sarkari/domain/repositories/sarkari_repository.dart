import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/sarkari_entity.dart';

abstract class SarkariRepository {
  Future<Either<Failure, List<SarkariEntity>>> getItems({
    required SarkariType type,
    String? exam,
    int page,
  });
  Future<Either<Failure, SarkariEntity>> getItemById(String id);
}