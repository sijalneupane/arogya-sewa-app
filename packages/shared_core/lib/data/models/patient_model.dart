import 'package:shared_core/data/models/user_model.dart';
import 'package:shared_core/domain/entities/patient_entity.dart';

class PatientModel extends PatientEntity {
  const PatientModel({
    required super.patientId,
    required super.dob,
    required super.gender,
    required super.bloodGroup,
    required super.user,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      patientId: json['patient_id'] as String? ?? '',
      dob: DateTime.parse(json['dob'] as String),
      gender: json['gender'] as String? ?? '',
      bloodGroup: json['blood_group'] as String? ?? '',
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'dob': dob.toIso8601String(),
      'gender': gender,
      'blood_group': bloodGroup,
      'user': (user as UserModel).toJson(),
    };
  }

  factory PatientModel.fromEntity(PatientEntity entity) {
    return PatientModel(
      patientId: entity.patientId,
      dob: entity.dob,
      gender: entity.gender,
      bloodGroup: entity.bloodGroup,
      user: entity.user,
    );
  }
}