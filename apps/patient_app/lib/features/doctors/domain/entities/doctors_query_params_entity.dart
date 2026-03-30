import 'package:shared_core/domain/entities/pagination_query_entity.dart';

class DoctorsQueryParamsEntity extends PaginationQueryEntity {
  final String? name;
  final String? departmentName;
  final bool? freeUpcomingOnly;

  const DoctorsQueryParamsEntity({
    super.page,
    super.size,
    this.name,
    this.departmentName,
    this.freeUpcomingOnly,
  });
}
