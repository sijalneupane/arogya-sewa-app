import 'package:shared_core/domain/entities/department_entity.dart';
import 'package:shared_core/domain/entities/doctor_availability_entity.dart';
import 'package:shared_core/domain/enums/doctor_status_enum.dart';
import 'package:shared_core/domain/entities/file_entity.dart';
import 'package:shared_core/domain/entities/mini_hospital_entity.dart';
import 'package:shared_core/domain/entities/user_entity.dart';

class DoctorEntity {
  final String doctorId;
  final String experience;
  final DoctorStatusEnum status;
  final String? bio;
  final FileEntity? licenseCertificate;
  final String hospitalId;
  final MiniHospitalEntity hospital;
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
    required this.hospital,
    required this.department,
    required this.user,
    this.upcomingAvailability,
  });
}
