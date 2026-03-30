import 'package:dartz/dartz.dart';
import 'package:patient_app/features/doctors/domain/entities/doctors_query_params_entity.dart';
import 'package:shared_core/domain/entities/doctor_list_entity.dart';
import 'package:shared_core/error/failure.dart';

abstract class DoctorRepository {
  Future<Either<Failure, DoctorListEntity>> fetchDoctors(
    DoctorsQueryParamsEntity queryParams,
  );
}
