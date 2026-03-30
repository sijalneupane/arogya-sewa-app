import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart'
    as patient_strings;
import 'package:patient_app/features/availability/data/datasources/availability_remote_datasource.dart';
import 'package:patient_app/features/availability/domain/repositories/availability_repository.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/error/repository_exception_handler.dart';
import 'package:shared_core/network/network_info.dart';
import 'package:shared_core/shared_core.dart';

class AvailabilityRepositoryImpl implements AvailabilityRepository {
  final AvailabilityRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AvailabilityRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, DoctorAvailabilityListEntity>> fetchDoctorAvailabilities(
    AvailabilityQueryParamsEntity queryParams,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(noInternetConnectionString));
    }

    try {
      final model = AvailabilityQueryParamsModel.fromEntity(queryParams);
      final result = await remoteDataSource.fetchDoctorAvailabilities(model);
      return Right(result);
    } on DioException catch (e) {
      return handleRepositoryException(
        e,
        unknownError: patient_strings.failedToFetchDoctorsString,
      );
    }
  }
}
