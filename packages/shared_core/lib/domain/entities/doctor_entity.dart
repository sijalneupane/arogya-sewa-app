import 'package:shared_core/domain/entities/department_entity.dart';
import 'package:shared_core/domain/entities/doctor_availability_entity.dart';
import 'package:shared_core/domain/entities/file_entity.dart';
import 'package:shared_core/domain/entities/user_entity.dart';

class DoctorEntity {
  final String doctorId;
  final String experience;
  final String status;
  final String? bio;
  final FileEntity? licenseCertificate;
  final String hospitalId;
  final DepartmentEntity department;
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
