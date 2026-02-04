import 'package:flutter/material.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> homeKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> settingsKey =
      GlobalKey<NavigatorState>();

  // static final GoRouter router = GoRouter(
  //   navigatorKey: rootKey,
  //   initialLocation: '/splash',
  //   routes: [],
  // );
}
