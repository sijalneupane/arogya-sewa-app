import 'package:equatable/equatable.dart';
import 'package:shared_core/domain/entities/doctor_entity.dart';

abstract class HomeDoctorState extends Equatable {
  const HomeDoctorState();

  @override
  List<Object?> get props => [];
}

class HomeDoctorInitial extends HomeDoctorState {
  const HomeDoctorInitial();
}

class HomeDoctorLoading extends HomeDoctorState {
  const HomeDoctorLoading();
}

class HomeDoctorLoaded extends HomeDoctorState {
  final List<DoctorEntity> doctors;
  final int currentPage;
  final int totalPage;
  final int totalRecords;
  final bool hasReachedMax;

  const HomeDoctorLoaded({
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

class HomeDoctorLoadingMore extends HomeDoctorLoaded {
  const HomeDoctorLoadingMore({
    required super.doctors,
    required super.currentPage,
    required super.totalPage,
    required super.totalRecords,
    required super.hasReachedMax,
  });

  factory HomeDoctorLoadingMore.fromLoaded(HomeDoctorLoaded loaded) {
    return HomeDoctorLoadingMore(
      doctors: loaded.doctors,
      currentPage: loaded.currentPage,
      totalPage: loaded.totalPage,
      totalRecords: loaded.totalRecords,
      hasReachedMax: loaded.hasReachedMax,
    );
  }
}

class HomeDoctorError extends HomeDoctorState {
  final String message;

  const HomeDoctorError(this.message);

  @override
  List<Object?> get props => [message];
}
