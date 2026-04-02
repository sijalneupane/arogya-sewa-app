import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:patient_app/features/payments/data/datasources/khalti_payment_remote_datasource.dart';
import 'package:patient_app/features/payments/data/models/khalti_payment_initiation_model.dart';
import 'package:patient_app/features/payments/domain/repositories/khalti_payment_repository.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/error/repository_exception_handler.dart';
import 'package:shared_core/network/network_info.dart';

class KhaltiPaymentRepositoryImpl implements KhaltiPaymentRepository {
  final KhaltiPaymentRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  KhaltiPaymentRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, String>> initiatePayment(
    String appointmentId,
    int amount,
    String customerPhone,
  ) async {
    final online = await networkInfo.isConnected;
    if (!online) return left(NetworkFailure('No internet connection'));

    try {
      final payload = KhaltiPaymentInitiationModel(
        appointmentId: appointmentId,
        amountPaisa: amount,
        customerPhone: customerPhone,
      );
      final pidx = await remoteDataSource.initiatePayment(payload);
      return right(pidx);
    } on DioException catch (e) {
      return handleRepositoryException(
        e,
        unknownError: 'Payment initiation failed',
      );
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyPayment(
    String appointmentId,
    String pidx,
  ) async {
    final online = await networkInfo.isConnected;
    if (!online) return left(NetworkFailure('No internet connection'));

    try {
      await remoteDataSource.verifyPayment(
        appointmentId: appointmentId,
        pidx: pidx,
      );
      return right(null);
    } on DioException catch (e) {
      return handleRepositoryException(
        e,
        unknownError: 'Payment verification failed',
      );
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }
}
