import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient_app/features/payments/domain/entities/khalti_payment_initiation_entity.dart';
import 'package:patient_app/features/payments/domain/usecases/initiate_khalti_payment_usecase.dart';
import 'package:patient_app/features/payments/domain/usecases/params/verify_khalti_payment_params.dart';
import 'package:patient_app/features/payments/domain/usecases/verify_khalti_payment_usecase.dart';
import 'package:patient_app/features/payments/presentation/bloc/khalti_payment_event.dart';
import 'package:patient_app/features/payments/presentation/bloc/khalti_payment_state.dart';

class KhaltiPaymentBloc extends Bloc<KhaltiPaymentEvent, KhaltiPaymentState> {
  final InitiateKhaltiPaymentUsecase initiateKhaltiPaymentUsecase;
  final VerifyKhaltiPaymentUsecase verifyKhaltiPaymentUsecase;

  KhaltiPaymentBloc({
    required this.initiateKhaltiPaymentUsecase,
    required this.verifyKhaltiPaymentUsecase,
  }) : super(const KhaltiPaymentInitial()) {
    on<InitiateKhaltiPaymentEvent>(_onInitiateKhaltiPayment);
    on<VerifyKhaltiPaymentEvent>(_onVerifyKhaltiPayment);
    on<ResetKhaltiPaymentEvent>(_onResetKhaltiPayment);
  }

  Future<void> _onInitiateKhaltiPayment(
    InitiateKhaltiPaymentEvent event,
    Emitter<KhaltiPaymentState> emit,
  ) async {
    emit(const KhaltiPaymentLoading());

    final result = await initiateKhaltiPaymentUsecase.call(
      KhaltiPaymentInitiationEntity(appointmentId: event.appointmentId, amountPaisa: event.amount, customerPhone: event.customerPhone)
    );

    result.fold(
      (failure) => emit(KhaltiPaymentFailure(failure.message)),
      (pidx) => emit(KhaltiPaymentInitiated(pidx)),
    );
  }

  Future<void> _onVerifyKhaltiPayment(
    VerifyKhaltiPaymentEvent event,
    Emitter<KhaltiPaymentState> emit,
  ) async {
    emit(const KhaltiPaymentVerifying());

    final result = await verifyKhaltiPaymentUsecase.call(
      VerifyKhaltiPaymentParams(
        appointmentId: event.appointmentId,
        pidx: event.pidx,
      ),
    );

    result.fold(
      (failure) => emit(KhaltiPaymentFailure(failure.message)),
      (_) => emit(const KhaltiPaymentVerified()),
    );
  }

  Future<void> _onResetKhaltiPayment(
    ResetKhaltiPaymentEvent event,
    Emitter<KhaltiPaymentState> emit,
  ) async {
    emit(const KhaltiPaymentInitial());
  }
}
