import 'package:shared_core/domain/entities/department_entity.dart';
import 'package:shared_core/domain/entities/file_entity.dart';
import 'package:shared_core/domain/entities/hospital_entity.dart';
import 'package:shared_core/domain/entities/user_entity.dart';
import 'package:shared_core/domain/enums/doctor_status_enum.dart';

class DoctorDetailEntity {
  final String doctorId;
  final String experience;
  final DoctorStatusEnum status;
  final String? bio;
  final FileEntity? licenseCertificate;
  final DepartmentEntity department;
  final UserEntity user;
  final HospitalEntity hospital;

  const DoctorDetailEntity({
    required this.doctorId,
    required this.experience,
    required this.status,
    this.bio,
    this.licenseCertificate,
    required this.department,
    required this.user,
    required this.hospital,
  });
}
