import 'package:equatable/equatable.dart';

abstract class PatientLoginState extends Equatable {
  const PatientLoginState();

  @override
  List<Object?> get props => [];
}

class PatientLoginInitial extends PatientLoginState {
  const PatientLoginInitial();
}

class PatientLoginLoading extends PatientLoginState {
  const PatientLoginLoading();
}