import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:patient_app/features/home/domain/usecase/fetch_nearest_hospitals_usecase.dart';
import 'package:shared_core/services/location_service.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchNearestHospitalsUsecase fetchNearestHospitalsUsecase;
  final LocationService locationService;

  HomeBloc({
    required this.fetchNearestHospitalsUsecase,
    required this.locationService,
  }) : super(const HomeInitial()) {
    on<FetchNearestHospitalsEvent>(_onFetchNearestHospitals);
    on<CheckLocationPermissionEvent>(_onCheckLocationPermission);
    on<RequestLocationPermissionEvent>(_onRequestLocationPermission);
  }

  Future<void> _onFetchNearestHospitals(
    FetchNearestHospitalsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const NearestHospitalsLoading());

    final result = await fetchNearestHospitalsUsecase(
      FetchNearestHospitalsParams(
        latitude: event.latitude,
        longitude: event.longitude,
      ),
    );

    result.fold(
      (failure) => emit(NearestHospitalsError(failure.message)),
      (response) => emit(NearestHospitalsLoaded(response.hospitals)),
    );
  }

  Future<void> _onCheckLocationPermission(
    CheckLocationPermissionEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const LocationPermissionCheckLoading());

    final permission = await locationService.checkLocationPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      emit(const LocationPermissionDenied());
    } else if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      emit(const LocationPermissionGranted());
    } else {
      emit(const LocationPermissionDenied());
    }
  }

  Future<void> _onRequestLocationPermission(
    RequestLocationPermissionEvent event,
    Emitter<HomeState> emit,
  ) async {
    final permission = await locationService.requestLocationPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      emit(const LocationPermissionDenied());
    } else if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      emit(const LocationPermissionGranted());
    } else {
      emit(const LocationPermissionDenied());
    }
  }
}
