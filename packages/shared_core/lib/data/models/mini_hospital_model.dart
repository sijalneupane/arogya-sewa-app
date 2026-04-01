import 'package:shared_core/domain/entities/mini_hospital_entity.dart';

class MiniHospitalModel extends MiniHospitalEntity {
  const MiniHospitalModel({
    required super.hospitalId,
    required super.name,
    required super.location,
  });

  factory MiniHospitalModel.fromJson(Map<String, dynamic> json) {
    return MiniHospitalModel(
      hospitalId: json['hospital_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hospital_id': hospitalId,
      'name': name,
      'location': location,
    };
  }

  factory MiniHospitalModel.fromEntity(MiniHospitalEntity entity) {
    return MiniHospitalModel(
      hospitalId: entity.hospitalId,
      name: entity.name,
      location: entity.location,
    );
  }
}
