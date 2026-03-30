import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart'
    as patient_strings;
import 'package:patient_app/features/doctors/data/datasources/doctor_remote_datasource.dart';
import 'package:patient_app/features/doctors/data/model/doctors_query_params_model.dart';
import 'package:patient_app/features/doctors/domain/entities/doctors_query_params_entity.dart';
import 'package:patient_app/features/doctors/domain/repositories/doctor_repository.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';
import 'package:shared_core/domain/entities/doctor_list_entity.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/error/repository_exception_handler.dart';
import 'package:shared_core/network/network_info.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DoctorRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, DoctorListEntity>> fetchDoctors(
    DoctorsQueryParamsEntity queryParams,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(noInternetConnectionString));
    }

    try {
      final model=DoctorsQueryParamsModel.fromEntity(queryParams);
      final result = await remoteDataSource.fetchDoctors(model);
      return Right(result);
    } on DioException catch (e) {
      return handleRepositoryException(
        e,
        unknownError: patient_strings.failedToFetchDoctorsString,
      );
    }
  }
}
