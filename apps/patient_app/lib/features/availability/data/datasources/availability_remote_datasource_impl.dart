import 'package:dio/dio.dart';
import 'package:patient_app/core/constants/patient_api_const.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart';
import 'package:patient_app/features/availability/data/datasources/availability_remote_datasource.dart';
import 'package:shared_core/data/models/availability_query_params_model.dart';
import 'package:shared_core/data/models/doctor_availability_list_model.dart';
import 'package:shared_core/error/datasource_exception_handler.dart';

class AvailabilityRemoteDataSourceImpl implements AvailabilityRemoteDataSource {
  final Dio dio;

  AvailabilityRemoteDataSourceImpl(this.dio);

  @override
  Future<DoctorAvailabilityListModel> fetchDoctorAvailabilities(
    AvailabilityQueryParamsModel queryParams,
  ) async {
    try {
      final response = await dio.get(
        '${PatientApiConst.availabilities}/doctor/${queryParams.doctorId}',
        queryParameters: queryParams.toQueryParams(),
      );

      if (response.statusCode == 200) {
        return DoctorAvailabilityListModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      throw returnKnownDioException(
        response,
        failedToFetchDoctorsString,
      );
    } catch (e) {
      throw handleDataSourceDioException(
        e,
        path: '${PatientApiConst.availabilities}/doctor/${queryParams.doctorId}',
      );
    }
  }
}
