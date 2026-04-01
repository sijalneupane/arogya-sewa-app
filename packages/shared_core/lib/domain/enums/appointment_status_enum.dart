enum AppointmentStatusEnum {
  pendingPayment('Pending Payment', 'pending_payment'),
  confirmed('Confirmed', 'confirmed'),
  inProgress('In Progress', 'in_progress'),
  completed('Completed', 'completed'),
  cancelled('Cancelled', 'cancelled'),
  rescheduled('Rescheduled', 'rescheduled');

  final String value;
  final String apiValue;

  const AppointmentStatusEnum(this.value, this.apiValue);
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