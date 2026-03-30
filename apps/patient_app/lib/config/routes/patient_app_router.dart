import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:patient_app/config/routes/routes_name.dart';
import 'package:patient_app/features/auth/presentation/login_page.dart';
import 'package:patient_app/features/home/presentation/bloc/doctors_bloc.dart';
import 'package:patient_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:patient_app/features/home/presentation/pages/home_page.dart';
import 'package:patient_app/features/home/presentation/pages/hospital_search_screen.dart';
import 'package:patient_app/features/splashscreen/pages/patient_splash_screen.dart';
import 'package:get_it/get_it.dart';

class PatientAppRouter {
  static final GlobalKey<NavigatorState> rootKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> homeKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> settingsKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootKey,
    initialLocation: '/home',
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
      GoRoute(
        path: '/home',
        name: RoutesName.homeScreen,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider<HomeBloc>(
              create: (context) => GetIt.instance<HomeBloc>(),
            ),
            BlocProvider<DoctorsBloc>(
              create: (context) => GetIt.instance<DoctorsBloc>(),
            ),
          ],
          child: const HomePage(),
        ),
        routes: [
          GoRoute(
            path: 'search',
            name: RoutesName.hospitalSearchScreen,
            builder: (context, state) => const HospitalSearchScreen(),
          ),
        ],
      ),
    ],
  );
}
