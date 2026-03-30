import 'package:dartz/dartz.dart';
import 'package:patient_app/features/doctors/domain/repositories/doctor_detail_repository.dart';
import 'package:shared_core/domain/entities/doctor_detail_entity.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/usecase/usecase.dart';

class FetchDoctorDetailUsecase
    implements UseCase<DoctorDetailEntity, String> {
  final DoctorDetailRepository repository;

  const FetchDoctorDetailUsecase({required this.repository});

  @override
  Future<Either<Failure, DoctorDetailEntity>> call(String doctorId) {
    return repository.getDoctorById(doctorId);
  }
}
