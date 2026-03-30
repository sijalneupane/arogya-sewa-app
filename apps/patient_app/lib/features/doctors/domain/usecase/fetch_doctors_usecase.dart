import 'package:dartz/dartz.dart';
import 'package:patient_app/features/doctors/domain/entities/doctors_query_params_entity.dart';
import 'package:patient_app/features/doctors/domain/repositories/doctor_repository.dart';
import 'package:shared_core/domain/entities/doctor_list_entity.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/usecase/usecase.dart';

class FetchDoctorsUsecase
    implements UseCase<DoctorListEntity, DoctorsQueryParamsEntity> {
  final DoctorRepository repository;

  const FetchDoctorsUsecase({required this.repository});

  @override
  Future<Either<Failure, DoctorListEntity>> call(
    DoctorsQueryParamsEntity params,
  ) {
    return repository.fetchDoctors(params);
  }
}
