import 'package:dartz/dartz.dart';
import 'package:shared_core/error/failure.dart';

abstract class KhaltiPaymentRepository {
  Future<Either<Failure, String>> initiatePayment(
    String appointmentId,
    int amount,
    String customerPhone,
  );

  Future<Either<Failure, void>> verifyPayment(
    String appointmentId,
    String pidx,
  );
}
