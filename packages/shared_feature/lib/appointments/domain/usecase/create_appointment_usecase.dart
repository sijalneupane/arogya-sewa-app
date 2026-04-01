import 'package:dartz/dartz.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/domain/entities/appointment_entity.dart';
import 'package:shared_core/usecase/usecase.dart';
import 'package:shared_feature/appointments/domain/entities/create_appointment_entity.dart';
import 'package:shared_feature/appointments/domain/repository/appointment_repository.dart';

class CreateAppointmentUsecase
    implements UseCase<AppointmentEntity, CreateAppointmentEntity> {
  final AppointmentRepository repo;

  CreateAppointmentUsecase(this.repo);

  @override
  Future<Either<Failure, AppointmentEntity>> call(
    CreateAppointmentEntity params,
  ) async {
    return repo.createAppointment(params);
  }
}
