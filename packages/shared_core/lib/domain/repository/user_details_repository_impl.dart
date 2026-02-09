import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';
import 'package:shared_core/data/datasources/user_details_remote_datasource.dart';
import 'package:shared_core/domain/entities/user_entity.dart';
import 'package:shared_core/domain/repository/user_details_repository.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/error/repository_exception_handler.dart';
import 'package:shared_core/network/network_info.dart';

class UserDetailsRepositoryImpl extends UserDetailsRepository {
  final NetworkInfo networkInfo;
  final UserDetailsRemoteDataSource remote;
  UserEntity? _cachedUser;
  UserDetailsRepositoryImpl({required this.networkInfo, required this.remote});
  @override
  Future<Either<Failure, UserEntity>> getLoggedInUserDetails() async {
    if (_cachedUser != null) return Right(_cachedUser!);
    final online = await networkInfo.isConnected;
    if (!online) return Left(NetworkFailure(noInternetConnectionString));
    try {
      final user = await remote.fetchLoggedInUserDetails();
      _cachedUser = user;
      return Right(user);
    } on DioException catch (e) {
      return handleRepositoryException(
        e,
        unknownError: userDetailsFetchFailedString,
      );
    }
  }

  @override
  Future<Either<Failure, void>> clearUserDetails() async {
 try {
      _cachedUser = null;
      return Right(null);
    } catch (e) {
      return Left(UnknownFailure(userDetailsClearFailedString));
    }
  }
}
