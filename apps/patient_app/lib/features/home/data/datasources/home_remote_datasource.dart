import 'package:patient_app/features/home/data/model/nearest_hospitals_response_model.dart';

abstract class HomeRemoteDataSource {
  Future<NearestHospitalsResponseModel> getNearestHospitals({
    required double latitude,
    required double longitude,
  });
}
