import 'package:shared_core/data/models/user_model.dart';

abstract class UserDetailsRemoteDataSource {
  Future<UserModel> fetchLoggedInUserDetails();
}