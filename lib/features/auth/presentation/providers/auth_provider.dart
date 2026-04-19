import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

// Repository provider
final authRepositoryProvider = Provider<AuthRepository>(
      (_) => AuthRepositoryImpl(),
);

// Auth state
sealed class AuthState {}
class AuthInitial        extends AuthState {}
class AuthLoading        extends AuthState {}
class AuthAuthenticated  extends AuthState { final UserEntity user; AuthAuthenticated(this.user); }
class AuthUnauthenticated extends AuthState {}
class AuthError          extends AuthState { final String message; AuthError(this.message); }

// Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(AuthInitial()) {
    _checkCurrentUser();
  }

  void _checkCurrentUser() {
    final user = _repo.getCurrentUser();
    if (user != null) {
      state = AuthAuthenticated(user);
    } else {
      state = AuthUnauthenticated();
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = AuthLoading();
    final result = await _repo.signInWithEmail(email, password);
    result.fold(
          (f) => state = AuthError(f.message),
          (u) => state = AuthAuthenticated(u),
    );
  }

  Future<void> signUpWithEmail(String email, String password, String name) async {
    state = AuthLoading();
    final result = await _repo.signUpWithEmail(email, password, name);
    result.fold(
          (f) => state = AuthError(f.message),
          (u) => state = AuthAuthenticated(u),
    );
  }

  Future<void> signInWithGoogle() async {
    state = AuthLoading();
    final result = await _repo.signInWithGoogle();
    result.fold(
          (f) => state = AuthError(f.message),
          (u) => state = AuthAuthenticated(u),
    );
  }

  Future<void> signOut() async {
    await _repo.signOut();
    state = AuthUnauthenticated();
  }

  void clearError() {
    if (state is AuthError) state = AuthUnauthenticated();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
      (ref) => AuthNotifier(ref.read(authRepositoryProvider)),
);