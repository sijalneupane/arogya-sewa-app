import 'package:dartz/dartz.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/domain/entities/appointment_entity.dart';
import 'package:shared_feature/appointments/domain/entities/appointment_list_entity.dart';
import 'package:shared_feature/appointments/domain/entities/create_appointment_entity.dart';
import 'package:shared_feature/appointments/domain/entities/fetch_my_appointments_query_entity.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, AppointmentEntity>> createAppointment(
    CreateAppointmentEntity payload,
  );

  Future<Either<Failure, AppointmentListEntity>> fetchPatientMyAppointments(
    FetchMyAppointmentsQueryEntity query,
  );

  Future<Either<Failure, AppointmentEntity>> fetchAppointmentById(
    String appointmentId,
  );
}
