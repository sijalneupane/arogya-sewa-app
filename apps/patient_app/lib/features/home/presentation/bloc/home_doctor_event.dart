import 'package:equatable/equatable.dart';
import 'package:patient_app/features/doctors/domain/entities/doctors_query_params_entity.dart';

abstract class HomeDoctorEvent extends Equatable {
  const HomeDoctorEvent();

  @override
  List<Object?> get props => [];
}

class FetchHomeDoctorEvent extends HomeDoctorEvent {
  final int page;
  final int size;
  final String? name;
  final String? departmentName;
  final bool? freeUpcomingOnly;

  const FetchHomeDoctorEvent({
    this.page = 1,
    this.size = 10,
    this.name,
    this.departmentName,
    this.freeUpcomingOnly,
  });

  DoctorsQueryParamsEntity get queryParams => DoctorsQueryParamsEntity(
    page: page,
    size: size,
    name: name,
    departmentName: departmentName,
    freeUpcomingOnly: freeUpcomingOnly,
  );

  @override
  List<Object?> get props => [
    page,
    size,
    name,
    departmentName,
    freeUpcomingOnly,
  ];
}

class LoadMoreHomeDoctorEvent extends HomeDoctorEvent {
  final int currentPage;
  final int size;
  final String? name;
  final String? departmentName;
  final bool? freeUpcomingOnly;

  const LoadMoreHomeDoctorEvent({
    required this.currentPage,
    this.size = 10,
    this.name,
    this.departmentName,
    this.freeUpcomingOnly,
  });

  DoctorsQueryParamsEntity get queryParams => DoctorsQueryParamsEntity(
    page: currentPage,
    size: size,
    name: name,
    departmentName: departmentName,
    freeUpcomingOnly: freeUpcomingOnly,
  );

  @override
  List<Object?> get props => [
    currentPage,
    size,
    name,
    departmentName,
    freeUpcomingOnly,
  ];
}

class RetryFetchHomeDoctorEvent extends HomeDoctorEvent {
  final int page;
  final int size;
  final String? name;
  final String? departmentName;
  final bool? freeUpcomingOnly;

  const RetryFetchHomeDoctorEvent({
    this.page = 1,
    this.size = 10,
    this.name,
    this.departmentName,
    this.freeUpcomingOnly,
  });

  @override
  List<Object?> get props => [
    page,
    size,
    name,
    departmentName,
    freeUpcomingOnly,
  ];
}
