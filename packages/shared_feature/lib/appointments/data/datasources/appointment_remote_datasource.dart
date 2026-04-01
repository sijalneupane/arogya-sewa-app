import 'package:shared_core/data/models/appointment_model.dart';
import 'package:shared_feature/appointments/data/models/appointment_list_model.dart';
import 'package:shared_feature/appointments/data/models/create_appointment_model.dart';
import 'package:shared_feature/appointments/data/models/fetch_my_appointments_query_model.dart';

abstract class AppointmentRemoteDataSource {
  Future<AppointmentModel> createAppointment(CreateAppointmentModel payload);

  Future<AppointmentListModel> fetchPatientMyAppointments(
    FetchMyAppointmentsQueryModel query,
  );

  Future<AppointmentModel> fetchAppointmentById(String appointmentId);
}
