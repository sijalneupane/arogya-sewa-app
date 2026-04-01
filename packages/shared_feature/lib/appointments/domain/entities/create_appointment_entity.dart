class CreateAppointmentEntity {
  final String availabilityId;
  final String reason;
  final String notes;

  const CreateAppointmentEntity({
    required this.availabilityId,
    required this.reason,
    required this.notes,
  });
}