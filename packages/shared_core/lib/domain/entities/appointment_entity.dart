import 'package:shared_core/domain/entities/appointment_changed_time_entity.dart';
import 'package:shared_core/domain/entities/doctor_availability_entity.dart';
import 'package:shared_core/domain/entities/doctor_entity.dart';
import 'package:shared_core/domain/entities/patient_entity.dart';
import 'package:shared_core/domain/entities/user_entity.dart';
import 'package:shared_core/domain/enums/appointment_status_enum.dart';

class AppointmentEntity {
  final String appointmentId;
  final PatientEntity patient;
  final DoctorEntity doctor;
  final UserEntity bookedBy;
  final DoctorAvailabilityEntity availability;
  final String reason;
  final String notes;
  final double totalAmount;
  final double paidAmount;
  final double dueAmount;
  final double advanceFee;
  final String paymentStatus;
  final AppointmentStatusEnum status;
  final List<AppointmentChangedTimeEntity> changedTimes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AppointmentEntity({
    required this.appointmentId,
    required this.patient,
    required this.doctor,
    required this.bookedBy,
    required this.availability,
    required this.reason,
    required this.notes,
    required this.totalAmount,
    required this.paidAmount,
    required this.dueAmount,
    required this.advanceFee,
    required this.paymentStatus,
    required this.status,
    required this.changedTimes,
    required this.createdAt,
    required this.updatedAt,
  });
}