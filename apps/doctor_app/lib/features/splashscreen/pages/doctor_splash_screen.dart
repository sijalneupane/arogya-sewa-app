import 'package:doctor_app/config/routes/routes_name.dart';
import 'package:doctor_app/core/constants/doctor_app_strings_const.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/widgets/splash/arogya_sewa_splash_page.dart';

class DoctorSplashScreen extends StatelessWidget {
  const DoctorSplashScreen({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ArogyaSewaSplashPage(
        appLogoImgPath:appLogoWhiteBgPath,
        appTitle: appName,
        afterDelayNavigate: () {
          context.pushNamed(RoutesName.loginScreen);
        },
      ),
    );
  }
}