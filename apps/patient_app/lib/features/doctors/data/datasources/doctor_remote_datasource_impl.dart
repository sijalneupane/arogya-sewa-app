import 'package:dio/dio.dart';
import 'package:patient_app/core/constants/patient_api_const.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart';
import 'package:patient_app/features/doctors/data/datasources/doctor_remote_datasource.dart';
import 'package:patient_app/features/doctors/data/model/doctors_query_params_model.dart';
import 'package:shared_core/data/models/doctor_list_model.dart';
import 'package:shared_core/error/datasource_exception_handler.dart';

class DoctorRemoteDataSourceImpl implements DoctorRemoteDataSource {
  final Dio dio;

  DoctorRemoteDataSourceImpl(this.dio);

  @override
  Future<DoctorListModel> fetchDoctors(
    DoctorsQueryParamsModel queryParams,
  ) async {
    try {
      final response = await dio.get(
        PatientApiConst.doctors,
        queryParameters: queryParams.toQueryParams(),
      );

      if (response.statusCode == 200) {
        return DoctorListModel.fromJson(response.data as Map<String, dynamic>);
      }

      throw returnKnownDioException(response, failedToFetchDoctorsString);
    } catch (e) {
      throw handleDataSourceDioException(e, path: PatientApiConst.doctors);
    }
  }
}
