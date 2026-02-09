import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:doctor_app/config/routes/doctor_app_router.dart';
import 'package:shared_core/bloc/notification/notification_bloc.dart';
import 'package:shared_core/services/firebase_notification_service.dart';
import 'package:shared_core/shared_core_injection_container.dart';
import 'package:get_it/get_it.dart';
final sl = GetIt.instance;

Future<void> initDI() async {
await registerSharedCoreDependencies(sl);  
await sl.allReady();
  // 3. ⚠️ CRITICAL: Initialize Notification Service AFTER router exists
  await FirebaseNotificationService().setup(
    localNotificationsPlugin: sl<FlutterLocalNotificationsPlugin>(),
    notificationBloc: sl<NotificationBloc>(),
    router: DoctorAppRouter.router,
  );
  sl.registerSingleton<FirebaseNotificationService>(
    FirebaseNotificationService(),
  );
}
