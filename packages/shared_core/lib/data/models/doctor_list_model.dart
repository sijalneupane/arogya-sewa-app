import 'package:shared_core/data/models/doctor_model.dart';
import 'package:shared_core/data/models/pagination_meta_model.dart';
import 'package:shared_core/domain/entities/doctor_list_entity.dart';

class DoctorListModel extends DoctorListEntity {
  const DoctorListModel({
    required super.doctors,
    required super.paginationMeta,
  });

  factory DoctorListModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? const <dynamic>[];
    final paginationMeta =
        json['paginationMeta'] as Map<String, dynamic>? ??
        const <String, dynamic>{};

    return DoctorListModel(
      doctors: data
          .map((doctor) => DoctorModel.fromJson(doctor as Map<String, dynamic>))
          .toList(),
      paginationMeta: PaginationMetaModel.fromJson( paginationMeta)
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': doctors
          .map((doctor) => DoctorModel.fromEntity(doctor).toJson())
          .toList(),
      'paginationMeta': {
        'totalPage': paginationMeta.totalPage,
        'currentPage': paginationMeta.currentPage,
        'pageSize': paginationMeta.pageSize,
        'totalRecords': paginationMeta.totalRecords,
      },
    };
  }

  factory DoctorListModel.fromEntity(DoctorListEntity entity) {
    return DoctorListModel(
      doctors: entity.doctors,
      paginationMeta: entity.paginationMeta,
    );
  }
}
