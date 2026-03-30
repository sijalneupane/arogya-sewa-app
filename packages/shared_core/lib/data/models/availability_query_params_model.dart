import 'package:shared_core/domain/entities/availability_query_params_entity.dart';

class AvailabilityQueryParamsModel extends AvailabilityQueryParamsEntity {
  const AvailabilityQueryParamsModel({
    required super.doctorId,
    super.isBooked,
    super.futureOnly,
    super.page,
    super.size,
  });

  factory AvailabilityQueryParamsModel.fromEntity(
    AvailabilityQueryParamsEntity entity,
  ) {
    return AvailabilityQueryParamsModel(
      doctorId: entity.doctorId,
      isBooked: entity.isBooked,
      futureOnly: entity.futureOnly,
      page: entity.page,
      size: entity.size,
    );
  }

  AvailabilityQueryParamsEntity toEntity() {
    return AvailabilityQueryParamsEntity(
      doctorId: doctorId,
      isBooked: isBooked,
      futureOnly: futureOnly,
      page: page,
      size: size,
    );
  }

  Map<String, dynamic> toQueryParams() {
    return {
      if (page != null) 'page': page,
      if (size != null) 'size': size,
      if (isBooked != null) 'is_booked': isBooked,
      if (futureOnly != null) 'future_only': futureOnly,
    };
  }
}
