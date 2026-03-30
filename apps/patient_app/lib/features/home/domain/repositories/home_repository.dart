import 'package:dartz/dartz.dart';
import 'package:shared_core/error/failure.dart';
import 'package:patient_app/features/home/domain/model/nearest_hospitals_response_entity.dart';
import 'package:patient_app/features/home/data/datasources/home_remote_datasource.dart';

abstract class HomeRepository {
  Future<Either<Failure, NearestHospitalsResponseEntity>> getNearestHospitals({
    required double latitude,
    required double longitude,
  });

  /// Fetches doctors list with optional query parameters
  Future<Either<Failure, DoctorsResult>> fetchDoctors({
    String? name,
    String? departmentId,
    bool? freeUpcomingOnly,
  });
}
