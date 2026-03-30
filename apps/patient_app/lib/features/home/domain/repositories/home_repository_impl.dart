import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart'
  as patient_strings;
import 'package:patient_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:patient_app/features/home/data/model/doctors_query_params_model.dart';
import 'package:patient_app/features/home/domain/model/nearest_hospitals_response_entity.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/error/repository_exception_handler.dart';
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
      return Left(NetworkFailure(noInternetConnectionString));
    }

    try {
      final result = await remoteDataSource.getNearestHospitals(
        latitude: latitude,
        longitude: longitude,
      );
      return Right(result);
    } on DioException catch (e) {
      return handleRepositoryException(
        e,
        unknownError: patient_strings.failedToFetchHospitalsString,
      );
    }
  }

  @override
  Future<Either<Failure, DoctorsResult>> fetchDoctors({
    String? name,
    String? departmentId,
    bool? freeUpcomingOnly,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(noInternetConnectionString));
    }

    try {
      final queryParams = DoctorsQueryParamsModel(
        name: name,
        departmentId: departmentId,
        freeUpcomingOnly: freeUpcomingOnly,
      );
      final result = await remoteDataSource.fetchDoctors(queryParams);
      return Right(result);
    } on DioException catch (e) {
      return handleRepositoryException(
        e,
        unknownError: patient_strings.failedToFetchDoctorsString,
      );
    }
  }
}
