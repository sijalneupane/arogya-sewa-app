import 'package:dartz/dartz.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_feature/appointments/domain/entities/appointment_list_entity.dart';
import 'package:shared_feature/appointments/domain/entities/fetch_my_appointments_query_entity.dart';
import 'package:shared_feature/appointments/domain/usecase/fetch_my_appointments_usecase.dart';

/// Patient app specific wrapper for FetchMyAppointmentsUsecase
/// This allows patient app to have control over the usecase if needed
class PatientFetchMyAppointmentsUsecase {
  final FetchMyAppointmentsUsecase _fetchMyAppointmentsUsecase;

  PatientFetchMyAppointmentsUsecase(this._fetchMyAppointmentsUsecase);

  Future<Either<Failure, AppointmentListEntity>> call(
    FetchMyAppointmentsQueryEntity query,
  ) async {
    return await _fetchMyAppointmentsUsecase.call(query);
  }
}
