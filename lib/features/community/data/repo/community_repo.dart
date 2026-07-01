import 'package:dartz/dartz.dart';
import 'package:drive_mate_dash_board/core/network/api_helper.dart';
import 'package:drive_mate_dash_board/features/community/data/model/community_model.dart';

import 'package:drive_mate_dash_board/core/models/api_response.dart';

abstract class CommunityRepo {
  Future<Either<String, List<CommunityPost>>> fetchPosts({
    int pageNumber = 1,
    int pageSize = 10,
    String searchTerm = '',
    CommunityFilter filter = CommunityFilter.all,
  });

  Future<ApiResponse> approvePost(String postId);

  Future<ApiResponse> deletePost(String postId);
}

class CommunityRepoImpl implements CommunityRepo {
  CommunityRepoImpl({ApiHelper? apiHelper}) : _api = apiHelper ?? ApiHelper();

  final ApiHelper _api;

  static const String _baseEndpoint = 'admin/community/posts';

  @override
  Future<Either<String, List<CommunityPost>>> fetchPosts({
    int pageNumber = 1,
    int pageSize = 10,
    String searchTerm = '',
    CommunityFilter filter = CommunityFilter.all,
  }) async {
    try {
      final result = await _api.getRequest(
        endpoint: _baseEndpoint,
        isAuthorized: true,
        queryParameters: {
          'pageNumber': pageNumber,
          'pageSize': pageSize,
          'searchTerm': searchTerm,
          'statusFilter': filter.apiValue,
        },
        // dataParser: (data) => (data as List? ?? [])
        //     .map(
        //       (e) => CommunityPost.fromJson(Map<String, dynamic>.from(e as Map)),
        //     )
        //     .toList(),
      );
      if (!result.status) {
        return Left(result.message);
      }

      final posts = (result.data as List)
          .map(
            (e) => CommunityPost.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList();

      return Right(posts);
    } on Exception catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<ApiResponse> approvePost(String postId) {
    return _api.postRequest(
      endpoint: '$_baseEndpoint/$postId/approve',
      isAuthorized: true,
    );
  }

  @override
  Future<ApiResponse> deletePost(String postId) {
    return _api.deleteRequest(
      endpoint: '$_baseEndpoint/$postId',
      isAuthorized: true,
    );
  }
}
