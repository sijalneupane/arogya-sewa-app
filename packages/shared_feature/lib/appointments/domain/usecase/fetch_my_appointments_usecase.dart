import 'package:dartz/dartz.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/usecase/usecase.dart';
import 'package:shared_feature/appointments/domain/entities/appointment_list_entity.dart';
import 'package:shared_feature/appointments/domain/entities/fetch_my_appointments_query_entity.dart';
import 'package:shared_feature/appointments/domain/repository/appointment_repository.dart';

class FetchMyAppointmentsUsecase
    implements UseCase<AppointmentListEntity, FetchMyAppointmentsQueryEntity> {
  final AppointmentRepository repo;

  FetchMyAppointmentsUsecase(this.repo);

  @override
  Future<Either<Failure, AppointmentListEntity>> call(
    FetchMyAppointmentsQueryEntity params,
  ) async {
    return repo.fetchPatientMyAppointments(params);
  }
}
