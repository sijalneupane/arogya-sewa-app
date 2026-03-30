import 'package:patient_app/features/home/domain/model/nearest_hospitals_response_entity.dart';
import 'package:shared_core/data/models/hospital_model.dart';

class NearestHospitalsResponseModel extends NearestHospitalsResponseEntity {
  const NearestHospitalsResponseModel({
    required super.hospitals,
    required super.totalPage,
    required super.currentPage,
    required super.pageSize,
    required super.totalRecords,
  });

  factory NearestHospitalsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? [];
    final paginationMeta =
        json['paginationMeta'] as Map<String, dynamic>? ?? {};

    return NearestHospitalsResponseModel(
      hospitals: data
          .map(
            (hospital) =>
                HospitalModel.fromJson(hospital as Map<String, dynamic>),
          )
          .toList(),
      totalPage: (paginationMeta['totalPage'] as num?)?.toInt() ?? 1,
      currentPage: (paginationMeta['currentPage'] as num?)?.toInt() ?? 1,
      pageSize: (paginationMeta['pageSize'] as num?)?.toInt() ?? 10,
      totalRecords: (paginationMeta['totalRecords'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': hospitals
          .map((h) => HospitalModel.fromEntity(h).toJson())
          .toList(),
      'paginationMeta': {
        'totalPage': totalPage,
        'currentPage': currentPage,
        'pageSize': pageSize,
        'totalRecords': totalRecords,
      },
    };
  }

  factory NearestHospitalsResponseModel.fromEntity(
    NearestHospitalsResponseEntity entity,
  ) {
    return NearestHospitalsResponseModel(
      hospitals: entity.hospitals,
      totalPage: entity.totalPage,
      currentPage: entity.currentPage,
      pageSize: entity.pageSize,
      totalRecords: entity.totalRecords,
    );
  }
}
