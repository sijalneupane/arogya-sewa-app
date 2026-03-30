import 'package:dartz/dartz.dart';
import 'package:shared_core/domain/entities/doctor_detail_entity.dart';
import 'package:shared_core/error/failure.dart';

abstract class DoctorDetailRepository {
  Future<Either<Failure, DoctorDetailEntity>> getDoctorById(String doctorId);
}
