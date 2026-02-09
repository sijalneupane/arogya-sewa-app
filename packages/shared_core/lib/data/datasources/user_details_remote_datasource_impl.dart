import 'package:shared_core/constants/arogya_sewa_api_const.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';
import 'package:shared_core/data/datasources/user_details_remote_datasource.dart';
import 'package:shared_core/data/models/user_model.dart';
import 'package:shared_core/error/datasource_exception_handler.dart';
import 'package:shared_core/network/api_client.dart';

class UserDetailsRemoteDataSourceImpl implements UserDetailsRemoteDataSource {
  final ApiClient apiClient;
  UserDetailsRemoteDataSourceImpl({required this.apiClient});
  @override
  Future<UserModel> fetchLoggedInUserDetails() async {
    try {
      final response = await apiClient.dio.get(ArogyaSewaApiConst.loggedInUserDetails);
      if (response.statusCode == 200) {
        final model = response.data as Map<String, dynamic>;
        return UserModel.fromJson(model);
      }
      throw returnKnownDioException(response, userDetailsFetchFailedString);
    } catch (e) {
     throw handleDataSourceDioException(e,path: ArogyaSewaApiConst.loggedInUserDetails);
    }
  }
}