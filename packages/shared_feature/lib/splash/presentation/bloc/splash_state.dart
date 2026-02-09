import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
	const SplashState();
	@override
	List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashLoaded extends SplashState {
	final String version;
	const SplashLoaded(this.version);

	@override
	List<Object?> get props => [version];
}

class SplashFailure extends SplashState {
	final String message;
	const SplashFailure(this.message);

	@override
	List<Object?> get props => [message];
}
