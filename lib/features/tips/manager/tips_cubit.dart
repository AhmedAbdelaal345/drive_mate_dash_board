import 'dart:io';

import 'package:drive_mate_dash_board/features/tips/data/tips_repo.dart';
import 'package:drive_mate_dash_board/features/tips/manager/tips_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TipsCubit extends Cubit<TipsState> {
  TipsCubit(this._repo) : super(const TipsInitial());

  final TipsRepo _repo;

  Future<void> loadTips() async {
    emit(const TipsLoading());
    try {
      final response = await _repo.fetchTips();
      response.fold(
        (l) {
          emit(TipsError(l));
        },
        (r) {
          emit(TipsSuccess(r));
        },
      );
    } on Exception catch (e) {
      emit(TipsError(e.toString()));
    }
  }

  Future<void> createTip({
    required String title,
    required String content,
    required File image,
    required String category,
  }) async {
    try {
      emit(const TipsLoading());
      final response = await _repo.createTip(
        title: title,
        content: content,
        image: image,
        category: category,
      );
      response.fold(
        (l) {
          emit(TipsError(l));
        },
        (r) {
          emit(TipCreateSuccess(r.message));
        },
      );
    } on Exception catch (e) {
      emit(TipsError(e.toString()));
    }
  }

  // Future<void> deleteTip(String id) async {
  //   try {
  //     await _repo.deleteTip(id);
  //     await loadTips();
  //   } on Exception catch (e) {
  //     emit(TipsError(e.toString()));
  //   }
  // }
}
