import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_feature/splash/data/datasources/splash_local_datasource.dart';

class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  final PackageInfo packageInfo;
  SplashLocalDataSourceImpl({required this.packageInfo});
  @override
  Future<String> getAppVersion() async {
    return packageInfo.version;
  }
}
