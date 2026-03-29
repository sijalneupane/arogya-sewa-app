import 'package:shared_core/domain/entities/location_entity.dart';

/// Model for serializing location coordinates to/from Map format
class LocationModel extends LocationEntity {
  const LocationModel({
    required super.latitude,
    required super.longitude,
  });

  /// Convert to query parameters Map for HTTP requests
  Map<String, dynamic> toQueryParams() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  /// Create model from entity
  factory LocationModel.fromEntity(
    LocationEntity entity,
  ) {
    return LocationModel(
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }
}
