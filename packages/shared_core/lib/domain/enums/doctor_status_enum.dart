enum DoctorStatusEnum {
  active('Active'),
  onLeave('On Leave'),
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
        return DoctorStatusEnum.active;
      case 'on leave':
      case 'on_leave':
      case 'leave':
        return DoctorStatusEnum.onLeave;
      case 'inactive':
      default:
        return DoctorStatusEnum.inactive;
    }
  }
}