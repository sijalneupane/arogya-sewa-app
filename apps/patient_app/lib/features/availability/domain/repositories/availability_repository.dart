import 'package:dartz/dartz.dart';
import 'package:shared_core/domain/entities/availability_query_params_entity.dart';
import 'package:shared_core/domain/entities/doctor_availability_list_entity.dart';
import 'package:shared_core/error/failure.dart';

abstract class AvailabilityRepository {
  Future<Either<Failure, DoctorAvailabilityListEntity>> fetchDoctorAvailabilities(
    AvailabilityQueryParamsEntity queryParams,
  );
}
