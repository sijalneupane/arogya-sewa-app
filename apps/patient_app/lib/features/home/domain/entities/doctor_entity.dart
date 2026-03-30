import 'package:patient_app/common/model/doctor_availability_entity.dart';
import 'package:patient_app/common/model/doctor_department_entity.dart';
import 'package:shared_core/domain/entities/file_entity.dart';
import 'package:shared_core/domain/entities/user_entity.dart';

/// Entity representing a doctor with their details
class DoctorEntity {
  final String doctorId;
  final String experience;
  final String status;
  final String? bio;
  final FileEntity? licenseCertificate;
  final String hospitalId;
  final DoctorDepartmentEntity department;
  final UserEntity user;
  final DoctorAvailabilityEntity? upcomingAvailability;

  const DoctorEntity({
    required this.doctorId,
    required this.experience,
    required this.status,
    this.bio,
    this.licenseCertificate,
    required this.hospitalId,
    required this.department,
    required this.user,
    this.upcomingAvailability,
  });
}

/// Entity representing doctor's user information
class DoctorUserEntity {
  final String id;
  final String email;
  final String name;
  final String phoneNumber;
  final DoctorRoleEntity role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final FileEntity? profileImg;

  const DoctorUserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.profileImg,
  });
}

/// Entity representing doctor's role
class DoctorRoleEntity {
  final String role;
  final String? description;

  const DoctorRoleEntity({
    required this.role,
    this.description,
  });
}
