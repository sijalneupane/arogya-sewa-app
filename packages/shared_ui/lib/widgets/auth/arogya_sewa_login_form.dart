import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_feature/auth/domain/entity/login_entity.dart';
import 'package:shared_feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_feature/auth/presentation/bloc/auth_event.dart';
import 'package:shared_feature/auth/presentation/bloc/auth_state.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';
import 'package:shared_ui/utils/hide_keyboard.dart';
import 'package:shared_ui/utils/screen_size.dart';
import 'package:shared_ui/widgets/arogya_sewa_bottom_sheet.dart';
import 'package:shared_ui/widgets/arogya_sewa_button.dart';
import 'package:shared_ui/widgets/arogya_sewa_textform_field.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';

// ignore: must_be_immutable
class ArogyaSewaLoginForm extends StatelessWidget {
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  // final void Function() onSubmit;
  // final void Function() onForgotPassword;
  final void Function(BuildContext context) afterAuthenticationSuccess;
  final void Function() afterAuthenticationFail;
  final String appLogoPath;
  bool obscure;

  final GlobalKey<FormState> formKey;
  
  ArogyaSewaLoginForm({
    super.key,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required this.afterAuthenticationSuccess,
    required this.afterAuthenticationFail,
    required this.appLogoPath,
    required this.formKey,
    this.obscure = true,
  }) : _passwordController = passwordController,
       _emailController = emailController;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode 
        ? ArogyaSewaColors.textColorWhite 
        : ArogyaSewaColors.textColorBlack;
    final hintColor = ArogyaSewaColors.textColorGrey;
    final iconColor = isDarkMode 
        ? ArogyaSewaColors.textColorWhite 
        : ArogyaSewaColors.textColorBlack;
    final primaryColortextColor = isDarkMode 
        ? ArogyaSewaColors.textColorWhite 
        : ArogyaSewaColors.primaryColor;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ArogyaSewaBottomSheet().showAppBottomSheet(
            context,
            type: BottomSheetType.error,
            message: state.error ?? loginFailedStr,
          );
          afterAuthenticationFail();
        }
        if (state is Authenticated) {
          ArogyaSewaBottomSheet().showAppBottomSheet(
            context,
            type: BottomSheetType.success,
            message: loginSuccessStr,
          );
          afterAuthenticationSuccess(context);
        }
      },
      builder: (context, state) {
        if (state is AuthInitial) {
          obscure = state.obscure;
        }

        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.vh(10)),
              
              // Logo
              Center(
                child: Image.asset(appLogoPath, width: 80, height: 80, fit: BoxFit.contain,),
              ),
              
               SizedBox(height: context.vh(4)),
              
              // Welcome Back Text
              Center(
                child: Text(welcomeBackString,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryColortextColor,
                  ),
                ),
              ),
              
               SizedBox(height: context.vh(6)),
              
              // Email Field with outerLabel
              ArogyaSewaTextFormField(
                outerLabel: emailLabel,
                outerLabelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: textColor,
                ),
                controller: _emailController,
                hintText: 'john.doe@example.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 8.0),
                  child: Icon(Icons.mail_outline, color: iconColor),
                ),
                prefixIconColor: iconColor,
                suffixIconColor: iconColor,
                validator: (v) {
                  final value = (v ?? '').trim();
                  if (value.isEmpty) return emailEmptyValidationString;
                  final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                  if (!re.hasMatch(value)) {
                    return emailValidationString;
                  }
                  return null;
                },
              ),
              
               SizedBox(height: context.vh(2)),
              
              // Password Field with outerLabel
              ArogyaSewaTextFormField(
                outerLabel: passwordLabel,
                outerLabelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: textColor,
                ),
                obsecureText: obscure,
                hintText: '••••••••',
                controller: _passwordController,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 8.0),
                  child: Icon(Icons.lock_outline, color: iconColor),
                ),
                prefixIconColor: iconColor,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: iconColor,
                  ),
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      AuthPasswordToggled(obscure: obscure),
                    );
                  },
                ),
                suffixIconColor: iconColor,
                validator: (v) {
                  final value = v ?? '';
                  if (value.isEmpty) return passwordEmptyValidationString;
                  if (value.length < 6) {
                    return passwordLengthValidationString;
                  }
                  return null;
                },
              ),
              
              //  SizedBox(height: context.vh(1)),
              
              // Forgot Password - Right Aligned
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Add your forgot password logic
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      forgotPasswordString,
                      style: TextStyle(
                        color: primaryColortextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              
               SizedBox(height: context.vh(5)),
              // Biometrics Login
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Add biometrics login logic
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(color: primaryColortextColor),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.fingerprint,
                            color: primaryColortextColor,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          biometricLoginString,
                          style: TextStyle(
                            color: primaryColortextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
               SizedBox(height: context.vh(1)),
              
              // Sign In Button with Gradient
              ArogyaSewaButton(
                onPressed: () => _submitLoginForm(context, formKey),
                gradient: ArogyaSewaColors.primrayGraidient,
                foregroundColor: ArogyaSewaColors.textColorWhite,
                height: 52,
                child: Text(
                  loginString,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: ArogyaSewaColors.textColorWhite,
                  ),
                ),
              ),
              
               SizedBox(height: context.vh(2)),
              
              // Sign Up Section
              GestureDetector(
                onTap: () {
                  // Add your sign up navigation logic
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dontHaveAccountString,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: hintColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      signUpString,
                      style: TextStyle(
                        color: primaryColortextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              
              //  SizedBox(height: context.vh(2)),
            ],
          ),
        );
      },
    );
  }

  void _submitLoginForm(BuildContext context, GlobalKey<FormState> formKey) {
    if (!(formKey.currentState?.validate() ?? false)) return;
    HideKeyboard.hide(context);
    context.read<AuthBloc>().add(
      AuthLoginInitiated(
        LoginEntity(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          fcmToken: 'abc',
        ),
      ),
    );
  }
}