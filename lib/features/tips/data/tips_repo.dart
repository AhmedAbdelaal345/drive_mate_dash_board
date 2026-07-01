import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:drive_mate_dash_board/core/local/api_keys.dart';
import 'package:drive_mate_dash_board/core/models/api_response.dart';
import 'package:drive_mate_dash_board/core/network/api_helper.dart';
import 'package:drive_mate_dash_board/features/tips/data/model/tip_model.dart';

abstract class TipsRepo {
  Future<Either<String, List<TipModel>>> fetchTips({
    int pageNumber = 1,
    int pageSize = 10,
    String searchTerm = '',
  });

  Future<Either<String, ApiResponse>> createTip({
    required String title,
    required String content,
    required File image,
    required String category,
  });

  // Future<ApiResponse> updateTip(String id, Map<String, dynamic> payload);

  // Future<ApiResponse> deleteTip(String id);
}

class TipsRepoImpl implements TipsRepo {
  TipsRepoImpl({ApiHelper? apiHelper}) : _api = apiHelper ?? ApiHelper();

  final ApiHelper _api;

  static const String _baseEndpoint = 'admin/tips';

  @override
  Future<Either<String, List<TipModel>>> fetchTips({
    int pageNumber = 1,
    int pageSize = 10,
    String searchTerm = '',
  }) async {
    try {
      final response = await _api.getRequest(
        endpoint: _baseEndpoint,
        isAuthorized: true,
        queryParameters: {
          'pageNumber': pageNumber,
          'pageSize': pageSize,
          'searchTerm': searchTerm,
        },
      );
      if (response.statusCode != 200) {
        return Left('Failed to fetch tips');
      }
      final data = response.data as List;
      final tips = data.map((e) => TipModel.fromJson(e)).toList();
      return Right(tips);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, ApiResponse>> createTip({
    required String title,
    required String content,
    required File image,
    required String category,
  }) async {
    try {
      final result = await _api.postRequest(
        endpoint: _baseEndpoint,
        isAuthorized: true,
        isForm: true,
        data: {
          ApiKeys.title: title,
          ApiKeys.content: content,
          "category": category,
          "image": image,
        },
      );
      if (result.statusCode != 201) {
        return Left(result.message);
      }
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // @override
  // Future<ApiResponse> updateTip(String id, Map<String, dynamic> payload) {
  //   return _api.putRequest(
  //     endpoint: '$_baseEndpoint/$id',
  //     isAuthorized: true,
  //     data: payload,
  //   );
  // }

  // @override
  // Future<ApiResponse> deleteTip(String id) {
  //   return _api.deleteRequest(
  //     endpoint: '$_baseEndpoint/$id',
  //     isAuthorized: true,
  //   );
  // }
}
