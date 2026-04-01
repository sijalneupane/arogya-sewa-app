enum AppointmentStatusEnum {
  pendingPayment('Pending Payment'),
  confirmed('Confirmed'),
  inProgress('In Progress'),
  completed('Completed'),
  cancelled('Cancelled'),
  rescheduled('Rescheduled');

  final String value;

  const AppointmentStatusEnum(this.value);
}

extension AppointmentStatusEnumX on AppointmentStatusEnum {
  static AppointmentStatusEnum fromValue(String? value) {
    final normalized = (value ?? '').trim().toLowerCase().replaceAll('_', ' ');

    switch (normalized) {
      case 'pending payment':
        return AppointmentStatusEnum.pendingPayment;
      case 'confirmed':
        return AppointmentStatusEnum.confirmed;
      case 'in progress':
        return AppointmentStatusEnum.inProgress;
      case 'completed':
        return AppointmentStatusEnum.completed;
      case 'cancelled':
        return AppointmentStatusEnum.cancelled;
      case 'rescheduled':
        return AppointmentStatusEnum.rescheduled;
      default:
        return AppointmentStatusEnum.pendingPayment;
    }
  }
}