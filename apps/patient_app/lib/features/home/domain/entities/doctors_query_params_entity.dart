/// Entity representing query parameters for doctors API endpoint
class DoctorsQueryParamsEntity {
  final String? name;
  final String? departmentId;
  final bool? freeUpcomingOnly;

  const DoctorsQueryParamsEntity({
    this.name,
    this.departmentId,
    this.freeUpcomingOnly,
  });


}
