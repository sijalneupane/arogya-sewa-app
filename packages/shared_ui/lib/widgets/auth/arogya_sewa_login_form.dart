import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_feature/auth/domain/entity/login_entity.dart';
import 'package:shared_feature/auth/presentation/bloc/login_bloc.dart';
import 'package:shared_feature/auth/presentation/bloc/login_event.dart';
import 'package:shared_feature/auth/presentation/bloc/login_state.dart';
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
  final void Function(BuildContext context) afterAuthenticationSuccess;
  final void Function() afterAuthenticationFail;
  final void Function(bool isLoading)? onLoadingChanged;
  final String appLogoPath;
  bool obscure;
  bool rememberMe;
  final bool popOnSuccess;

  final GlobalKey<FormState> formKey;

  ArogyaSewaLoginForm({
    super.key,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required this.afterAuthenticationSuccess,
    required this.afterAuthenticationFail,
    this.onLoadingChanged,
    required this.appLogoPath,
    required this.formKey,
    this.obscure = true,
    this.rememberMe = false,
    this.popOnSuccess = false,
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

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        onLoadingChanged?.call(state is LoginLoading);

        if (state is LoginFailure) {
          ArogyaSewaBottomSheet().showAppBottomSheet(
            context,
            type: BottomSheetType.error,
            message: state.errorMessage ,
          );
          afterAuthenticationFail();
        }
        if (state is LoginSuccess) {
          ArogyaSewaBottomSheet().showAppBottomSheet(
            context,
            type: BottomSheetType.success,
            message: loginSuccessStr,
          );
          afterAuthenticationSuccess(context);
        }
      },
      builder: (context, state) {
        if (state is LoginInitial) {
          obscure = state.obscurePassword;
        }

        final isLoading = state is LoginLoading;

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
                enabled: !isLoading,
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
                enabled: !isLoading,
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
                  onLongPress: isLoading ? null : () {},
                  icon: Icon(
                    obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: iconColor,
                  ),
                  onPressed: isLoading ? null : () {
                    context.read<LoginBloc>().add(
                      LoginPasswordToggled(!obscure),
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

              // Remember Me Checkbox
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: isLoading ? null : (value) {
                      rememberMe = value ?? false;
                    },
                    activeColor: primaryColortextColor,
                  ),
                  Text(
                    rememberMeString,
                    style: TextStyle(
                      color: isLoading ? ArogyaSewaColors.textColorGrey : textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),

              //  SizedBox(height: context.vh(1)),

              // Forgot Password - Right Aligned
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: isLoading ? null : () {
                    // Add your forgot password logic
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      forgotPasswordString,
                      style: TextStyle(
                        color: isLoading ? ArogyaSewaColors.textColorGrey : primaryColortextColor,
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
                  onTap: isLoading ? null : () {
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
                            border: Border.all(
                              color: isLoading ? ArogyaSewaColors.textColorGrey : primaryColortextColor,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.fingerprint,
                            color: isLoading ? ArogyaSewaColors.textColorGrey : primaryColortextColor,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          biometricLoginString,
                          style: TextStyle(
                            color: isLoading ? ArogyaSewaColors.textColorGrey : primaryColortextColor,
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
                onPressed: isLoading ? null : () => _submitLoginForm(context, formKey),
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
                onTap: isLoading ? null : () {
                  // Add your sign up navigation logic
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dontHaveAccountString,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isLoading ? ArogyaSewaColors.textColorGrey : hintColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      signUpString,
                      style: TextStyle(
                        color: isLoading ? ArogyaSewaColors.textColorGrey : primaryColortextColor,
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
    context.read<LoginBloc>().add(
      LoginSubmitted(
        LoginEntity(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          fcmToken: 'abc',
          rememberMe: rememberMe,
        ),
      ),
    );
  }
}