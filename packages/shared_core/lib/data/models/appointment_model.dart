import 'package:shared_core/data/models/appointment_changed_time_model.dart';
import 'package:shared_core/data/models/doctor_availability_model.dart';
import 'package:shared_core/data/models/doctor_model.dart';
import 'package:shared_core/data/models/patient_model.dart';
import 'package:shared_core/data/models/user_model.dart';
import 'package:shared_core/domain/entities/appointment_entity.dart';
import 'package:shared_core/domain/enums/appointment_status_enum.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    required super.appointmentId,
    required super.patient,
    required super.doctor,
    required super.bookedBy,
    required super.availability,
    required super.reason,
    required super.notes,
    required super.totalAmount,
    required super.paidAmount,
    required super.dueAmount,
    required super.advanceFee,
    required super.paymentStatus,
    required super.status,
    required super.changedTimes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final changedTimesRaw = json['changed_times'] as List<dynamic>? ?? const [];

    return AppointmentModel(
      appointmentId: json['appointment_id'] as String? ?? '',
      patient: PatientModel.fromJson(
        json['patient'] as Map<String, dynamic>,
      ),
      doctor: DoctorModel.fromJson(json['doctor'] as Map<String, dynamic>),
      bookedBy: UserModel.fromJson(json['booked_by'] as Map<String, dynamic>),
      availability: DoctorAvailabilityModel.fromJson(
        json['availability'] as Map<String, dynamic>,
      ),
      reason: json['reason'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      paidAmount: (json['paid_amount'] as num?)?.toDouble() ?? 0,
      dueAmount: (json['due_amount'] as num?)?.toDouble() ?? 0,
      advanceFee: (json['advance_fee'] as num?)?.toDouble() ?? 0,
      paymentStatus: json['payment_status'] as String? ?? '',
      status: AppointmentStatusEnumX.fromValue(json['status'] as String?),
      changedTimes: changedTimesRaw
          .map(
            (item) => AppointmentChangedTimeModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}