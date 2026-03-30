import 'package:shared_core/domain/entities/doctor_availability_entity.dart';

class DoctorAvailabilityModel extends DoctorAvailabilityEntity {
  const DoctorAvailabilityModel({
    required super.availabilityId,
    required super.doctorId,
    required super.startDateTime,
    required super.endDateTime,
    super.note,
    required super.isBooked,
  });

  factory DoctorAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return DoctorAvailabilityModel(
      availabilityId: json['availability_id'] as String? ?? '',
      doctorId: json['doctor_id'] as String? ?? '',
      startDateTime: DateTime.parse(json['start_date_time'] as String),
      endDateTime: DateTime.parse(json['end_date_time'] as String),
      note: json['note'] as String?,
      isBooked: json['is_booked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'availability_id': availabilityId,
      'doctor_id': doctorId,
      'start_date_time': startDateTime.toIso8601String(),
      'end_date_time': endDateTime.toIso8601String(),
      'note': note,
      'is_booked': isBooked,
    };
  }

  factory DoctorAvailabilityModel.fromEntity(DoctorAvailabilityEntity entity) {
    return DoctorAvailabilityModel(
      availabilityId: entity.availabilityId,
      doctorId: entity.doctorId,
      startDateTime: entity.startDateTime,
      endDateTime: entity.endDateTime,
      note: entity.note,
      isBooked: entity.isBooked,
    );
  }
}
