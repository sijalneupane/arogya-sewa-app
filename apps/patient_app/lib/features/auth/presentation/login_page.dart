import 'package:flutter/material.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart';
import 'package:patient_app/features/home/pages/home_page.dart';
import 'package:shared_ui/utils/screen_size.dart';
import 'package:shared_ui/widgets/auth/arogya_sewa_login_form.dart';

class PatientLoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  PatientLoginPage({super.key});
  void afterAuthenticationSuccess(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void afterAuthenticationFail() {}
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.vw(2.5),vertical: context.vh(2.5)),
            child: ArogyaSewaLoginForm(
              emailController: emailController,
              passwordController: passwordController,
              afterAuthenticationSuccess: (context) =>
                  afterAuthenticationSuccess(context),
              afterAuthenticationFail: afterAuthenticationFail,
              appLogoPath: appLogoWhiteBgPath,
              formKey: formKey,
              // primaryColor: const Color.fromARGB(255, 32, 37, 123),
            ),
          ),
        ),
      ),
    );
  }
}
