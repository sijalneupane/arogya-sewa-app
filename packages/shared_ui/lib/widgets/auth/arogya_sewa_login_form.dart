import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_feature/auth/presentation/bloc/auth_event.dart';
import 'package:shared_feature/auth/presentation/bloc/auth_state.dart';
import 'package:shared_feature/auth/data/models/login_model.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';
import 'package:shared_ui/utils/hide_keyboard.dart';
import 'package:shared_ui/widgets/arogya_sewa_bottom_sheet.dart';
import 'package:shared_ui/widgets/arogya_sewa_button.dart';
import 'package:shared_ui/widgets/arogya_sewa_text_button.dart';
import 'package:shared_ui/widgets/arogya_sewa_textform_field.dart';

// ignore: must_be_immutable
class ArogyaSewaLoginForm extends StatelessWidget {
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  // final void Function() onSubmit;
  // final void Function() onForgotPassword;
  final void Function(BuildContext context) afterAuthenticationSuccess;
  final void Function() afterAuthenticationFail;
  bool obscure;

  final _formKey = GlobalKey<FormState>();
  ArogyaSewaLoginForm({
    super.key,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    // required this.onSubmit,
    // required this.onForgotPassword,
    required this.afterAuthenticationSuccess,
    required this.afterAuthenticationFail,
    this.obscure = true,
  }) : _passwordController = passwordController,
       _emailController = emailController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BlocConsumer<AuthBloc, AuthState>(
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
            key: _formKey,
            child: Column(
              children: [
                ArogyaSewaTextFormField(
                  controller: _emailController,
                  hintText: emailLabel,
                  keyboardType: TextInputType.emailAddress,
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.mail_outline),
                  ),
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
                ArogyaSewaTextFormField(
                  // outerLabel: 'Password',
                  obsecureText: obscure,
                  hintText: passwordLabel,
                  controller: _passwordController,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthPasswordToggled(obscure: obscure));
                    },
                  ),
                  validator: (v) {
                    final value = v ?? '';
                    if (value.isEmpty) return passwordEmptyValidationString;
                    if (value.length < 6) {
                      return passwordLengthValidationString;
                    }
                    return null;
                  },
                ),
                ArogyaSewaTextButton(label: Text(forgotPasswordString)),
                ArogyaSewaButton(
                  onPressed: () => _sumitLoginForm(context, _formKey),
                  child: const Text(loginString),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _sumitLoginForm(BuildContext context, GlobalKey<FormState> formKey) {
    if (!(formKey.currentState?.validate() ?? false)) return;
    HideKeyboard.hide(context);
    context.read<AuthBloc>().add(
      AuthLoginInitiated(
        LoginModel(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          fcmToken: 'abc',
        ),
      ),
    );
  }
}
