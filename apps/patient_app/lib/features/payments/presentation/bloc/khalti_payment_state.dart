import 'package:equatable/equatable.dart';

abstract class KhaltiPaymentState extends Equatable {
  const KhaltiPaymentState();

  @override
  List<Object?> get props => [];
}

class KhaltiPaymentInitial extends KhaltiPaymentState {
  const KhaltiPaymentInitial();
}

class KhaltiPaymentLoading extends KhaltiPaymentState {
  const KhaltiPaymentLoading();
}

class KhaltiPaymentInitiated extends KhaltiPaymentState {
  final String pidx;

  const KhaltiPaymentInitiated(this.pidx);

  @override
  List<Object?> get props => [pidx];
}

class KhaltiPaymentVerifying extends KhaltiPaymentState {
  const KhaltiPaymentVerifying();
}

class KhaltiPaymentSuccess extends KhaltiPaymentState {
  const KhaltiPaymentSuccess();
}

class KhaltiPaymentVerified extends KhaltiPaymentState {
  const KhaltiPaymentVerified();
}

class KhaltiPaymentFailure extends KhaltiPaymentState {
  final String message;

  const KhaltiPaymentFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class KhaltiPaymentCanceled extends KhaltiPaymentState {
  const KhaltiPaymentCanceled();
}
