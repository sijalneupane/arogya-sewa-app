import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient_app/features/auth/presentation/bloc/patient_login_event.dart';
import 'package:patient_app/features/auth/presentation/bloc/patient_login_state.dart';

class PatientLoginBloc extends Bloc<PatientLoginEvent, PatientLoginState> {
  PatientLoginBloc() : super(const PatientLoginInitial()) {
    on<PatientLoginLoadingChanged>(_onPatientLoginLoadingChanged);
  }

  void _onPatientLoginLoadingChanged(
    PatientLoginLoadingChanged event,
    Emitter<PatientLoginState> emit,
  ) {
    if (event.isLoading) {
      if (state is PatientLoginLoading) return;
      emit(const PatientLoginLoading());
      return;
    }

    if (state is PatientLoginInitial) return;
    emit(const PatientLoginInitial());
  }
}