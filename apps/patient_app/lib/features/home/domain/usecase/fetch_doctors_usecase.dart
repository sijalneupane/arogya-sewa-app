import 'package:dartz/dartz.dart';
import 'package:patient_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:patient_app/features/home/domain/repositories/home_repository.dart';
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
class FetchDoctorsUsecase implements UseCase<DoctorsResult, FetchDoctorsParams> {
  final HomeRepository repository;

  const FetchDoctorsUsecase({required this.repository});

  @override
  Future<Either<Failure, DoctorsResult>> call(FetchDoctorsParams params) {
    return repository.fetchDoctors(
      name: params.name,
      departmentId: params.departmentId,
      freeUpcomingOnly: params.freeUpcomingOnly,
    );
  }
}

/// Parameters for fetching doctors
class FetchDoctorsParams {
  final String? name;
  final String? departmentId;
  final bool? freeUpcomingOnly;

  const FetchDoctorsParams({
    this.name,
    this.departmentId,
    this.freeUpcomingOnly,
  });
}
