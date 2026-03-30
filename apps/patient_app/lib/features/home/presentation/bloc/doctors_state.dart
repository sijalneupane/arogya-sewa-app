import 'package:equatable/equatable.dart';
import 'package:shared_core/domain/entities/doctor_entity.dart';

/// Base class for all doctors states
abstract class DoctorsState extends Equatable {
  const DoctorsState();

  @override
  List<Object?> get props => [];
}

/// Initial state for doctors
class DoctorsInitial extends DoctorsState {
  const DoctorsInitial();
}

/// Loading state when fetching doctors for the first time
class DoctorsLoading extends DoctorsState {
  const DoctorsLoading();
}

/// Loading more doctors state (pagination)
class DoctorsLoadingMore extends DoctorsState {
  const DoctorsLoadingMore();
}

/// Success state with doctors list
class DoctorsLoaded extends DoctorsState {
  final List<DoctorEntity> doctors;
  final int currentPage;
  final int totalPage;
  final int totalRecords;
  final bool hasReachedMax;

  const DoctorsLoaded({
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

  /// Create a copy with updated values
  DoctorsLoaded copyWith({
    List<DoctorEntity>? doctors,
    int? currentPage,
    int? totalPage,
    int? totalRecords,
    bool? hasReachedMax,
  }) {
    return DoctorsLoaded(
      doctors: doctors ?? this.doctors,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      totalRecords: totalRecords ?? this.totalRecords,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

/// Error state when fetching doctors fails
class DoctorsError extends DoctorsState {
  final String message;

  const DoctorsError(this.message);

  @override
  List<Object?> get props => [message];
}
