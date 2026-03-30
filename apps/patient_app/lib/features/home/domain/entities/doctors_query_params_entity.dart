import 'package:shared_core/domain/entities/pagination_query_entity.dart';

/// Entity representing query parameters for doctors API endpoint
class DoctorsQueryParamsEntity extends PaginationQueryEntity {
  final String? name;
  final String? departmentId;
  final bool? freeUpcomingOnly;

  const DoctorsQueryParamsEntity({
    super.page,
    super.size,
    this.name,
    this.departmentId,
    this.freeUpcomingOnly,
  });
}
