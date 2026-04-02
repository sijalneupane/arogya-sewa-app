import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';
import 'package:patient_app/core/config/khalti_checkout_config.dart';

/// App-level wrapper around Khalti checkout SDK.
class PatientKhaltiCheckoutService {
  static const String _tag = 'PatientKhaltiCheckoutService';

  Future<void> openCheckout({
    required BuildContext context,
    required String pidx,
    required bool enableDebugging,
    required Function(dynamic, Khalti) onPaymentResult,
    required FutureOr<void> Function(Khalti, {Object? description, KhaltiEvent? event, bool? needsPaymentConfirmation, int? statusCode}) onMessage,
    // required Function(
    //   Khalti, {
    //   String? description,
    //   String? statusCode,
    //   String? event,
    //   bool? needsPaymentConfirmation,
    // }) onMessage,
    required Function() onReturn,
  }) async {
    try {
      log('Opening Khalti checkout with pidx: $pidx', name: _tag);

      final payConfig = KhaltiPayConfig(
        publicKey: KhaltiCheckoutConfig.publicKey,
        pidx: pidx,
        environment: KhaltiCheckoutConfig.environment,
      );

      final khalti = await Khalti.init(
        enableDebugging: enableDebugging,
        payConfig: payConfig,
        onPaymentResult: onPaymentResult,
        onMessage: onMessage,
        onReturn: onReturn,
      );

      if (context.mounted) {
        khalti.open(context);
      }
    } catch (e) {
      log('Error opening Khalti checkout: $e', name: _tag);
      rethrow;
    }
  }

  Map<String, dynamic> getConfig() => {
    'publicKey': KhaltiCheckoutConfig.publicKey,
    'environment': KhaltiCheckoutConfig.environment.toString(),
    'debugLogsEnabled': KhaltiCheckoutConfig.enableDebugLogs,
  };
}
