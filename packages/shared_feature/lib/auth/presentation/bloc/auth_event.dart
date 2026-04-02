import 'package:equatable/equatable.dart';
import 'package:shared_core/domain/entities/user_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

/// Fired once at app startup to restore persisted session.
class FetchLoggedInUser extends AuthEvent {
  const FetchLoggedInUser();
}

/// Fired after a successful login / biometric auth.
class UserLoggedIn extends AuthEvent {
  final UserEntity userData;
  const UserLoggedIn(this.userData);

  @override
  List<Object?> get props => [userData];
}

/// Fired when the user explicitly logs out.
class UserLoggedOut extends AuthEvent {
  const UserLoggedOut();
}
