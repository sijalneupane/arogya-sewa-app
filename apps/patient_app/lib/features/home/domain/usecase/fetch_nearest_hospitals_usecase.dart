import 'package:dartz/dartz.dart';
import 'package:patient_app/features/home/domain/model/nearest_hospitals_response_entity.dart';
import 'package:patient_app/features/home/domain/repositories/home_repository.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/usecase/usecase.dart';

class FetchNearestHospitalsUsecase
    implements
        UseCase<NearestHospitalsResponseEntity, FetchNearestHospitalsParams> {
  final HomeRepository repository;

  FetchNearestHospitalsUsecase({required this.repository});

  @override
  Future<Either<Failure, NearestHospitalsResponseEntity>> call(
    FetchNearestHospitalsParams params,
  ) {
    return repository.getNearestHospitals(
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}

class FetchNearestHospitalsParams {
  final double latitude;
  final double longitude;

  FetchNearestHospitalsParams({
    required this.latitude,
    required this.longitude,
  });
}
