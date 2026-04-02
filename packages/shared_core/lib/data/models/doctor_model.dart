import 'package:shared_core/data/models/department_model.dart';
import 'package:shared_core/data/models/doctor_availability_model.dart';
import 'package:shared_core/data/models/file_model.dart';
import 'package:shared_core/data/models/mini_hospital_model.dart';
import 'package:shared_core/data/models/user_model.dart';
import 'package:shared_core/domain/entities/doctor_entity.dart';
import 'package:shared_core/domain/enums/doctor_status_enum.dart';

class DoctorModel extends DoctorEntity {
  const DoctorModel({
    required super.doctorId,
    required super.experience,
    required super.status,
    super.bio,
    super.licenseCertificate,
    required super.hospitalId,
    required super.hospital,
    required super.department,
    required super.user,
    super.upcomingAvailability,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      doctorId: json['doctor_id'] as String? ?? '',
      experience: json['experience'] as String? ?? '',
      status: DoctorStatusEnumX.fromValue(json['status'] as String?),
      bio: json['bio'] as String?,
      licenseCertificate: json['license_certificate'] != null
          ? FileModel.fromJson(
              json['license_certificate'] as Map<String, dynamic>,
            )
          : null,
      hospitalId: json['hospital_id'] as String? ?? '',
      hospital: MiniHospitalModel.fromJson(
        json['hospital'] as Map<String, dynamic>,
      ),
      department: json['department'] != null
          ? DepartmentModel.fromJson(
              json['department'] as Map<String, dynamic>,
            )
          : null,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      upcomingAvailability: json['upcoming_availability'] != null
          ? DoctorAvailabilityModel.fromJson(
              json['upcoming_availability'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctor_id': doctorId,
      'experience': experience,
      'status': status.value,
      'bio': bio,
      'license_certificate': licenseCertificate != null
          ? FileModel.fromEntity(licenseCertificate!).toJson()
          : null,
      'hospital_id': hospitalId,
      'hospital': MiniHospitalModel.fromEntity(hospital).toJson(),
      'department': department != null
          ? DepartmentModel.fromEntity(department!).toJson()
          : null,
      'user': (user as UserModel).toJson(),
      'upcoming_availability': upcomingAvailability != null
          ? DoctorAvailabilityModel.fromEntity(upcomingAvailability!).toJson()
          : null,
    };
  }

  factory DoctorModel.fromEntity(DoctorEntity entity) {
    return DoctorModel(
      doctorId: entity.doctorId,
      experience: entity.experience,
      status: entity.status,
      bio: entity.bio,
      licenseCertificate: entity.licenseCertificate,
      hospitalId: entity.hospitalId,
      hospital: entity.hospital,
      department: entity.department,
      user: entity.user,
      upcomingAvailability: entity.upcomingAvailability,
    );
  }
}
