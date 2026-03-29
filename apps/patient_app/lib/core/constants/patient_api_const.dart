import 'package:shared_core/constants/arogya_sewa_api_const.dart';

class PatientApiConst {
  static const String baseUrl = ArogyaSewaApiConst.baseUrl;
  static const String login = '$baseUrl/login';
  static const String nearestHospitals = '/hospital/nearest';
  static const String biometricRegister='$baseUrl/auth/biometrics/register';
  static const String biometricAuthenticate='$baseUrl/auth/biometrics/login';
  static const String biometricRevoke='$baseUrl/auth/biometrics/revoke';
}
