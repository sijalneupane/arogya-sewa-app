import 'package:patient_app/features/home/domain/entities/doctors_query_params_entity.dart';

/// Model for serializing doctors query parameters to/from Map format
class DoctorsQueryParamsModel extends DoctorsQueryParamsEntity {
  const DoctorsQueryParamsModel({
    super.page,
    super.size,
    super.name,
    super.departmentId,
    super.freeUpcomingOnly,
  });

  /// Create model from entity
  factory DoctorsQueryParamsModel.fromEntity(DoctorsQueryParamsEntity entity) {
    return DoctorsQueryParamsModel(
      page: entity.page,
      size: entity.size,
      name: entity.name,
      departmentId: entity.departmentId,
      freeUpcomingOnly: entity.freeUpcomingOnly,
    );
  }

  /// Create entity from model
  DoctorsQueryParamsEntity toEntity() {
    return DoctorsQueryParamsEntity(
      page: page,
      size: size,
      name: name,
      departmentId: departmentId,
      freeUpcomingOnly: freeUpcomingOnly,
    );
  }

  /// Convert to query parameters Map
  Map<String, dynamic> toQueryParams() {
    return {
      if (page != null) 'page': page,
      if (size != null) 'size': size,
      if (name != null && name!.isNotEmpty) 'name': name,
      if (departmentId != null && departmentId!.isNotEmpty)
        'department_id': departmentId,
      if (freeUpcomingOnly != null) 'free_upcoming_only': freeUpcomingOnly,
    };
  }
}
