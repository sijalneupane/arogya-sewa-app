import 'package:doctor_app/config/routes/routes_name.dart';
import 'package:doctor_app/core/constants/doctor_app_strings_const.dart' as doctor_strings;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/utils/screen_size.dart';
import 'package:shared_ui/widgets/auth/arogya_sewa_login_form.dart';

class DoctorLoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final bool popOnSuccess;

  DoctorLoginPage({super.key, this.popOnSuccess = false});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.vw(2.5),
              vertical: context.vh(2.5),
            ),
            child: ArogyaSewaLoginForm(
              emailController: emailController,
              passwordController: passwordController,
              afterAuthenticationSuccess: (context) {
                // Handle navigation based on popOnSuccess flag
                if (popOnSuccess) {
                  if (context.canPop()) {
                    context.pop(true);
                  } else {
                    context.goNamed(RoutesName.homeScreen);
                  }
                  return;
                }
                
                // Navigate to home screen on successful login
                context.goNamed(RoutesName.homeScreen);
              },
              afterAuthenticationFail: () {
                // Error handling is already done in the form via bottom sheet
                // This callback can be used for additional logic if needed
              },
              appLogoPath: doctor_strings.appLogoWhiteBgPath,
              formKey: formKey,
            ),
          ),
        ),
      ),
    );
  }

}
