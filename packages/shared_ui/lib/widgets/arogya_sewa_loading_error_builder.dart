import 'package:flutter/material.dart';
import 'package:shared_ui/utils/screen_size.dart';

class LoadingAndErrorBuilder {
  final Color primaryColor;
  const LoadingAndErrorBuilder({required this.primaryColor});
  Widget Function(BuildContext, Widget, ImageChunkEvent?)?
  customLoadingBuilder({double? height, double? width}) {
    return (context, child, loadingProgress) {
      if (loadingProgress == null) {
        return child;
      }
      return Container(
        decoration: BoxDecoration(color: Colors.grey[300]),
        width: width ?? context.vw(50),
        height: height ?? context.vh(20),
        child: Center(
          child: CircularProgressIndicator(
            color: primaryColor,
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                      (loadingProgress.expectedTotalBytes ?? 1)
                : null,
          ),
        ),
      );
    };
  }

  Widget Function(BuildContext, Object, StackTrace?)? customErrorBuilder({
    double? height,
    double? width,
  }) {
    return (context, error, stackTrace) {
      return Container(
        width: width ?? context.vw(50),
        height: height ?? context.vh(20),
        color: Colors.grey[300],
        child: const Icon(Icons.error),
      );
    };
  }
}
