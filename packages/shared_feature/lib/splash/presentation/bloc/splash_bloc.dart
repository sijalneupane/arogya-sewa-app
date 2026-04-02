import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';
import 'package:shared_core/usecase/usecase.dart';
import 'package:shared_feature/splash/domain/usecases/fetch_app_version_usecase.dart';
import 'package:shared_feature/splash/domain/usecases/fetch_remember_me_usecase.dart';
import 'package:shared_feature/splash/presentation/bloc/splash_event.dart';
import 'package:shared_feature/splash/presentation/bloc/splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
	final FetchAppVersionUsecase fetchAppVersion;
  final FetchRememberMeUseCase fetchRememberMe;
	SplashBloc({required this.fetchAppVersion, required this.fetchRememberMe}) : super(SplashInitial()) {
		on<FetchVersionEvent>(_onFetchVersion);
    on<FetchRememberMeValue>(_onFetchRememberMeValue);
	}

	Future<void> _onFetchVersion(
		FetchVersionEvent event,
		Emitter<SplashState> emit,
	) async {
		emit(SplashLoading());
		final result = await fetchAppVersion(const NoParams());
		result.fold(
			(f) => emit(SplashFailure(f.message.isNotEmpty ? f.message : versionFetchFailedString)),
			(version) => emit(SplashLoaded(version)),
		);
	}
  Future<void> _onFetchRememberMeValue(
    FetchRememberMeValue event,
    Emitter<SplashState> emit,
  ) async {
    final result = await fetchRememberMe(const NoParams());
    result.fold(
      (f) => emit(
        SplashFailure(
          f.message.isNotEmpty ? f.message : rememberMeFetchFailedString,
        ),
      ),
      (isRemembered) => emit(SplashLoadedRememberMe(isRemembered)),
    );
  }
}