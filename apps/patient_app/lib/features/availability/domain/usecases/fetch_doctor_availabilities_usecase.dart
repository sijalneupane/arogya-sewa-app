import 'package:dartz/dartz.dart';
import 'package:patient_app/features/availability/domain/repositories/availability_repository.dart';
import 'package:shared_core/domain/entities/availability_query_params_entity.dart';
import 'package:shared_core/domain/entities/doctor_availability_list_entity.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/usecase/usecase.dart';

class FetchDoctorAvailabilitiesUsecase
    implements UseCase<DoctorAvailabilityListEntity, AvailabilityQueryParamsEntity> {
  final AvailabilityRepository repository;

  const FetchDoctorAvailabilitiesUsecase({required this.repository});

  @override
  Future<Either<Failure, DoctorAvailabilityListEntity>> call(
    AvailabilityQueryParamsEntity params,
  ) {
    return repository.fetchDoctorAvailabilities(params);
  }
}
