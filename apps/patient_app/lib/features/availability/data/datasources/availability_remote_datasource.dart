import 'package:shared_core/data/models/doctor_availability_list_model.dart';
import 'package:shared_core/data/models/availability_query_params_model.dart';

abstract class AvailabilityRemoteDataSource {
  Future<DoctorAvailabilityListModel> fetchDoctorAvailabilities(
    AvailabilityQueryParamsModel queryParams,
  );
}
