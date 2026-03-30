import 'package:shared_core/domain/entities/hospital_entity.dart';

abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class LocationPermissionGranted extends HomeState {
  const LocationPermissionGranted();
}

class LocationPermissionDenied extends HomeState {
  const LocationPermissionDenied();
}

class LocationPermissionCheckLoading extends HomeState {
  const LocationPermissionCheckLoading();
}

class NearestHospitalsLoading extends HomeState {
  const NearestHospitalsLoading();
}

class NearestHospitalsLoaded extends HomeState {
  final List<HospitalEntity> hospitals;

  const NearestHospitalsLoaded(this.hospitals);
}

class NearestHospitalsError extends HomeState {
  final String message;

  const NearestHospitalsError(this.message);
}

class TopDoctorsLoading extends HomeState {
  const TopDoctorsLoading();
}

class TopDoctorsLoaded extends HomeState {
  final List<String> doctorList;

  const TopDoctorsLoaded(this.doctorList);
}

class TopDoctorsLoadingFailed extends HomeState {
  final String message;

  const TopDoctorsLoadingFailed(this.message);
}

class HomeLoaded extends HomeState {
  const HomeLoaded();
}
