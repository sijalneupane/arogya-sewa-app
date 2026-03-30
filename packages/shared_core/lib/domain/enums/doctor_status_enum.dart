enum DoctorStatusEnum {
  available('Available'),
  onLeave('On Leave'),
  onAppointment('On Appointment'),
  inactive('Inactive');

  final String value;
  const DoctorStatusEnum(this.value);
}

extension DoctorStatusEnumX on DoctorStatusEnum {
  static DoctorStatusEnum fromValue(String? value) {
    final normalized = (value ?? '').trim().toLowerCase();

    switch (normalized) {
      case 'available':
      case 'active':
        return DoctorStatusEnum.available;
      case 'on leave':
      case 'on_leave':
      case 'leave':
        return DoctorStatusEnum.onLeave;
      case 'on appointment':
      case 'on_appointment':
      case 'appointment':
      case 'busy':
        return DoctorStatusEnum.onAppointment;
      case 'inactive':
      default:
        return DoctorStatusEnum.inactive;
    }
  }
}