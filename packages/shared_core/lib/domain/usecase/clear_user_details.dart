import 'package:dartz/dartz.dart';
import 'package:shared_core/domain/repository/user_details_repository.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/usecase/usecase.dart';

class ClearUserDetails extends UseCase<void, NoParams> {
  final UserDetailsRepository repo;

  ClearUserDetails({required this.repo});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repo.clearUserDetails();
  }
}