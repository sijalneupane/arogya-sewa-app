import 'package:dartz/dartz.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_feature/splash/data/datasources/splash_local_datasource.dart';
import 'package:shared_feature/splash/domain/repositories/splash_repository.dart';

class SplashRepositoryImpl implements SplashRepository {
  final SplashLocalDataSource local;

  SplashRepositoryImpl({required this.local});

  @override
  Future<Either<Failure, String>> fetchAppVersion() async {
    try {
      final version = await local.getAppVersion();
      return right(version);
    } catch (_) {
      return left(UnknownFailure(versionFetchFailedString));
    }
  }
}
