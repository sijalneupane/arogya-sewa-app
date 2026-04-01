import 'package:dio/dio.dart';
import 'package:shared_core/constants/arogya_sewa_api_const.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';
import 'package:shared_core/data/models/appointment_model.dart';
import 'package:shared_core/error/datasource_exception_handler.dart';
import 'package:shared_feature/appointments/data/datasources/appointment_remote_datasource.dart';
import 'package:shared_feature/appointments/data/models/appointment_list_model.dart';
import 'package:shared_feature/appointments/data/models/create_appointment_model.dart';
import 'package:shared_feature/appointments/data/models/fetch_my_appointments_query_model.dart';

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final Dio dio;

  AppointmentRemoteDataSourceImpl(this.dio);

  @override
  Future<AppointmentModel> createAppointment(CreateAppointmentModel payload) async {
    try {
      final response = await dio.post(
        ArogyaSewaApiConst.appointmentsUrl,
        data: payload.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.data as Map<String, dynamic>;
        return AppointmentModel.fromJson(body['data'] as Map<String, dynamic>);
      }

      throw returnKnownDioException(response, appointmentCreateFailedString);
    } catch (e) {
      throw handleDataSourceDioException(
        e,
        path: ArogyaSewaApiConst.appointmentsUrl,
      );
    }
  }

  @override
  Future<AppointmentListModel> fetchPatientMyAppointments(
    FetchMyAppointmentsQueryModel query,
  ) async {
    try {
      final response = await dio.get(
        ArogyaSewaApiConst.patientMyAppointmentsUrl,
        queryParameters: query.toQueryParams(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.data as Map<String, dynamic>;
        return AppointmentListModel.fromJson(body);
      }

      throw returnKnownDioException(response, appointmentsFetchFailedString);
    } catch (e) {
      throw handleDataSourceDioException(
        e,
        path: ArogyaSewaApiConst.patientMyAppointmentsUrl,
      );
    }
  }

  @override
  Future<AppointmentModel> fetchAppointmentById(String appointmentId) async {
    final path = '${ArogyaSewaApiConst.appointmentsUrl}/$appointmentId';

    try {
      final response = await dio.get(path);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.data as Map<String, dynamic>;
        return AppointmentModel.fromJson(body['data'] as Map<String, dynamic>);
      }

      throw returnKnownDioException(response, appointmentByIdFetchFailedString);
    } catch (e) {
      throw handleDataSourceDioException(e, path: path);
    }
  }
}
