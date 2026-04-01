import 'package:shared_feature/appointments/domain/entities/fetch_my_appointments_query_entity.dart';

class FetchMyAppointmentsQueryModel extends FetchMyAppointmentsQueryEntity {
  const FetchMyAppointmentsQueryModel({
    super.status,
    super.dateFrom,
    super.dateTo,
    super.page,
    super.size,
  });

  factory FetchMyAppointmentsQueryModel.fromEntity(
    FetchMyAppointmentsQueryEntity entity,
  ) {
    return FetchMyAppointmentsQueryModel(
      status: entity.status,
      dateFrom: entity.dateFrom,
      dateTo: entity.dateTo,
      page: entity.page,
      size: entity.size,
    );
  }

  Map<String, dynamic> toQueryParams() {
    String formatDate(DateTime date) {
      final month = date.month.toString().padLeft(2, '0');
      final day = date.day.toString().padLeft(2, '0');
      return '${date.year}-$month-$day';
    }

    return {
      if (status != null) 'status': status!.value,
      if (dateFrom != null) 'date_from': formatDate(dateFrom!),
      if (dateTo != null) 'date_to': formatDate(dateTo!),
      if (page != null) 'page': page,
      if (size != null) 'size': size,
    };
  }
}
