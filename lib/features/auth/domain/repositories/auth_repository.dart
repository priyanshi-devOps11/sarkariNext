import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithEmail(String email, String password);
  Future<Either<Failure, UserEntity>> signUpWithEmail(String email, String password, String name);
  Future<Either<Failure, UserEntity>> signInWithGoogle();
  Future<Either<Failure, void>> signOut();
  UserEntity? getCurrentUser();
  bool get isLoggedIn;
}