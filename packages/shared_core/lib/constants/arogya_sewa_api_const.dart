class ArogyaSewaApiConst {
  static const String baseUrl = "https://da10-27-34-73-153.ngrok-free.app/api/v1";
  static const String loginUrl = "$baseUrl/auth/login";
  static const String refreshTokenUrl = "$baseUrl/auth/refresh-token";
  static const String fileUpdateUrl = "$baseUrl/file/update";
  static const String fileUploadUrl = "$baseUrl/file/upload";
  static const String loggedInUserDetails = "$baseUrl/user/details";
  static const String doctorsUrl = "$baseUrl/doctors";
  static const String doctorAvailabilitiesUrl = "$baseUrl/availabilities/doctor";
  static const String appointmentsUrl = "$baseUrl/appointments";
  static const String patientMyAppointmentsUrl =
      "$baseUrl/appointments/patient/my-appointments";
}