import 'dart:convert';
import 'dart:io';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_core/bloc/notification/notification_bloc.dart';
import 'package:shared_core/bloc/notification/notification_event.dart';
import 'package:shared_core/data/models/notification_payload_model.dart';
import 'package:shared_core/domain/entities/notification_payload_entity.dart';

class FirebaseNotificationService {
  // Singleton pattern
  static final FirebaseNotificationService _instance = FirebaseNotificationService._internal();
  factory FirebaseNotificationService() => _instance;
  FirebaseNotificationService._internal();

  late FlutterLocalNotificationsPlugin _localNotificationsPlugin;
  late FirebaseMessaging _messaging;
  late NotificationBloc _notificationBloc;
  late GoRouter _router;

  static const String _androidChannelId = 'high_importance_channel';

  /// Initialize service AFTER GoRouter is created (call in app DI)
  Future<void> setup({
    required FlutterLocalNotificationsPlugin localNotificationsPlugin,
    required NotificationBloc notificationBloc,
    required GoRouter router,
  }) async {
    _localNotificationsPlugin = localNotificationsPlugin;
    _messaging = FirebaseMessaging.instance;
    _notificationBloc = notificationBloc;
    _router = router;

    await _initializeLocalNotifications();
    await _requestPermissions();
    _setupForegroundHandler();
    _setupBackgroundHandler();
    _setupTerminatedHandler();
    await _registerDeviceToken();
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    final iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _localNotificationsPlugin.initialize(
      settings: InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: _handleNotificationTap,
      // onDidReceiveBackgroundNotificationResponse: _handleNotificationTap
    );

    if (Platform.isAndroid) {
      await _createAndroidNotificationChannel();
    }
  }

  Future<void> _createAndroidNotificationChannel() async {
    final channel = AndroidNotificationChannel(
      _androidChannelId,
      'High Importance Notifications',
      description: 'Critical app notifications',
      importance: Importance.max,
      enableVibration: true,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _requestPermissions() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('✅ Notification permission: ${settings.authorizationStatus}');
    } catch (e) {
      debugPrint('❌ Permission request failed: $e');
    }
  }

  void _setupForegroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('🔔 Foreground message: ${message.messageId}');
      final payload = NotificationPayloadModel.fromMap(message.data);
      _showLocalNotification(message, payload);
      _notificationBloc.add(NotificationReceivedEvent(message: message, payload: payload));
    });
  }

  void _setupBackgroundHandler() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('👆 Background tap: ${message.messageId}');
      final payload = NotificationPayloadModel.fromMap(message.data);
      _handleNavigation(payload);
      _notificationBloc.add(NotificationTappedEvent(message: message, payload: payload));
    });
  }

  void _setupTerminatedHandler() async {
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      debugPrint('🚀 Terminated launch: ${message.messageId}');
      final payload = NotificationPayloadModel.fromMap(message.data);
      _handleNavigation(payload);
      _notificationBloc.add(NotificationTappedEvent(message: message, payload: payload));
    }
  }

  void _handleNavigation(NotificationPayloadEntity payload) {
    try {
      if (!payload.isNavigable) {
        debugPrint('⚠️ No routeName in payload, navigating to default notifications screen');
        _router.go('/notifications');
        return;
      }

      if (payload.routeParams != null && payload.routeParams!.isNotEmpty) {
        _router.go(payload.routeName!, extra: payload.routeParams!);
        debugPrint('✅ Navigated to ${payload.routeName} with params: ${payload.routeParams}');
      } else {
        _router.go(payload.routeName!);
        debugPrint('✅ Navigated to ${payload.routeName}');
      }
    } catch (e) {
      debugPrint('❌ Navigation error: $e. Router context may not be available yet.');
    }
  }

  void _handleNotificationTap(NotificationResponse details) {
    if (details.payload == null) return;
    
    try {
      final payloadMap = jsonDecode(details.payload!) as Map<String, dynamic>;
      final payload = NotificationPayloadModel.fromMap(payloadMap);
      debugPrint('👆 Local notification tap: ${payload.routeName}');
      _handleNavigation(payload);
    } catch (e) {
      debugPrint('❌ Error handling notification tap: $e');
      _router.go('/notifications');
    }
  }

  void _showLocalNotification(RemoteMessage message, NotificationPayloadModel payload) {
    final notification = message.notification;
    if (notification == null) return;

    final payloadJson = jsonEncode(payload.toMap());

    _localNotificationsPlugin.show(
    id: _generateNotificationId(message),
    title: notification.title ?? payload.title ?? 'New notification', 
    body: notification.body ?? payload.body ?? 'You have a new message',
     notificationDetails: _buildNotificationDetails(payloadJson),
      payload: payloadJson,
    );
  }

  int _generateNotificationId(RemoteMessage message) {
    if (message.messageId != null) {
      return message.messageId!.hashCode.abs();
    }
    return DateTime.now().millisecondsSinceEpoch.remainder(1000000);
  }

  NotificationDetails _buildNotificationDetails(String payloadJson) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _androidChannelId,
        'High Importance Notifications',
        icon: '@mipmap/launcher_icon',
        priority: Priority.high,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        // payload: payloadJson,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        // payload: payloadJson,
      ),
    );
  }

  Future<void> _registerDeviceToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        debugPrint('📱 FCM Token: $token');
        _notificationBloc.add(DeviceTokenRegisteredEvent(token));
      }

      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        debugPrint('🔄 FCM Token refreshed: $newToken');
        _notificationBloc.add(DeviceTokenRegisteredEvent(newToken));
      });
    } catch (e) {
      debugPrint('❌ Token registration error: $e');
      _notificationBloc.add(NotificationErrorEvent('Failed to register device token'));
    }
  }

  // Public API
  Future<String?> getDeviceToken() => _messaging.getToken();
  Future<void> subscribeToTopic(String topic) => _messaging.subscribeToTopic(topic);
  Future<void> unsubscribeFromTopic(String topic) => _messaging.unsubscribeFromTopic(topic);
}