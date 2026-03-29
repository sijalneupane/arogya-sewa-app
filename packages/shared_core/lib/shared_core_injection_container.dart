// packages/shared_network/lib/di/register_network_dependencies.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_core/bloc/notification/notification_bloc.dart';
import 'package:shared_feature/auth/data/datasources/auth_remote_dataseource_impl.dart';
import 'package:shared_feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:shared_feature/auth/domain/usecase/login_usecase.dart';
import 'package:shared_feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_feature/auth/domain/repository/auth_repository.dart';
import 'package:shared_feature/auth/domain/repository/auth_repository_impl.dart';
import 'package:shared_core/device/device_info.dart';
import 'package:shared_core/hashing/hashing.dart';
import 'package:shared_core/network/api_client.dart';
import 'package:shared_core/network/network_info.dart';
import 'package:shared_feature/splash/data/datasources/splash_local_datasource.dart';
import 'package:shared_feature/splash/data/datasources/splash_local_datasource_impl.dart';
import 'package:shared_feature/splash/domain/repositories/splash_repository.dart';
import 'package:shared_feature/splash/domain/repositories/splash_repository_impl.dart';
import 'package:shared_feature/splash/domain/usecases/fetch_app_version_usecase.dart';
import 'package:shared_feature/splash/presentation/bloc/splash_bloc.dart';
import 'package:shared_core/storage/secure_storage.dart';
import 'package:shared_core/services/location_service.dart';

Future<void> registerSharedCoreDependencies(GetIt sl) async {
  // -------- External
  // flutter local notifications plugin;
sl.registerSingleton<FlutterLocalNotificationsPlugin>( FlutterLocalNotificationsPlugin());

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
  // Location Service
  sl.registerLazySingleton<LocationService>(
    () => LocationService(),
  );
  // Add more shared services...

  // datasource dependencies
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<Dio>()),
  );


  // Splash local
  sl.registerSingletonAsync<SplashLocalDataSource>(() async {
    final packageInfo = await sl.getAsync<PackageInfo>();
    return SplashLocalDataSourceImpl(packageInfo: packageInfo);
  });

  // repository dependency
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
     networkInfo: sl<NetworkInfo>(),
     remote: sl<AuthRemoteDataSource>(),
      securePref: sl<SecurePref>(),
    ),
  );

  sl.registerLazySingleton<SplashRepository>(
    () => SplashRepositoryImpl(local: sl<SplashLocalDataSource>()),
  );

// use case dependencies
//-- auth use cases
  sl.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(sl<AuthRepository>()),
  );
  // -- splash use cases
  
  sl.registerLazySingleton<FetchAppVersionUsecase>(
    () => FetchAppVersionUsecase(sl<SplashRepository>()),
  );

  // bloc dependencies
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(loginUsecase: sl<LoginUsecase>()),
  );
    // -- splash bloc
  sl.registerFactory<SplashBloc>(
    () => SplashBloc(fetchAppVersion: sl<FetchAppVersionUsecase>()),
  );
  sl.registerFactory<NotificationBloc>(
    () => NotificationBloc(),
  );
}
