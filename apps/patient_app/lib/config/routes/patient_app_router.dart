import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:patient_app/config/routes/routes_name.dart';
import 'package:patient_app/features/auth/presentation/login_page.dart';
import 'package:patient_app/features/splashscreen/pages/patient_splash_screen.dart';

class PatientAppRouter {
  static final GlobalKey<NavigatorState> rootKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> homeKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> settingsKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: RoutesName.splashScreen,
        builder: (context, state) => const PatientSplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: RoutesName.loginScreen,
        builder: (context, state) => PatientLoginPage(),
      ),
    ],
  );
}
