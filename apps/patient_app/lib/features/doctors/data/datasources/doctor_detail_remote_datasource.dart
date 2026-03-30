import 'package:shared_core/data/models/doctor_detail_model.dart';

abstract class DoctorDetailRemoteDataSource {
  Future<DoctorDetailModel> getDoctorById(String doctorId);
}
