import 'package:dio/dio.dart';
import 'package:patient_app/core/constants/patient_api_const.dart';
import 'package:patient_app/features/payments/data/datasources/khalti_payment_remote_datasource.dart';
import 'package:patient_app/features/payments/data/models/khalti_payment_initiation_model.dart';

class KhaltiPaymentRemoteDataSourceImpl
    implements KhaltiPaymentRemoteDataSource {
  final Dio dio;

  KhaltiPaymentRemoteDataSourceImpl(this.dio);

  @override
  Future<String> initiatePayment(
    KhaltiPaymentInitiationModel payload,
  ) async {
    try {
      final response = await dio.post(
        '${PatientApiConst.baseUrl}/payments/khalti/initiate',
        data: payload.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['pidx'] as String;
      } else {
        throw Exception('Payment initiation failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(e.response?.data['message'] ?? 'Payment initiation failed');
      }
      throw Exception('Payment initiation failed');
    } catch (e) {
      throw Exception('Payment initiation failed');
    }
  }

  @override
  Future<void> verifyPayment({
    required String appointmentId,
    required String pidx,
  }) async {
    try {
      final response = await dio.post(
        '${PatientApiConst.baseUrl}/payments/khalti/verify',
        queryParameters: {
          'appointment_id': appointmentId,
          'pidx': pidx,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }

      throw Exception('Payment verification failed');
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(
          e.response?.data['message'] ?? 'Payment verification failed',
        );
      }
      throw Exception('Payment verification failed');
    } catch (_) {
      throw Exception('Payment verification failed');
    }
  }
}
