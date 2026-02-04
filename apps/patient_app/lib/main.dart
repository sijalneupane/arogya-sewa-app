import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient_app/features/splashscreen/pages/patient_splash_screen.dart';
import 'package:patient_app/patient_injection_container.dart';
import 'package:shared_core/auth/bloc/auth_bloc.dart';
import 'package:shared_core/splash/bloc/splash_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      ],
      child: MaterialApp(
        title: 'Patient APP',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const PatientSplashScreen()
      ),
    );
  }
}
