import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:patient_app/config/routes/routes_name.dart';
import 'package:patient_app/core/config/widgets/patient_bottom_navigation_bar.dart';
import 'package:patient_app/features/appointments/presentation/pages/appointments_page.dart';
import 'package:patient_app/features/doctors/presentation/bloc/doctor_bloc.dart';
import 'package:patient_app/features/doctors/presentation/bloc/doctor_detail_bloc.dart';
import 'package:patient_app/features/auth/presentation/login_page.dart';
import 'package:patient_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:patient_app/features/home/presentation/bloc/home_doctor_bloc.dart';
import 'package:patient_app/features/home/presentation/pages/home_page.dart';
import 'package:patient_app/features/home/presentation/pages/hospital_search_screen.dart';
import 'package:patient_app/features/doctors/presentation/pages/doctors_page.dart';
import 'package:patient_app/features/doctors/presentation/pages/doctor_detail_page.dart';
import 'package:patient_app/features/notifications/presentation/pages/notifications_page.dart';
import 'package:patient_app/features/settings/presentation/pages/settings_page.dart';
import 'package:patient_app/features/splashscreen/pages/patient_splash_screen.dart';
import 'package:get_it/get_it.dart';

class PatientAppRouter {
  static final GlobalKey<NavigatorState> rootKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> homeKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> appointmentsKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> notificationsKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> settingsKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootKey,
    initialLocation: '/splash',
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: RoutesName.splashScreen,
        builder: (context, state) => const PatientSplashScreen(),
      ),

      // Login Screen
      GoRoute(
        path: '/login',
        name: RoutesName.loginScreen,
        builder: (context, state) => PatientLoginPage(),
      ),

      // Stateful Shell Route for Bottom Navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: PatientBottomNavigationBar(
              navigationShell: navigationShell,
            ),
          );
        },
        branches: [
          // Home Branch
          StatefulShellBranch(
            navigatorKey: homeKey,
            routes: [
              GoRoute(
                path: '/home',
                name: RoutesName.homeScreen,
                builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider<HomeBloc>(
                      create: (context) => GetIt.instance<HomeBloc>(),
                    ),
                    BlocProvider<HomeDoctorBloc>(
                      create: (context) => GetIt.instance<HomeDoctorBloc>(),
                    ),
                  ],
                  child: const HomePage(),
                ),
                routes: [
                  GoRoute(
                    path: 'doctors',
                    name: RoutesName.doctorsScreen,
                    builder: (context, state) => BlocProvider<DoctorBloc>(
                      create: (context) => GetIt.instance<DoctorBloc>(),
                      child: const DoctorsPage(),
                    ),
                  ),
                  GoRoute(
                    path: 'doctor-detail/:doctorId',
                    name: RoutesName.doctorDetailScreen,
                    builder: (context, state) {
                      final doctorId = state.pathParameters['doctorId']!;
                      return BlocProvider<DoctorDetailBloc>(
                        create: (context) => GetIt.instance<DoctorDetailBloc>(),
                        child: DoctorDetailPage(doctorId: doctorId),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'search',
                    name: RoutesName.hospitalSearchScreen,
                    builder: (context, state) => const HospitalSearchScreen(),
                  ),
                ],
              ),
            ],
          ),

          // Appointments Branch
          StatefulShellBranch(
            navigatorKey: appointmentsKey,
            routes: [
              GoRoute(
                path: '/appointments',
                name: RoutesName.appointmentsScreen,
                builder: (context, state) => const AppointmentsPage(),
              ),
            ],
          ),

          // Notifications Branch
          StatefulShellBranch(
            navigatorKey: notificationsKey,
            routes: [
              GoRoute(
                path: '/notifications',
                name: RoutesName.notificationsScreen,
                builder: (context, state) => const NotificationsPage(),
              ),
            ],
          ),

          // Settings Branch
          StatefulShellBranch(
            navigatorKey: settingsKey,
            routes: [
              GoRoute(
                path: '/settings',
                name: RoutesName.settingsScreen,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
