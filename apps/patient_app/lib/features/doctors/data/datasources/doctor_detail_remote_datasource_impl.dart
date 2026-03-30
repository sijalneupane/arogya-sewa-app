import 'package:dio/dio.dart';
import 'package:patient_app/core/constants/patient_api_const.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart';
import 'package:patient_app/features/doctors/data/datasources/doctor_detail_remote_datasource.dart';
import 'package:shared_core/data/models/doctor_detail_model.dart';
import 'package:shared_core/error/datasource_exception_handler.dart';

class DoctorDetailRemoteDataSourceImpl implements DoctorDetailRemoteDataSource {
  final Dio dio;

  DoctorDetailRemoteDataSourceImpl(this.dio);

  @override
  Future<DoctorDetailModel> getDoctorById(String doctorId) async {
    try {
      final response = await dio.get(
        '${PatientApiConst.doctors}/$doctorId',
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        return DoctorDetailModel.fromJson(
          responseData['data'] as Map<String, dynamic>,
        );
      }

      throw returnKnownDioException(response, failedToFetchDoctorsString);
    } catch (e) {
      throw handleDataSourceDioException(
        e,
        path: '${PatientApiConst.doctors}/$doctorId',
      );
    }
  }
}
