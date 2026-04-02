import 'package:equatable/equatable.dart';

abstract class KhaltiPaymentEvent extends Equatable {
  const KhaltiPaymentEvent();

  @override
  List<Object?> get props => [];
}

class InitiateKhaltiPaymentEvent extends KhaltiPaymentEvent {
  final String appointmentId;
  final int amount; // in paisa
  final String customerPhone;

  const InitiateKhaltiPaymentEvent({
    required this.appointmentId,
    required this.amount,
    required this.customerPhone,
  });

  @override
  List<Object?> get props => [appointmentId, amount, customerPhone];
}

class VerifyKhaltiPaymentEvent extends KhaltiPaymentEvent {
  final String appointmentId;
  final String pidx;

  const VerifyKhaltiPaymentEvent({
    required this.appointmentId,
    required this.pidx,
  });

  @override
  List<Object?> get props => [appointmentId, pidx];
}

class ResetKhaltiPaymentEvent extends KhaltiPaymentEvent {
  const ResetKhaltiPaymentEvent();
}
