import 'package:shared_core/domain/entities/doctor_entity.dart';
import 'package:shared_core/domain/entities/pagination_meta_entity.dart';

class DoctorListEntity {
  final List<DoctorEntity> doctors;
  final PaginationMetaEntity paginationMeta;

  const DoctorListEntity({required this.doctors, required this.paginationMeta});
}
