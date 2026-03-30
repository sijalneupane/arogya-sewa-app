import 'package:dartz/dartz.dart';
import 'package:patient_app/features/home/domain/model/nearest_hospitals_response_entity.dart';
import 'package:shared_core/error/failure.dart';

abstract class HomeRepository {
  Future<Either<Failure, NearestHospitalsResponseEntity>> getNearestHospitals({
    required double latitude,
    required double longitude,
  });
}
