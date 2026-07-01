abstract class ApiConstants {
  static const String baseUrl = "http://drivermate.runasp.net/api/";
  static const String loginEndpoint = "Auth/login";
  static const String registerEndpoint = "Auth/register";
  static const String profileEndpoint = "user/profile";
  static const String resetPasswordEndpoint = "Auth/reset-password";
  static const String requestOTPEndpoint = "Auth/request-otp";
  static const String verifiyOTPEndpoint = "Auth/verify-otp";
  static const String changePasswordEndpoint = "Auth/change-password";
  static const String audioDiagnosisEndpoint = "Auth/audio-diagnosis";

  static String accessToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhYWJkZWxhYWwxNDVAZ21haWwuY29tIiwiaWF0IjoxNzY4ODIyMjM2LCJleHAiOjE3Njg4MjMxMzZ9.CI2BCHNh_UuLqo-8JEQxaag0C9j6miNIlFv0tIFLplc";
  static String refreshToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhYWJkZWxhYWwxNDVAZ21haWwuY29tIiwiaWF0IjoxNzY4ODIyMjM2LCJleHAiOjE3Njk0MjcwMzZ9.rdw3Qrzxx7NL1osTDL_IPwH7MEmF-dJs-33V7dziNJY";
  static const String authorization = "Authorization";
}
