import 'package:flutter/material.dart';
import 'package:patient_app/features/auth/presentation/login_page.dart';
import 'package:shared_ui/widgets/splash/arogya_sewa_splash_page.dart';

class PatientSplashScreen extends StatelessWidget {
  const PatientSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ArogyaSewaSplashPage(
        appLogoImgPath: 'assets/images/patient_app_logo.png',
        appTitle: 'Patient App',
        afterDelayNavigate: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  PatientLoginPage()),
          );
        },
      ),
    );
  }
}
