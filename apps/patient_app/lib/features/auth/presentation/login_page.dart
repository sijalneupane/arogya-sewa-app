import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:patient_app/config/routes/routes_name.dart';
import 'package:patient_app/features/auth/presentation/bloc/patient_login_bloc.dart';
import 'package:patient_app/features/auth/presentation/bloc/patient_login_event.dart';
import 'package:patient_app/features/auth/presentation/bloc/patient_login_state.dart';
import 'package:shared_ui/utils/screen_size.dart';
import 'package:shared_ui/widgets/auth/arogya_sewa_login_form.dart';
import 'package:shared_ui/widgets/arogya_sewa_loader.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart' as patient_strings;

class PatientLoginPage extends StatelessWidget {
  PatientLoginPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PatientLoginBloc(),
      child: Builder(
        builder: (pageContext) {
          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: pageContext.vw(2.5),
                        vertical: pageContext.vh(2.5),
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
                        onLoadingChanged: (isLoading) {
                          pageContext.read<PatientLoginBloc>().add(
                            PatientLoginLoadingChanged(isLoading),
                          );
                        },
                        appLogoPath: patient_strings.appLogoWhiteBgPath,
                        formKey: formKey,
                      ),
                    ),
                  ),
                  BlocBuilder<PatientLoginBloc, PatientLoginState>(
                    builder: (context, state) {
                      if (state is! PatientLoginLoading) {
                        return const SizedBox.shrink();
                      }
                      return Positioned.fill(
                        child: ArogyaSewaLoader.backdropFilter(context),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
