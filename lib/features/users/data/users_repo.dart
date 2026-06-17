import 'package:drive_mate_dash_board/core/models/api_response.dart';
import 'package:drive_mate_dash_board/features/users/data/model/user_model.dart';
import 'package:drive_mate_dash_board/shared/mock_data.dart';

class UsersRepo {
  Future<ApiResponse<List<UserModel>>> getUsers() async {
    // TODO: Implement API Integration
    return ApiResponse.success(MockData.users);
  }
}
