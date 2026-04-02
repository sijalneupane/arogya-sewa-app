import 'package:patient_app/features/payments/data/models/khalti_payment_initiation_model.dart';

abstract class KhaltiPaymentRemoteDataSource {
  /// Initiate Khalti payment and return pidx
  Future<String> initiatePayment(
    KhaltiPaymentInitiationModel payload,
  );

  /// Verify Khalti payment on backend after SDK success callback.
  Future<void> verifyPayment({
    required String appointmentId,
    required String pidx,
  });
}
