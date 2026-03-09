import 'package:doctor_app/config/routes/routes_name.dart';
import 'package:doctor_app/core/constants/doctor_app_strings_const.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/utils/screen_size.dart';
import 'package:shared_ui/widgets/auth/arogya_sewa_login_form.dart';

class DoctorLoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  DoctorLoginPage({super.key});
  void afterAuthenticationSuccess(BuildContext context) {
    context.pushNamed(RoutesName.homeScreen);
  }

  void afterAuthenticationFail() {}
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
              afterAuthenticationSuccess: (context) =>
                  afterAuthenticationSuccess(context),
              afterAuthenticationFail: afterAuthenticationFail,
              appLogoPath: appLogoWhiteBgPath,
              formKey: formKey,
              // primaryColor: DoctorAppColors.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
