class KhaltiPaymentInitiationEntity {
  final String appointmentId;
  final int amountPaisa; // Amount in paisa (e.g., 100 = Rs. 1.00)
  final String customerPhone;

  const KhaltiPaymentInitiationEntity({
    required this.appointmentId,
    required this.amountPaisa,
    required this.customerPhone,
  });
}
