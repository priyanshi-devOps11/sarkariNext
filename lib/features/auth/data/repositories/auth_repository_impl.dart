import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final GoogleSignIn   _google   = GoogleSignIn();

  @override
  bool get isLoggedIn => _supabase.auth.currentUser != null ||
      Hive.box(AppConstants.userBox).get('access_token') != null;

  @override
  UserEntity? getCurrentUser() {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    return UserModel.fromSupabase(user);
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail(
      String email, String password) async {
    try {
      final res = await _supabase.auth
          .signInWithPassword(email: email, password: password);
      if (res.user == null) return const Left(AuthFailure('Sign in failed'));
      await _saveToken(res.session!.accessToken);
      return Right(UserModel.fromSupabase(res.user!));
    } on AuthApiException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmail(
      String email, String password, String name) async {
    try {
      final res = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      if (res.user == null) return const Left(AuthFailure('Sign up failed'));
      if (res.session != null) await _saveToken(res.session!.accessToken);
      return Right(UserModel.fromSupabase(res.user!));
    } on AuthApiException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final googleUser = await _google.signIn();
      if (googleUser == null) return const Left(AuthFailure('Cancelled'));
      final googleAuth = await googleUser.authentication;
      final res = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken!,
      );
      if (res.user == null) return const Left(AuthFailure('Google sign in failed'));
      await _saveToken(res.session!.accessToken);
      return Right(UserModel.fromSupabase(res.user!));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _google.signOut();
      await _supabase.auth.signOut();
      await Hive.box(AppConstants.userBox).clear();
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Future<void> _saveToken(String token) async {
    await Hive.box(AppConstants.userBox).put('access_token', token);
  }
}