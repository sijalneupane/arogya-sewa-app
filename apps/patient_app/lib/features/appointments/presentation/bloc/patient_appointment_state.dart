import 'package:equatable/equatable.dart';
import 'package:shared_core/domain/entities/appointment_entity.dart';

abstract class PatientAppointmentState extends Equatable {
  const PatientAppointmentState();

  @override
  List<Object?> get props => [];
}

class PatientAppointmentInitial extends PatientAppointmentState {
  const PatientAppointmentInitial();
}

class PatientAppointmentLoading extends PatientAppointmentState {
  const PatientAppointmentLoading();
}

class PatientAppointmentLoaded extends PatientAppointmentState {
  final List<AppointmentEntity> appointments;
  final int currentPage;
  final int totalPage;
  final int totalRecords;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const PatientAppointmentLoaded({
    required this.appointments,
    required this.currentPage,
    required this.totalPage,
    required this.totalRecords,
    required this.hasReachedMax,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [
        appointments,
        currentPage,
        totalPage,
        totalRecords,
        hasReachedMax,
        isLoadingMore,
      ];

  PatientAppointmentLoaded copyWith({
    List<AppointmentEntity>? appointments,
    int? currentPage,
    int? totalPage,
    int? totalRecords,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return PatientAppointmentLoaded(
      appointments: appointments ?? this.appointments,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      totalRecords: totalRecords ?? this.totalRecords,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class PatientAppointmentLoadingMore extends PatientAppointmentLoaded {
  const PatientAppointmentLoadingMore({
    required super.appointments,
    required super.currentPage,
    required super.totalPage,
    required super.totalRecords,
    required super.hasReachedMax,
  }) : super(isLoadingMore: true);

  factory PatientAppointmentLoadingMore.fromLoaded(
    PatientAppointmentLoaded loaded,
  ) {
    return PatientAppointmentLoadingMore(
      appointments: loaded.appointments,
      currentPage: loaded.currentPage,
      totalPage: loaded.totalPage,
      totalRecords: loaded.totalRecords,
      hasReachedMax: loaded.hasReachedMax,
    );
  }
}

class PatientAppointmentRefreshing extends PatientAppointmentLoaded {
  const PatientAppointmentRefreshing({
    required super.appointments,
    required super.currentPage,
    required super.totalPage,
    required super.totalRecords,
    required super.hasReachedMax,
  });

  factory PatientAppointmentRefreshing.fromLoaded(
    PatientAppointmentLoaded loaded,
  ) {
    return PatientAppointmentRefreshing(
      appointments: loaded.appointments,
      currentPage: loaded.currentPage,
      totalPage: loaded.totalPage,
      totalRecords: loaded.totalRecords,
      hasReachedMax: loaded.hasReachedMax,
    );
  }
}

class PatientAppointmentError extends PatientAppointmentState {
  final String message;

  const PatientAppointmentError(this.message);

  @override
  List<Object?> get props => [message];
}
