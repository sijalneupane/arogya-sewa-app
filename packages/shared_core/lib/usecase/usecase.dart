// lib/core/usecase/usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_core/error/failure.dart';

abstract class UseCase<Type, P> {
  Future<Either<Failure, Type>> call(P params);
}

class NoParams extends Equatable {
  const NoParams();
  @override
  List<Object?> get props => [];
}
