import 'package:dartz/dartz.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/domain/entities/appointment_entity.dart';
import 'package:shared_core/usecase/usecase.dart';
import 'package:shared_feature/appointments/domain/repository/appointment_repository.dart';

class FetchAppointmentByIdUsecase implements UseCase<AppointmentEntity, String> {
  final AppointmentRepository repo;

  FetchAppointmentByIdUsecase(this.repo);

  @override
  Future<Either<Failure, AppointmentEntity>> call(String params) async {
    return repo.fetchAppointmentById(params);
  }
}
