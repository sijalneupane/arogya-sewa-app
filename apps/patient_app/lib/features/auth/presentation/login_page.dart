import 'package:flutter/material.dart';
import 'package:patient_app/features/home/pages/home_page.dart';
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
  void afterAuthenticationFail() {
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(
        children: [
          ArogyaSewaLoginForm(emailController: emailController, passwordController: passwordController, afterAuthenticationSuccess: (context) => afterAuthenticationSuccess(context), afterAuthenticationFail: afterAuthenticationFail)
        ],
      ))
    );
  }
}