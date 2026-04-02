import 'package:equatable/equatable.dart';

abstract class SplashEvent extends Equatable {
	const SplashEvent();
	@override
	List<Object?> get props => [];
}

class FetchVersionEvent extends SplashEvent {
	const FetchVersionEvent();
}
class FetchRememberMeValue extends SplashEvent {
  const FetchRememberMeValue();
}
