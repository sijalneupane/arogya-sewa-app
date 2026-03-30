import 'package:shared_core/domain/entities/pagination_query_entity.dart';
import 'package:shared_core/domain/enums/doctor_status_enum.dart';

class DoctorsQueryParamsEntity extends PaginationQueryEntity {
  final String? name;
  final String? departmentName;
  final bool? freeUpcomingOnly;
  final DoctorStatusEnum? status;

  const DoctorsQueryParamsEntity({
    super.page,
    super.size,
    this.name,
    this.departmentName,
    this.freeUpcomingOnly,
    this.status,
  });
}
