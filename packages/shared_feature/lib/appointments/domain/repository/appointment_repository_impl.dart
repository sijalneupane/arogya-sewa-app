import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/error/repository_exception_handler.dart';
import 'package:shared_core/network/network_info.dart';
import 'package:shared_core/domain/entities/appointment_entity.dart';
import 'package:shared_feature/appointments/data/datasources/appointment_remote_datasource.dart';
import 'package:shared_feature/appointments/data/models/create_appointment_model.dart';
import 'package:shared_feature/appointments/data/models/fetch_my_appointments_query_model.dart';
import 'package:shared_feature/appointments/domain/entities/appointment_list_entity.dart';
import 'package:shared_feature/appointments/domain/entities/create_appointment_entity.dart';
import 'package:shared_feature/appointments/domain/entities/fetch_my_appointments_query_entity.dart';
import 'package:shared_feature/appointments/domain/repository/appointment_repository.dart';

class AppointmentRepositoryImpl extends AppointmentRepository {
  final AppointmentRemoteDataSource remote;
  final NetworkInfo networkInfo;

  AppointmentRepositoryImpl({required this.remote, required this.networkInfo});

  @override
  Future<Either<Failure, AppointmentEntity>> createAppointment(
    CreateAppointmentEntity payload,
  ) async {
    final online = await networkInfo.isConnected;
    if (!online) return left(NetworkFailure(noInternetConnectionString));

    try {
      final model = CreateAppointmentModel.fromEntity(payload);
      final appointment = await remote.createAppointment(model);
      return right(appointment);
    } on DioException catch (e) {
      return handleRepositoryException(
        e,
        unknownError: appointmentCreateFailedString,
      );
    }
  }

  @override
  Future<Either<Failure, AppointmentListEntity>> fetchPatientMyAppointments(
    FetchMyAppointmentsQueryEntity query,
  ) async {
    final online = await networkInfo.isConnected;
    if (!online) return left(NetworkFailure(noInternetConnectionString));

    try {
      final model = FetchMyAppointmentsQueryModel.fromEntity(query);
      final appointments = await remote.fetchPatientMyAppointments(model);
      return right(appointments);
    } on DioException catch (e) {
      return handleRepositoryException(
        e,
        unknownError: appointmentsFetchFailedString,
      );
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> fetchAppointmentById(
    String appointmentId,
  ) async {
    final online = await networkInfo.isConnected;
    if (!online) return left(NetworkFailure(noInternetConnectionString));

    try {
      final appointment = await remote.fetchAppointmentById(appointmentId);
      return right(appointment);
    } on DioException catch (e) {
      return handleRepositoryException(
        e,
        unknownError: appointmentByIdFetchFailedString,
      );
    }
  }
}
