import 'package:equatable/equatable.dart';
import 'package:patient_app/features/doctors/domain/entities/doctors_query_params_entity.dart';
import 'package:shared_core/domain/enums/doctor_status_enum.dart';

abstract class DoctorEvent extends Equatable {
  const DoctorEvent();

  @override
  List<Object?> get props => [];
}

class FetchDoctorEvent extends DoctorEvent {
  final int page;
  final int size;
  final String? name;
  final String? departmentName;
  final bool? freeUpcomingOnly;
  final DoctorStatusEnum? status;

  const FetchDoctorEvent({
    this.page = 1,
    this.size = 5,
    this.name,
    this.departmentName,
    this.freeUpcomingOnly,
    this.status,
  });

  DoctorsQueryParamsEntity get queryParams => DoctorsQueryParamsEntity(
    page: page,
    size: size,
    name: name,
    departmentName: departmentName,
    freeUpcomingOnly: freeUpcomingOnly,
    status: status,
  );

  @override
  List<Object?> get props => [
    page,
    size,
    name,
    departmentName,
    freeUpcomingOnly,
    status,
  ];
}

class LoadMoreDoctorEvent extends DoctorEvent {
  final int currentPage;
  final int size;
  final String? name;
  final String? departmentName;
  final bool? freeUpcomingOnly;
  final DoctorStatusEnum? status;

  const LoadMoreDoctorEvent({
    required this.currentPage,
    this.size = 10,
    this.name,
    this.departmentName,
    this.freeUpcomingOnly,
    this.status,
  });

  DoctorsQueryParamsEntity get queryParams => DoctorsQueryParamsEntity(
    page: currentPage,
    size: size,
    name: name,
    departmentName: departmentName,
    freeUpcomingOnly: freeUpcomingOnly,
    status: status,
  );

  @override
  List<Object?> get props => [
    currentPage,
    size,
    name,
    departmentName,
    freeUpcomingOnly,
    status,
  ];
}

class RetryFetchDoctorEvent extends DoctorEvent {
  final int page;
  final int size;
  final String? name;
  final String? departmentName;
  final bool? freeUpcomingOnly;
  final DoctorStatusEnum? status;

  const RetryFetchDoctorEvent({
    this.page = 1,
    this.size = 5,
    this.name,
    this.departmentName,
    this.freeUpcomingOnly,
    this.status,
  });

  @override
  List<Object?> get props => [
    page,
    size,
    name,
    departmentName,
    freeUpcomingOnly,
    status,
  ];
}
