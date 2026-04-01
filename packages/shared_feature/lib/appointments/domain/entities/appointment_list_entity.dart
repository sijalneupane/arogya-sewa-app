import 'package:shared_core/domain/entities/pagination_meta_entity.dart';
import 'package:shared_core/domain/entities/appointment_entity.dart';

class AppointmentListEntity {
  final List<AppointmentEntity> appointments;
  final PaginationMetaEntity paginationMeta;

  const AppointmentListEntity({
    required this.appointments,
    required this.paginationMeta,
  });
}
