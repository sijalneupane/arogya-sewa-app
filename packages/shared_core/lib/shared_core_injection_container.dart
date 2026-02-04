// packages/shared_network/lib/di/register_network_dependencies.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_core/auth/bloc/auth_bloc.dart';
import 'package:shared_core/auth/services/auth_service.dart';
import 'package:shared_core/auth/services/auth_service_impl.dart';
import 'package:shared_core/device/device_info.dart';
import 'package:shared_core/hashing/hashing.dart';
import 'package:shared_core/network/api_client.dart';
import 'package:shared_core/network/network_info.dart';
import 'package:shared_core/splash/bloc/splash_bloc.dart';
import 'package:shared_core/splash/service/splash_service.dart';
import 'package:shared_core/splash/service/splash_service_impl.dart';
import 'package:shared_core/storage/secure_storage.dart';

Future<void> registerSharedCoreDependencies(GetIt sl) async {
  // -------- External
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.options = BaseOptions(
      validateStatus: (status) {
        // to allow handling of all status codes in the data source
        return true;
      },
    );
    return dio;
  });
  // -------- external packages
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  // sl.registerLazySingleton<LocalAuthentication>(() => LocalAuthentication());
  sl.registerSingletonAsync<PackageInfo>(
    () async => await PackageInfo.fromPlatform(),
  );
  sl.registerLazySingleton<DeviceInfoPlugin>(() => DeviceInfoPlugin());
  sl.registerLazySingleton<Hash>(() => sha256);

  // Secure storage wrapper
  sl.registerLazySingleton<SecurePref>(
    () => SecurePref(storage: sl<FlutterSecureStorage>()),
  );

  //   // ApiClient with auth header injection
  sl.registerLazySingleton<ApiClient>(
    () =>
        ApiClient(networkInfo: sl<NetworkInfo>(), securePref: sl<SecurePref>()),
  );
  //   // Hashing utility
  sl.registerLazySingleton<Hashing>(() => Hashing(hash: sl<Hash>()));
  // Network Info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<Connectivity>()),
  );
  //Device Info
  sl.registerLazySingleton<DeviceInfo>(
    () => DeviceInfoImpl(sl<DeviceInfoPlugin>()),
  );
  // Add more shared services...

  // Services dependency
  sl.registerLazySingleton<AuthService>(
    () => AuthServiceImpl(
      apiClient: sl<ApiClient>(),
      securePref: sl<SecurePref>(),
    ),
  );
  sl.registerSingletonAsync<SplashService>(() async {
    final packageInfo = await sl.getAsync<PackageInfo>();
    return SplashServiceImpl(packageInfo: packageInfo);
  });

  sl.registerFactory<AuthBloc>(
    () => AuthBloc(sl<AuthService>()),
  );
  sl.registerFactory<SplashBloc>(() => SplashBloc(splashService: sl<SplashService>()));
}
