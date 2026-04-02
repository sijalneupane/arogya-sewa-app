import 'package:patient_app/features/payments/domain/entities/khalti_payment_initiation_entity.dart';

class KhaltiPaymentInitiationModel extends KhaltiPaymentInitiationEntity {
  const KhaltiPaymentInitiationModel({
    required super.appointmentId,
    required super.amountPaisa,
    required super.customerPhone,
  });

  factory KhaltiPaymentInitiationModel.fromJson(Map<String, dynamic> json) {
    return KhaltiPaymentInitiationModel(
      appointmentId: json['appointment_id'] as String? ?? '',
      amountPaisa: json['amount_paisa'] as int? ?? 0,
      customerPhone: json['customer_phone'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
      'amount_paisa': amountPaisa, // Convert paisa to rupees
      'customer_phone': customerPhone,
    };
  }

  factory KhaltiPaymentInitiationModel.fromEntity(
    KhaltiPaymentInitiationEntity entity,
  ) {
    return KhaltiPaymentInitiationModel(
      appointmentId: entity.appointmentId,
      amountPaisa: entity.amountPaisa,
      customerPhone: entity.customerPhone,
    );
  }
}
