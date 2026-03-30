import 'package:shared_core/domain/entities/department_entity.dart';

class DepartmentModel extends DepartmentEntity {
  const DepartmentModel({
    required super.departmentId,
    required super.name,
    super.description,
    required super.isActive,
    required super.hospitalId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      departmentId: json['department_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? false,
      hospitalId: json['hospital_id'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'department_id': departmentId,
      'name': name,
      'description': description,
      'is_active': isActive,
      'hospital_id': hospitalId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory DepartmentModel.fromEntity(DepartmentEntity entity) {
    return DepartmentModel(
      departmentId: entity.departmentId,
      name: entity.name,
      description: entity.description,
      isActive: entity.isActive,
      hospitalId: entity.hospitalId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
