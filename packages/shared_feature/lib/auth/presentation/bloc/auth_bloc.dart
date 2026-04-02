import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_feature/auth/domain/entity/auth_session_entity.dart';
import 'package:shared_feature/auth/domain/usecase/fetch_user_details_usecase.dart';
import 'package:shared_core/usecase/usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Global authentication bloc.
/// Lives in core — not tied to any single feature.
/// Tracks whether the user is authenticated across the whole app.
/// Only emits: AuthInitial, AuthLoading, AuthAuthenticated, AuthUnauthenticated.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FetchUserDetailsUsecase fetchUserDetailsUsecase;
  
  AuthBloc({required this.fetchUserDetailsUsecase}) : super(const AuthInitial()) {
    on<FetchLoggedInUser>(_onFetchUserLoggedIn);
    on<UserLoggedIn>(_onUserLoggedIn);
    on<UserLoggedOut>(_onUserLoggedOut);
  }

  Future<void> _onFetchUserLoggedIn(
    FetchLoggedInUser event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await fetchUserDetailsUsecase(const NoParams());
    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (AuthSessionEntity session) => emit(AuthAuthenticated(userData: session.user)),
    );
  }

  void _onUserLoggedIn(
    UserLoggedIn event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthAuthenticated(userData: event.userData));
  }

  void _onUserLoggedOut(
    UserLoggedOut event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthUnauthenticated());
  }
}
