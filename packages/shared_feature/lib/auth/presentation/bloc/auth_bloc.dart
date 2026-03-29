import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_feature/auth/domain/entity/auth_session_entity.dart';
import 'package:shared_feature/auth/domain/usecase/login_usecase.dart';
import 'package:shared_feature/auth/presentation/bloc/auth_event.dart';
import 'package:shared_feature/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;

  AuthBloc({required this.loginUsecase}) : super(AuthInitial()) {
    on<AuthLoginInitiated>(_onLoginRequested);
    on<AuthPasswordToggled>(_onLoginPasswordToggled);
    // on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginInitiated event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final Either<Failure, AuthSessionEntity> result = 
        await loginUsecase(event.loginEntity);
    
    result.fold(
      (failure) {
        emit(AuthError(failure.message));
      },
      (authSession) {
        emit(Authenticated(authSession: authSession));
      },
    );
  }

  void _onLoginPasswordToggled(
    AuthPasswordToggled event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthInitial(obscure: !event.obscure));
  }

  // Future<void> _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
  //   await authService.logout();
  //   emit(AuthUnauthenticated());
  // }
}
