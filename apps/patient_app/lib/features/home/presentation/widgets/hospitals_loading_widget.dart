import 'package:flutter/material.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';
import 'package:shared_ui/utils/screen_size.dart';

/// Loading state widget for nearest hospitals horizontal list
class HospitalsLoadingWidget extends StatelessWidget {
  const HospitalsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.vh(25),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: ArogyaSewaColors.primaryColor,
            ),
            SizedBox(height: context.vh(1.5)),
            Text(
              fetchingHospitalsString,
              style: TextStyle(
                color: ArogyaSewaColors.textColorGrey,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
