abstract class HomeEvent {
  const HomeEvent();
}

class FetchNearestHospitalsEvent extends HomeEvent {
  final double latitude;
  final double longitude;

  const FetchNearestHospitalsEvent({
    required this.latitude,
    required this.longitude,
  });
}

class RequestLocationPermissionEvent extends HomeEvent {
  const RequestLocationPermissionEvent();
}

class CheckLocationPermissionEvent extends HomeEvent {
  const CheckLocationPermissionEvent();
}
