import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:patient_app/config/routes/routes_name.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart';
import 'package:shared_ui/widgets/splash/arogya_sewa_splash_page.dart';

class PatientSplashScreen extends StatelessWidget {
  const PatientSplashScreen({super.key});

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
