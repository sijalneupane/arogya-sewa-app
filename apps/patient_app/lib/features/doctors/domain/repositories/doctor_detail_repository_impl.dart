import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart'
    as patient_strings;
import 'package:patient_app/features/doctors/data/datasources/doctor_detail_remote_datasource.dart';
import 'package:patient_app/features/doctors/domain/repositories/doctor_detail_repository.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';
import 'package:shared_core/domain/entities/doctor_detail_entity.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/error/repository_exception_handler.dart';
import 'package:shared_core/network/network_info.dart';

class DoctorDetailRepositoryImpl implements DoctorDetailRepository {
  final DoctorDetailRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DoctorDetailRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, DoctorDetailEntity>> getDoctorById(
    String doctorId,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(noInternetConnectionString));
    }

    try {
      final result = await remoteDataSource.getDoctorById(doctorId);
      return Right(result);
    } on DioException catch (e) {
      return handleRepositoryException(
        e,
        unknownError: patient_strings.failedToFetchDoctorsString,
      );
    }
  }
}
