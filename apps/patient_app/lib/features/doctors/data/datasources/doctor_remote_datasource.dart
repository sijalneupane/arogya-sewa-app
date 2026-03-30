import 'package:patient_app/features/doctors/data/model/doctors_query_params_model.dart';
import 'package:shared_core/data/models/doctor_list_model.dart';

abstract class DoctorRemoteDataSource {
  Future<DoctorListModel> fetchDoctors(DoctorsQueryParamsModel queryParams);
}
