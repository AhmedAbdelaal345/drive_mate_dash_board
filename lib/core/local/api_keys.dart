abstract class ApiKeys {
  static const String fullname = "fullName";
  static const String email = "email";
  static const String password = "password";
  static const String confirmPassword = "confirmPassword";
  static const String isAgreed = "isAgreed";
  static const String id = "id";
  static const String message = "message";
  static const String choices = "choices";
  static const String content = "content";
  // the keys for the response body for register and login endpoints
  static const String status = "success";
  static const String data = "data";
  static const String userId = "userId";
  static const String role = "role";
  static const String accessToken = "accessToken";
  static const String refreshToken = "refreshToken";

  // the keys for the response body for the profile endpoint
  static const String phone = "phoneNumber";
  static const String image = "profileImageUrl";
  static const String editImageProfile = "ProfileImage";
  // the keys for the response body for the add cars endpoint
  static const String brandId = "brandId";
  static const String modelId = "modelId";
  static const String year = "year";
  static const String plateNumber = "plateNumber";
  static const String currentMileage = "currentMileage";
  static const String file = "file";
  // this is for ai voice diagnosis endpoint
  static const String audioPath = "audioPath";
  static const String result = "result";
  static const String severity = "severity";
  static const String confidence = "confidence";
  static const String createdAt = "createdAt";

  //this is for community posts endpoints
  static const String title = "title";
  static const String authorName = "authorName";
  static const String authorInitials = "authorInitials";
  static const String postType = "postType";
  static const String images = "images";
  static const String isLikedByCurrentUser = "isLikedByCurrentUser";
  static const String likeCount = "likeCount";
  static const String imagesCount = "imagesCount";
  static const String commentCount = "commentCount";

  //this is for community comments
  static const String parentCommentId = "parentCommentId";
  static const String postId = "postId";
}
