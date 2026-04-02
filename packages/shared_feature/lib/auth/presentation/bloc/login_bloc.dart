import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_feature/auth/domain/entity/auth_session_entity.dart';
import 'package:shared_feature/auth/domain/usecase/login_usecase.dart';
import 'package:shared_feature/auth/presentation/bloc/login_event.dart';
import 'package:shared_feature/auth/presentation/bloc/login_state.dart';

/// Login bloc - handles login form interactions and authentication requests.
/// Emits states related to login flow: initial, loading, success, failure.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUsecase loginUsecase;

  LoginBloc({required this.loginUsecase}) : super(const LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginPasswordToggled>(_onPasswordToggled);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    final Either<Failure, AuthSessionEntity> result =
        await loginUsecase(event.loginEntity);

    result.fold(
      (failure) => emit(LoginFailure(failure.message)),
      (authSession) => emit(const LoginSuccess()),
    );
  }

  void _onPasswordToggled(
    LoginPasswordToggled event,
    Emitter<LoginState> emit,
  ) {
    emit(LoginInitial(obscurePassword: event.obscure));
  }
}
