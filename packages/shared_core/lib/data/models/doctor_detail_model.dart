import 'package:shared_core/data/models/department_model.dart';
import 'package:shared_core/data/models/file_model.dart';
import 'package:shared_core/data/models/hospital_model.dart';
import 'package:shared_core/data/models/user_model.dart';
import 'package:shared_core/domain/entities/doctor_detail_entity.dart';
import 'package:shared_core/domain/enums/doctor_status_enum.dart';

class DoctorDetailModel extends DoctorDetailEntity {
  const DoctorDetailModel({
    required super.doctorId,
    required super.experience,
    required super.status,
    super.bio,
    super.licenseCertificate,
    required super.department,
    required super.user,
    required super.hospital,
  });

  factory DoctorDetailModel.fromJson(Map<String, dynamic> json) {
    return DoctorDetailModel(
      doctorId: json['doctor_id'] as String? ?? '',
      experience: json['experience'] as String? ?? '',
      status: DoctorStatusEnumX.fromValue(json['status'] as String?),
      bio: json['bio'] as String?,
      licenseCertificate: json['license_certificate'] != null
          ? FileModel.fromJson(
              json['license_certificate'] as Map<String, dynamic>,
            )
          : null,
      department: DepartmentModel.fromJson(
        json['department'] as Map<String, dynamic>,
      ),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      hospital: HospitalModel.fromJson(
        json['hospital'] as Map<String, dynamic>,
      ),
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
      'department': DepartmentModel.fromEntity(department).toJson(),
      'user': (user as UserModel).toJson(),
      'hospital': HospitalModel.fromEntity(hospital).toJson(),
    };
  }

  factory DoctorDetailModel.fromEntity(DoctorDetailEntity entity) {
    return DoctorDetailModel(
      doctorId: entity.doctorId,
      experience: entity.experience,
      status: entity.status,
      bio: entity.bio,
      licenseCertificate: entity.licenseCertificate,
      department: entity.department,
      user: entity.user,
      hospital: entity.hospital,
    );
  }
}
