import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient_app/config/routes/patient_app_router.dart';
import 'package:patient_app/core/constants/app_strings_const.dart';
import 'package:patient_app/firebase_options.dart';
import 'package:patient_app/patient_injection_container.dart';
import 'package:shared_core/bloc/notification/notification_bloc.dart';
import 'package:shared_feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_feature/splash/presentation/bloc/splash_bloc.dart';
import 'package:shared_ui/theme/app_theme.dart';
// MUST be top-level/static for background messages
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Background message handled: ${message.messageId}');
}
void main() async {
    WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 2. Register background handler BEFORE runApp
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  
  await initDI();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<SplashBloc>()),
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<NotificationBloc>()),
      ],
      child: MaterialApp.router(
            routerConfig: PatientAppRouter.router,
            debugShowCheckedModeBanner: false,
            title: appName,
            theme: AppThemeData.light(),
            darkTheme: AppThemeData.dark(),
             themeMode: ThemeMode.system,
          )
    );
  }
}
