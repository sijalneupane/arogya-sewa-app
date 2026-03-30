import 'package:patient_app/features/doctors/domain/entities/doctors_query_params_entity.dart';

class DoctorsQueryParamsModel extends DoctorsQueryParamsEntity {
  const DoctorsQueryParamsModel({
    super.page,
    super.size,
    super.name,
    super.departmentName,
    super.freeUpcomingOnly,
  });

  factory DoctorsQueryParamsModel.fromEntity(DoctorsQueryParamsEntity entity) {
    return DoctorsQueryParamsModel(
      page: entity.page,
      size: entity.size,
      name: entity.name,
      departmentName: entity.departmentName,
      freeUpcomingOnly: entity.freeUpcomingOnly,
    );
  }

  DoctorsQueryParamsEntity toEntity() {
    return DoctorsQueryParamsEntity(
      page: page,
      size: size,
      name: name,
      departmentName: departmentName,
      freeUpcomingOnly: freeUpcomingOnly,
    );
  }

  Map<String, dynamic> toQueryParams() {
    return {
      if (page != null) 'page': page,
      if (size != null) 'size': size,
      if (name != null && name!.isNotEmpty) 'name': name,
      if (departmentName != null && departmentName!.isNotEmpty)
        'department': departmentName,
      if (freeUpcomingOnly != null) 'free_upcoming_only': freeUpcomingOnly,
    };
  }
}
