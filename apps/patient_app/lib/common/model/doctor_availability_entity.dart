/// Entity representing doctor's upcoming availability
class DoctorAvailabilityEntity {
  final String availabilityId;
  final String doctorId;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String? note;
  final bool isBooked;

  const DoctorAvailabilityEntity({
    required this.availabilityId,
    required this.doctorId,
    required this.startDateTime,
    required this.endDateTime,
    this.note,
    required this.isBooked,
  });
}
