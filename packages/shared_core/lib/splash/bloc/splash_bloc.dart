import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_core/splash/bloc/splash_event.dart';
import 'package:shared_core/splash/bloc/splash_state.dart';
import 'package:shared_core/splash/service/splash_service.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
	final SplashService splashService;
	SplashBloc({required this.splashService}) : super(SplashInitial()) {
		on<FetchVersionEvent>(_onFetchVersion);
	}

	Future<void> _onFetchVersion(
		FetchVersionEvent event,
		Emitter<SplashState> emit,
	) async {
		emit(SplashLoading());
		final result = await splashService.findVersion();
    emit(SplashLoaded(result));
	}
}
