import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_core/bloc/notification/notification_event.dart';
import 'package:shared_core/bloc/notification/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<NotificationReceivedEvent>(_onNotificationReceived);
    on<NotificationTappedEvent>(_onNotificationTapped);
    on<DeviceTokenRegisteredEvent>(_onTokenRegistered);
    on<NotificationErrorEvent>(_onError);
  }

  void _onNotificationReceived(NotificationReceivedEvent event, Emitter<NotificationState> emit) {
    final updated = List<RemoteMessage>.from(state is NotificationLoaded ? (state as NotificationLoaded).notifications : <RemoteMessage>[])..insert(0, event.message);
    emit(NotificationLoaded(notifications: updated, deviceToken: state.deviceToken));
  }

  void _onNotificationTapped(NotificationTappedEvent event, Emitter<NotificationState> emit) {
    // Optional: mark as read or analytics tracking
  }

  void _onTokenRegistered(DeviceTokenRegisteredEvent event, Emitter<NotificationState> emit) {
    final currentNotifications = state is NotificationLoaded ? (state as NotificationLoaded).notifications : <RemoteMessage>[];
    emit(NotificationLoaded(notifications: currentNotifications, deviceToken: event.token));
  }

  void _onError(NotificationErrorEvent event, Emitter<NotificationState> emit) {
    emit(NotificationError(event.message, deviceToken: state.deviceToken));
  }
}