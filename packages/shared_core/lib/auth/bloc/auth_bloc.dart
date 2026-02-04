import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_core/auth/models/auth_session_model.dart';
import 'package:shared_core/auth/services/auth_service.dart';
import 'package:shared_core/models/api_models.dart';
import 'package:shared_core/auth/bloc/auth_event.dart';
import 'package:shared_core/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(AuthInitial()) {
    on<AuthLoginInitiated>(_onLoginRequested);
    on<AuthPasswordToggled>(_onLoginPasswordToggled);
    // on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginInitiated event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await authService.login(event.loginModel);

    if (result is ApiSuccess<AuthSessionModel>) {
      // Save token in secure storage (via repository or service)
      await authService.saveToken(result.data!.accessToken);
      emit(Authenticated());
    } else if (result is ApiFailure) {
      emit(AuthError(result.errorMessage ?? 'Login failed'));
    }
  }

  void _onLoginPasswordToggled(
    AuthPasswordToggled event,
    Emitter<AuthState> emit,
  ) {
    final newVisibility = !event.obscure;
    print(  'Password visibility toggled: $newVisibility');
    emit(AuthInitial(obscure: newVisibility));
  }

  // Future<void> _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
  //   await authService.logout();
  //   emit(AuthUnauthenticated());
  // }
}
