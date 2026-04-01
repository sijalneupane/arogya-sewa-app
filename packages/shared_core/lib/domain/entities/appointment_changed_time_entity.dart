class AppointmentChangedTimeEntity {
  final String changedTimeId;
  final String appointmentId;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String reason;
  final DateTime changedAt;
  final String changedByUserId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AppointmentChangedTimeEntity({
    required this.changedTimeId,
    required this.appointmentId,
    required this.startDateTime,
    required this.endDateTime,
    required this.reason,
    required this.changedAt,
    required this.changedByUserId,
    required this.createdAt,
    required this.updatedAt,
  });
}