import 'package:dio/dio.dart';
import 'package:patient_app/features/home/data/model/nearest_hospitals_response_model.dart';
import 'home_remote_datasource.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl(this.dio);

  @override
  Future<NearestHospitalsResponseModel> getNearestHospitals({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await dio.get(
        '/hospital/nearest',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
        },
      );

      if (response.statusCode == 200) {
        return NearestHospitalsResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch nearest hospitals');
      }
    } catch (e) {
      rethrow;
    }
  }
}
