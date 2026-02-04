import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_core/splash/service/splash_service.dart';

class SplashServiceImpl extends SplashService{
  final PackageInfo packageInfo;
  SplashServiceImpl({required this.packageInfo});
  @override
  Future<String> findVersion() async {
    return packageInfo.version;
  }
}