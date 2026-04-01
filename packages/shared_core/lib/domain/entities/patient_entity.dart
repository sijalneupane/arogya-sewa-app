import 'package:shared_core/domain/entities/user_entity.dart';

class PatientEntity {
  final String patientId;
  final DateTime dob;
  final String gender;
  final String bloodGroup;
  final UserEntity user;

  const PatientEntity({
    required this.patientId,
    required this.dob,
    required this.gender,
    required this.bloodGroup,
    required this.user,
  });
}