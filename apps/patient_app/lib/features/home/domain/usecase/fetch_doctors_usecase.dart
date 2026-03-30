import 'package:dartz/dartz.dart';
import 'package:patient_app/features/home/domain/repositories/home_repository.dart';
import 'package:shared_core/domain/entities/doctor_list_entity.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/usecase/usecase.dart';

/// Use case for fetching doctors list
///
/// Usage:
/// ```dart
/// final result = await fetchDoctorsUsecase.call(
///   FetchDoctorsParams(
///     name: 'John',
///     departmentId: 'DE_123',
///     freeUpcomingOnly: true,
///   ),
/// );
/// ```
class FetchDoctorsUsecase
    implements UseCase<DoctorListEntity, FetchDoctorsParams> {
  final HomeRepository repository;

  const FetchDoctorsUsecase({required this.repository});

  @override
  Future<Either<Failure, DoctorListEntity>> call(FetchDoctorsParams params) {
    return repository.fetchDoctors(
      page: params.page,
      size: params.size,
      name: params.name,
      departmentId: params.departmentId,
      freeUpcomingOnly: params.freeUpcomingOnly,
    );
  }
}

/// Parameters for fetching doctors
class FetchDoctorsParams {
  final int page;
  final int size;
  final String? name;
  final String? departmentId;
  final bool? freeUpcomingOnly;

  const FetchDoctorsParams({
    this.page = 1,
    this.size = 10,
    this.name,
    this.departmentId,
    this.freeUpcomingOnly,
  });
}
