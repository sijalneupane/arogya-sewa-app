import 'package:shared_core/domain/entities/pagination_query_entity.dart';
import 'package:shared_core/domain/enums/appointment_status_enum.dart';

class FetchMyAppointmentsQueryEntity extends PaginationQueryEntity {
  final AppointmentStatusEnum? status;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  const FetchMyAppointmentsQueryEntity({
    this.status,
    this.dateFrom,
    this.dateTo,
    super.page,
    super.size,
  });
}
