import 'package:get_it/get_it.dart';
import 'package:shared_feature/auth/datasource/user_details_remote_data_source.dart';
import 'package:shared_feature/auth/datasource/user_details_remote_data_source_impl.dart';
import 'package:shared_feature/auth/domain/repository/user_details_repository.dart';
import 'package:shared_feature/auth/repository/user_details_repository_impl.dart';
import 'package:shared_feature/auth/domain/usecase/fetch_user_details_usecase.dart';
import 'package:shared_feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_feature/auth/presentation/bloc/login_bloc.dart';
import 'package:shared_feature/auth/domain/usecase/login_usecase.dart';

/// Registers all auth-related dependencies in shared_feature.
void registerAuthFeatureDependencies(GetIt sl) {
  // ============ Data Sources ============
  // User details remote data source
  sl.registerLazySingleton<UserDetailsRemoteDataSource>(
    () => UserDetailsRemoteDataSourceImpl(apiClient: sl()),
  );

  // ============ Repositories ============
  // User details repository for fetching logged-in user details
  sl.registerLazySingleton<UserDetailsRepository>(
    () => UserDetailsRepositoryImpl(
      networkInfo: sl(),
      remote: sl(),
    ),
  );

  // ============ Use Cases ============
  // Fetch user details use case
  sl.registerLazySingleton<FetchUserDetailsUsecase>(
    () => FetchUserDetailsUsecase(sl<UserDetailsRepository>()),
  );

  // ============ BLoCs ============
  // Login bloc for handling login form
  sl.registerFactory<LoginBloc>(
    () => LoginBloc(loginUsecase: sl<LoginUsecase>()),
  );

  // Auth bloc for global authentication state
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(fetchUserDetailsUsecase: sl<FetchUserDetailsUsecase>()),
  );
}
