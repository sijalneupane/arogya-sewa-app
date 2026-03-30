import 'package:shared_core/domain/entities/doctor_availability_entity.dart';
import 'package:shared_core/domain/entities/pagination_meta_entity.dart';

class DoctorAvailabilityListEntity {
  final List<DoctorAvailabilityEntity> availabilities;
  final PaginationMetaEntity paginationMeta;

  const DoctorAvailabilityListEntity({
    required this.availabilities,
    required this.paginationMeta,
  });
}
