import 'package:shared_feature/auth/data/models/auth_session_model.dart';
import 'package:shared_feature/auth/datasource/user_details_remote_data_source.dart';
import 'package:shared_core/network/api_client.dart';
import 'package:shared_core/constants/arogya_sewa_api_const.dart';
import 'package:shared_core/error/datasource_exception_handler.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';

class UserDetailsRemoteDataSourceImpl implements UserDetailsRemoteDataSource {
  final ApiClient apiClient;

  UserDetailsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AuthSessionModel> fetchLoggedInUserDetails() async {
    try {
      final response = await apiClient.dio.get(ArogyaSewaApiConst.loggedInUserDetails);
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return AuthSessionModel.fromJson(data);
      }
      throw returnKnownDioException(response, userDetailsFetchFailedString);
    } catch (e) {
      throw handleDataSourceDioException(e, path: ArogyaSewaApiConst.loggedInUserDetails);
    }
  }
}
