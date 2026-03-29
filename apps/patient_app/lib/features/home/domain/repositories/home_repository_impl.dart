import 'package:dartz/dartz.dart';
import 'package:patient_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:patient_app/features/home/domain/model/nearest_hospitals_response_entity.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/network/network_info.dart';
import 'home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NearestHospitalsResponseEntity>> getNearestHospitals({
    required double latitude,
    required double longitude,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final result = await remoteDataSource.getNearestHospitals(
        latitude: latitude,
        longitude: longitude,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
