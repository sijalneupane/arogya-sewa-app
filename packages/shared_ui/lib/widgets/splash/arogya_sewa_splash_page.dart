import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';
import 'package:shared_feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_feature/auth/presentation/bloc/auth_event.dart';
import 'package:shared_feature/splash/presentation/bloc/splash_bloc.dart';
import 'package:shared_feature/splash/presentation/bloc/splash_event.dart';
import 'package:shared_feature/splash/presentation/bloc/splash_state.dart';
import 'package:shared_ui/utils/screen_size.dart';

class ArogyaSewaSplashPage extends StatefulWidget {
  final String appLogoImgPath;
  final String appTitle;
  final void Function(bool isRememberMe) afterDelayNavigate;
  const ArogyaSewaSplashPage({
    super.key,
    required this.appLogoImgPath,
    required this.appTitle,
    required this.afterDelayNavigate,
  });

  @override
  State<ArogyaSewaSplashPage> createState() => _ArogyaSewaSplashPageState();
}

class _ArogyaSewaSplashPageState extends State<ArogyaSewaSplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(const FetchVersionEvent());
  }

  void _navigateAfterDelay(bool isRememberMe) {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        widget.afterDelayNavigate(isRememberMe);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: context.vh(10)),
                child: Image.asset(widget.appLogoImgPath, width: context.vw(30)),
              ),
            ),
            Positioned(
              bottom: context.vh(10),
              child: SizedBox(
                width: context.screenWidth,
                child: Center(
                  child: BlocConsumer<SplashBloc, SplashState>(
                    listener: (context, state) {
                      if (state is SplashLoaded) {
                        // Version loaded, now fetch remember me status
                        context.read<SplashBloc>().add(const FetchRememberMeValue());
                      } else if (state is SplashLoadedRememberMe) {
                        if (state.isRememberMe) {
                          // Remember me is true, fetch logged-in user details
                          context.read<AuthBloc>().add(const FetchLoggedInUser());
                        }
                        // Navigate in both cases (remember me or not)
                        _navigateAfterDelay(state.isRememberMe);
                      }
                    },
                    builder: (context, state) {
                      String versionText = "";
                      if (state is SplashLoaded) {
                        versionText = state.version;
                      } else if (state is SplashFailure) {
                        versionText = dashString; // fallback on failure
                      }
                      return Column(
                        children: [
                          Text(
                            "$versionLabelString $versionText",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            widget.appTitle,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
