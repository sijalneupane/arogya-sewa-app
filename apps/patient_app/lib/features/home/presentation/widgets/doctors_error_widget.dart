import 'package:flutter/material.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart';
import 'package:shared_ui/widgets/arogya_sewa_retry_widget.dart';

/// Error widget for doctors list with retry option
class DoctorsErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const DoctorsErrorWidget({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ArogyaSewaRetryWidget(
      message: failedToFetchDoctorsString,
      onRetry: onRetry,
      useCard: false,
      buttonText: retryString,
    );
  }
}
