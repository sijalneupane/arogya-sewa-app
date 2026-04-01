import 'package:shared_core/domain/entities/appointment_changed_time_entity.dart';

class AppointmentChangedTimeModel extends AppointmentChangedTimeEntity {
  const AppointmentChangedTimeModel({
    required super.changedTimeId,
    required super.appointmentId,
    required super.startDateTime,
    required super.endDateTime,
    required super.reason,
    required super.changedAt,
    required super.changedByUserId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AppointmentChangedTimeModel.fromJson(Map<String, dynamic> json) {
    return AppointmentChangedTimeModel(
      changedTimeId: json['changed_time_id'] as String? ?? '',
      appointmentId: json['appointment_id'] as String? ?? '',
      startDateTime: DateTime.parse(json['start_date_time'] as String),
      endDateTime: DateTime.parse(json['end_date_time'] as String),
      reason: json['reason'] as String? ?? '',
      changedAt: DateTime.parse(json['changed_at'] as String),
      changedByUserId: json['changed_by_user_id'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}