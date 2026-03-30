import 'package:patient_app/features/home/data/model/nearest_hospitals_response_model.dart';
import 'package:patient_app/features/home/data/model/doctor_model.dart';
import 'package:patient_app/features/home/data/model/doctors_query_params_model.dart';

/// Result wrapper for doctors list with pagination
class DoctorsResult {
  final List<DoctorModel> doctors;
  final int totalPage;
  final int currentPage;
  final int pageSize;
  final int totalRecords;

  const DoctorsResult({
    required this.doctors,
    required this.totalPage,
    required this.currentPage,
    required this.pageSize,
    required this.totalRecords,
  });
}

abstract class HomeRemoteDataSource {
  Future<NearestHospitalsResponseModel> getNearestHospitals({
    required double latitude,
    required double longitude,
  });

  /// Fetches doctors list with optional query parameters
  Future<DoctorsResult> fetchDoctors(DoctorsQueryParamsModel queryParams);
}
