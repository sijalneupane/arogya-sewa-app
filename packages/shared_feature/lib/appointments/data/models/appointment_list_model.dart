import 'package:shared_core/data/models/pagination_meta_model.dart';
import 'package:shared_core/data/models/appointment_model.dart';
import 'package:shared_feature/appointments/domain/entities/appointment_list_entity.dart';

class AppointmentListModel extends AppointmentListEntity {
  const AppointmentListModel({
    required super.appointments,
    required super.paginationMeta,
  });

  factory AppointmentListModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? const [];
    final paginationMeta =
        json['paginationMeta'] as Map<String, dynamic>? ?? const {};

    return AppointmentListModel(
      appointments: data
          .map((item) => AppointmentModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      paginationMeta: PaginationMetaModel(
        totalPage: (paginationMeta['totalPage'] as num?)?.toInt() ?? 1,
        currentPage: (paginationMeta['currentPage'] as num?)?.toInt() ?? 1,
        pageSize: (paginationMeta['pageSize'] as num?)?.toInt() ?? 10,
        totalRecords: (paginationMeta['totalRecords'] as num?)?.toInt() ?? 0,
      ),
    );
  }
}
