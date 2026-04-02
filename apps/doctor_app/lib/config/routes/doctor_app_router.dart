import 'package:doctor_app/config/routes/routes_name.dart';
import 'package:doctor_app/features/auth/presentation/pages/login_page.dart';
import 'package:doctor_app/features/splashscreen/pages/doctor_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DoctorAppRouter {
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
        builder: (context, state) => const DoctorSplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: RoutesName.loginScreen,
        builder: (context, state) {
          final popOnSuccess = state.extra as bool? ?? false;
          return DoctorLoginPage(popOnSuccess: popOnSuccess);
        },
      ),
    ],
  );
}
