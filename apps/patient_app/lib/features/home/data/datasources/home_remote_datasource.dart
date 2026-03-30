import 'package:patient_app/features/home/data/model/nearest_hospitals_response_model.dart';
import 'package:patient_app/features/home/data/model/doctors_query_params_model.dart';
import 'package:shared_core/domain/entities/doctor_list_entity.dart';

abstract class HomeRemoteDataSource {
  Future<NearestHospitalsResponseModel> getNearestHospitals({
    required double latitude,
    required double longitude,
  });

  /// Fetches doctors list with optional query parameters
  Future<DoctorListEntity> fetchDoctors(DoctorsQueryParamsModel queryParams);
}
