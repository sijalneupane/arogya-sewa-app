/// Entity representing doctor's department
class DoctorDepartmentEntity {
  final String departmentId;
  final String name;
  final String? description;
  final bool isActive;
  final String hospitalId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DoctorDepartmentEntity({
    required this.departmentId,
    required this.name,
    this.description,
    required this.isActive,
    required this.hospitalId,
    required this.createdAt,
    required this.updatedAt,
  });
}
