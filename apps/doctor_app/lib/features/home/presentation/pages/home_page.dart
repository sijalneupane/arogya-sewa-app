import 'package:doctor_app/core/constants/doctor_app_strings_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_feature/auth/presentation/bloc/auth_state.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';
import 'package:shared_ui/utils/screen_size.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode
        ? ArogyaSewaColors.textColorWhite
        : ArogyaSewaColors.textColorBlack;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          homeString,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkMode
            ? ArogyaSewaColors.primaryColor
            : ArogyaSewaColors.textColorWhite,
        elevation: 0,
        centerTitle: false,
        actions: [
          // User name from AuthBloc
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return Padding(
                  padding: EdgeInsets.only(right: context.vw(2)),
                  child: Row(
                    children: [
                      // User name
                      Text(
                        state.userData.name,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(width: context.vw(1)),
                      // User avatar icon
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: ArogyaSewaColors.primaryColor,
                        child: Icon(
                          Icons.person,
                          size: 18,
                          color: ArogyaSewaColors.textColorWhite,
                        ),
                      ),
                    ],
                  ),
                );
              }
              // Show login prompt or empty container when not authenticated
              return SizedBox.shrink();
            },
          ),
        ],
      ),
      body: const Placeholder(),
    );
  }
}