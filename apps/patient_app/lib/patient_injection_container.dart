import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:patient_app/features/doctors/data/datasources/doctor_remote_datasource.dart';
import 'package:patient_app/features/doctors/data/datasources/doctor_remote_datasource_impl.dart';
import 'package:patient_app/features/doctors/domain/repositories/doctor_repository.dart';
import 'package:patient_app/features/doctors/domain/repositories/doctor_repository_impl.dart';
import 'package:patient_app/features/doctors/domain/usecase/fetch_doctors_usecase.dart';
import 'package:patient_app/features/doctors/presentation/bloc/doctor_bloc.dart';
import 'package:patient_app/config/routes/patient_app_router.dart';
import 'package:patient_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:patient_app/features/home/data/datasources/home_remote_datasource_impl.dart';
import 'package:patient_app/features/home/domain/repositories/home_repository.dart';
import 'package:patient_app/features/home/domain/repositories/home_repository_impl.dart';
import 'package:patient_app/features/home/domain/usecase/fetch_nearest_hospitals_usecase.dart';
import 'package:patient_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:patient_app/features/home/presentation/bloc/home_doctor_bloc.dart';
import 'package:shared_core/bloc/notification/notification_bloc.dart';
import 'package:shared_core/network/network_info.dart';
import 'package:shared_core/services/firebase_notification_service.dart';
import 'package:shared_core/services/location_service.dart';
import 'package:shared_core/shared_core_injection_container.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  await registerSharedCoreDependencies(sl);

  // Home Feature Dependencies
  // Datasource
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl<Dio>()),
  );

  // Doctors Feature Dependencies
  // Datasource
  sl.registerLazySingleton<DoctorRemoteDataSource>(
    () => DoctorRemoteDataSourceImpl(sl<Dio>()),
  );

  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: sl<HomeRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  sl.registerLazySingleton<DoctorRepository>(
    () => DoctorRepositoryImpl(
      remoteDataSource: sl<DoctorRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Usecase
  // --------- Home Usecases
  sl.registerLazySingleton<FetchNearestHospitalsUsecase>(
    () => FetchNearestHospitalsUsecase(repository: sl<HomeRepository>()),
  );

  // --------- Doctors Usecases
  sl.registerLazySingleton<FetchDoctorsUsecase>(
    () => FetchDoctorsUsecase(repository: sl<DoctorRepository>()),
  );

  // Bloc
  // --------- Home Blocs
  sl.registerLazySingleton<HomeBloc>(
    () => HomeBloc(
      fetchNearestHospitalsUsecase: sl<FetchNearestHospitalsUsecase>(),
      locationService: sl<LocationService>(),
    ),
  );

  sl.registerLazySingleton<HomeDoctorBloc>(
    () => HomeDoctorBloc(fetchDoctorsUsecase: sl<FetchDoctorsUsecase>()),
  );

  // --------- Doctors Blocs
  sl.registerFactory<DoctorBloc>(
    () => DoctorBloc(fetchDoctorsUsecase: sl<FetchDoctorsUsecase>()),
  );

  await sl.allReady();
  // 3. ⚠️ CRITICAL: Initialize Notification Service AFTER router exists
  await FirebaseNotificationService().setup(
    localNotificationsPlugin: sl<FlutterLocalNotificationsPlugin>(),
    notificationBloc: sl<NotificationBloc>(),
    router: PatientAppRouter.router,
  );
  sl.registerSingleton<FirebaseNotificationService>(
    FirebaseNotificationService(),
  );
}
