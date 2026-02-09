import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class NotificationState extends Equatable {
  final List<RemoteMessage> notifications;
  final String? deviceToken;
  final bool isLoading;

  const NotificationState({
    this.notifications = const [],
    this.deviceToken,
    this.isLoading = false,
  });

  @override List<Object?> get props => [notifications, deviceToken, isLoading];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {
  const NotificationLoading({super.deviceToken, super.notifications}) : super(isLoading: true);
}

class NotificationLoaded extends NotificationState {
  const NotificationLoaded({
    required super.notifications,
    super.deviceToken,
  });
}

class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message, {super.deviceToken, super.notifications});
  @override List<Object?> get props => [...super.props, message];
}