import 'package:patient_app/common/model/hospital_entity.dart';

class NearestHospitalsResponseEntity {
  final List<HospitalEntity> hospitals;
  final int totalPage;
  final int currentPage;
  final int pageSize;
  final int totalRecords;

  const NearestHospitalsResponseEntity({
    required this.hospitals,
    required this.totalPage,
    required this.currentPage,
    required this.pageSize,
    required this.totalRecords,
  });
}
