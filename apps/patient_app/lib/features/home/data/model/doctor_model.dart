import 'package:patient_app/common/model/doctor_availability_model.dart';
import 'package:patient_app/common/model/doctor_department_model.dart';
import 'package:patient_app/features/home/domain/entities/doctor_entity.dart';
import 'package:shared_core/data/models/file_model.dart';
import 'package:shared_core/data/models/user_model.dart';

/// Model for serializing doctor data to/from JSON
class DoctorModel extends DoctorEntity {
  const DoctorModel({
    required super.doctorId,
    required super.experience,
    required super.status,
    super.bio,
    super.licenseCertificate,
    required super.hospitalId,
    required super.department,
    required super.user,
    super.upcomingAvailability,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      doctorId: json['doctor_id'] as String? ?? '',
      experience: json['experience'] as String? ?? '',
      status: json['status'] as String? ?? '',
      bio: json['bio'] as String?,
      licenseCertificate: json['license_certificate'] != null
          ? FileModel.fromJson(json['license_certificate'])
          : null,
      hospitalId: json['hospital_id'] as String? ?? '',
      department: DoctorDepartmentModel.fromJson(
        json['department'] as Map<String, dynamic>,
      ),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      upcomingAvailability: json['upcoming_availability'] != null
          ? DoctorAvailabilityModel.fromJson(
              json['upcoming_availability'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  factory DoctorModel.fromEntity(DoctorEntity entity) {
    return DoctorModel(
      doctorId: entity.doctorId,
      experience: entity.experience,
      status: entity.status,
      bio: entity.bio,
      licenseCertificate: entity.licenseCertificate,
      hospitalId: entity.hospitalId,
      department: entity.department,
      user: entity.user,
      upcomingAvailability: entity.upcomingAvailability,
    );
  }
}
