import 'package:shared_core/data/models/doctor_availability_model.dart';
import 'package:shared_core/data/models/pagination_meta_model.dart';
import 'package:shared_core/domain/entities/doctor_availability_list_entity.dart';

class DoctorAvailabilityListModel extends DoctorAvailabilityListEntity {
  const DoctorAvailabilityListModel({
    required super.availabilities,
    required super.paginationMeta,
  });

  factory DoctorAvailabilityListModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? [];
    final paginationMeta = json['paginationMeta'] as Map<String, dynamic>? ?? {};

    return DoctorAvailabilityListModel(
      availabilities: data
          .map((item) => DoctorAvailabilityModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      paginationMeta: PaginationMetaModel.fromJson(paginationMeta),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'data': availabilities.map((e) => (e as DoctorAvailabilityModel).toJson()).toList(),
  //     'paginationMeta': (paginationMeta as PaginationMetaModel).toJson(),
  //   };
  // }

  factory DoctorAvailabilityListModel.fromEntity(DoctorAvailabilityListEntity entity) {
    return DoctorAvailabilityListModel(
      availabilities: entity.availabilities
          .map((e) => DoctorAvailabilityModel.fromEntity(e))
          .toList(),
      paginationMeta: entity.paginationMeta,
    );
  }
}
