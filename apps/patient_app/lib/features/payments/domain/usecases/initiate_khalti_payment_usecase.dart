import 'package:dartz/dartz.dart';
import 'package:patient_app/features/payments/domain/entities/khalti_payment_initiation_entity.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/usecase/usecase.dart';
import 'package:patient_app/features/payments/domain/repositories/khalti_payment_repository.dart';

class InitiateKhaltiPaymentUsecase
    implements UseCase<String, KhaltiPaymentInitiationEntity> {
  final KhaltiPaymentRepository repository;

  InitiateKhaltiPaymentUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(KhaltiPaymentInitiationEntity params) async {
    return repository.initiatePayment(
      params.appointmentId,
      params.amountPaisa,
      params.customerPhone,
    );
  }
}
