import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_core/domain/entities/notification_payload_entity.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
}

class NotificationReceivedEvent extends NotificationEvent {
  final RemoteMessage message;
  final NotificationPayloadEntity payload;

  const NotificationReceivedEvent({required this.message, required this.payload});

  @override
  List<Object?> get props => [message.messageId, payload.routeName];
}

class NotificationTappedEvent extends NotificationEvent {
  final RemoteMessage message;
  final NotificationPayloadEntity payload;

  const NotificationTappedEvent({required this.message, required this.payload});

  @override
  List<Object?> get props => [message.messageId, payload.routeName];
}

class DeviceTokenRegisteredEvent extends NotificationEvent {
  final String token;
  const DeviceTokenRegisteredEvent(this.token);
  @override List<Object?> get props => [token];
}

class NotificationErrorEvent extends NotificationEvent {
  final String message;
  const NotificationErrorEvent(this.message);
  @override List<Object?> get props => [message];
}