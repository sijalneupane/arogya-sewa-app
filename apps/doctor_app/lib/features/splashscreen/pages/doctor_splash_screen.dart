import 'package:flutter/material.dart';
import 'package:shared_ui/widgets/splash/arogya_sewa_splash_page.dart';

class DoctorSplashScreen extends StatelessWidget {
  const DoctorSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ArogyaSewaSplashPage(appLogoImgPath: 'assets/images/doctor_app_logo.png', appTitle: 'Doctor App', afterDelayNavigate: () {
        // Define navigation logic here
      }),
    );
  }
}