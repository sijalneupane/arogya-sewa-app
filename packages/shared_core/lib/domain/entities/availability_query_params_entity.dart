import 'package:shared_core/domain/entities/pagination_query_entity.dart';

class AvailabilityQueryParamsEntity extends PaginationQueryEntity {
  final String doctorId;
  final bool? isBooked;
  final bool? futureOnly;

  const AvailabilityQueryParamsEntity({
    required this.doctorId,
    this.isBooked,
    this.futureOnly,
    super.page,
    super.size,
  });
}
