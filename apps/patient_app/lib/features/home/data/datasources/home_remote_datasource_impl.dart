import 'package:dio/dio.dart';
import 'package:patient_app/core/constants/patient_api_const.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart';
import 'package:patient_app/features/home/data/model/nearest_hospitals_response_model.dart';
import 'package:shared_core/error/datasource_exception_handler.dart';
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
        PatientApiConst.nearestHospitals,
        queryParameters: {'latitude': latitude, 'longitude': longitude},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NearestHospitalsResponseModel.fromJson(response.data);
      }
      throw returnKnownDioException(response, failedToFetchHospitalsString);
    } catch (e) {
      throw handleDataSourceDioException(
        e,
        path: PatientApiConst.nearestHospitals,
      );
    }
  }
}
