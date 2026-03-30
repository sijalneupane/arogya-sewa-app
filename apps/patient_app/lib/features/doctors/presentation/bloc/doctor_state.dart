import 'package:equatable/equatable.dart';
import 'package:shared_core/domain/entities/doctor_entity.dart';

abstract class DoctorState extends Equatable {
  const DoctorState();

  @override
  List<Object?> get props => [];
}

class DoctorInitial extends DoctorState {
  const DoctorInitial();
}

class DoctorLoading extends DoctorState {
  const DoctorLoading();
}

class DoctorLoaded extends DoctorState {
  final List<DoctorEntity> doctors;
  final int currentPage;
  final int totalPage;
  final int totalRecords;
  final bool hasReachedMax;

  const DoctorLoaded({
    required this.doctors,
    required this.currentPage,
    required this.totalPage,
    required this.totalRecords,
    required this.hasReachedMax,
  });

  @override
  List<Object?> get props => [
    doctors,
    currentPage,
    totalPage,
    totalRecords,
    hasReachedMax,
  ];
}

class DoctorLoadingMore extends DoctorLoaded {
  const DoctorLoadingMore({
    required super.doctors,
    required super.currentPage,
    required super.totalPage,
    required super.totalRecords,
    required super.hasReachedMax,
  });

  factory DoctorLoadingMore.fromLoaded(DoctorLoaded loaded) {
    return DoctorLoadingMore(
      doctors: loaded.doctors,
      currentPage: loaded.currentPage,
      totalPage: loaded.totalPage,
      totalRecords: loaded.totalRecords,
      hasReachedMax: loaded.hasReachedMax,
    );
  }
}

class DoctorError extends DoctorState {
  final String message;

  const DoctorError(this.message);

  @override
  List<Object?> get props => [message];
}
