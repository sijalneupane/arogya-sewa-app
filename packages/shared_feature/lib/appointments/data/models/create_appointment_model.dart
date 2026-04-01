import 'package:shared_feature/appointments/domain/entities/create_appointment_entity.dart';

class CreateAppointmentModel {
  final String availabilityId;
  final String reason;
  final String notes;

  const CreateAppointmentModel({
    required this.availabilityId,
    required this.reason,
    required this.notes,
  });

  factory CreateAppointmentModel.fromEntity(CreateAppointmentEntity entity) {
    return CreateAppointmentModel(
      availabilityId: entity.availabilityId,
      reason: entity.reason,
      notes: entity.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'availability_id': availabilityId,
      'reason': reason,
      'notes': notes,
    };
  }
}
