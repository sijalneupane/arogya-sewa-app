import 'package:patient_app/common/model/hospital_entity.dart';
import 'package:shared_core/data/models/file_model.dart';

/// Model for serializing hospital data to/from JSON
class HospitalModel extends HospitalEntity {
  const HospitalModel({
    required super.hospitalId,
    required super.name,
    required super.location,
    required super.latitude,
    required super.longitude,
    required super.distanceKm,
    required super.contactNumber,
    required super.openedDate,
    super.logo,
    super.license,
    super.banner,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      hospitalId: json['hospital_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      contactNumber: List<String>.from(
        (json['contact_number'] as List<dynamic>?) ?? [],
      ),
      openedDate: json['opened_date'] as String? ?? '',
      logo: json['logo'] != null ? FileModel.fromJson(json['logo']) : null,
      license: json['license'] != null ? FileModel.fromJson(json['license']) : null,
      banner: json['banner'] != null ? FileModel.fromJson(json['banner']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hospital_id': hospitalId,
      'name': name,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'distance_km': distanceKm,
      'contact_number': contactNumber,
      'opened_date': openedDate,
      'logo': logo != null ? FileModel.fromEntity(logo!).toJson() : null,
      'license': license != null
          ? FileModel.fromEntity(license!).toJson()
          : null,
      'banner': banner != null ? FileModel.fromEntity(banner!).toJson() : null,
    };
  }

  factory HospitalModel.fromEntity(HospitalEntity entity) {
    return HospitalModel(
      hospitalId: entity.hospitalId,
      name: entity.name,
      location: entity.location,
      latitude: entity.latitude,
      longitude: entity.longitude,
      distanceKm: entity.distanceKm,
      contactNumber: entity.contactNumber,
      openedDate: entity.openedDate,
      logo: entity.logo,
      license: entity.license,
      banner: entity.banner,
    );
  }
}
