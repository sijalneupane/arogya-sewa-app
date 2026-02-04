import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_ui/utils/screen_size.dart';

class ArogyaSewaLoader {
  static BackdropFilter backdropFilter(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 3),
      child: Stack(
        children: [
          Center(
            child: SpinKitFadingCircle(color:Theme.of(context).colorScheme.primary, size: 55),
          ),
          Container(
            height: context.screenHeight,
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
