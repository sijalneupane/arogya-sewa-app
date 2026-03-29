import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:patient_app/config/routes/routes_name.dart';
import 'package:shared_ui/utils/screen_size.dart';
import 'package:shared_ui/widgets/auth/arogya_sewa_login_form.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart' as patient_strings;

class PatientLoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  PatientLoginPage({super.key});
  
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
                // Navigate to home page on successful login
                context.goNamed(RoutesName.homeScreen);
              },
              afterAuthenticationFail: () {
                // Error handling is already done in the form via bottom sheet
                // This callback can be used for additional logic if needed
              },
              appLogoPath: patient_strings.appLogoWhiteBgPath,
              formKey: formKey,
            ),
          ),
        ),
      ),
    );
  }

}
