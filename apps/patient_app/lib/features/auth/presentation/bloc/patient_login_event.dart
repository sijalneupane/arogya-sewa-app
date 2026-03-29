abstract class PatientLoginEvent {
  const PatientLoginEvent();
}

class PatientLoginLoadingChanged extends PatientLoginEvent {
  final bool isLoading;

  const PatientLoginLoadingChanged(this.isLoading);
}