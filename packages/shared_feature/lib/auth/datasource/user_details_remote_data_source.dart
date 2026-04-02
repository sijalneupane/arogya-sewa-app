import 'package:shared_feature/auth/data/models/auth_session_model.dart';

abstract class UserDetailsRemoteDataSource {
  Future<AuthSessionModel> fetchLoggedInUserDetails();
  // Future<EmployeeModel> editProfile(EditProfileModel model);
}
