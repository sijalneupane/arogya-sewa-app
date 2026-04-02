import 'package:shared_feature/auth/datasource/user_details_remote_data_source.dart';
import 'package:shared_feature/auth/domain/entity/auth_session_entity.dart';
import 'package:shared_feature/auth/domain/repository/user_details_repository.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/error/repository_exception_handler.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_core/network/network_info.dart';
import 'package:dio/dio.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';

class UserDetailsRepositoryImpl extends UserDetailsRepository {
  final NetworkInfo networkInfo;
  final UserDetailsRemoteDataSource remote;

  UserDetailsRepositoryImpl({
    required this.networkInfo,
    required this.remote,
  });

  @override
  Future<Either<Failure, AuthSessionEntity>> getLoggedInUserDetails() async {
    final online = await networkInfo.isConnected;
    if (!online) return const Left(NetworkFailure(noInternetConnectionString));
    try {
      final session = await remote.fetchLoggedInUserDetails();
      return Right(session);
    } on DioException catch (e) {
      return handleRepositoryException(
        e,
        unknownError: userDetailsFetchFailedString,
      );
    }
  }
}
