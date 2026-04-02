import 'package:dartz/dartz.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/usecase/usecase.dart';
import 'package:patient_app/features/payments/domain/repositories/khalti_payment_repository.dart';
import 'params/verify_khalti_payment_params.dart';

class VerifyKhaltiPaymentUsecase
    implements UseCase<void, VerifyKhaltiPaymentParams> {
  final KhaltiPaymentRepository repository;

  VerifyKhaltiPaymentUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(VerifyKhaltiPaymentParams params) async {
    return repository.verifyPayment(
      params.appointmentId,
      params.pidx,
    );
  }
}
