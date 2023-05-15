import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/local/multiple_view_data.dart';

/// number of the current slide
final multipleView = StateNotifierProvider((ref) {
  return MultipleViewState(ref);
});

// state - number of the selected slide
class MultipleViewState extends StateNotifier<int> {
  MultipleViewState(this.ref) : super(0);

  Ref ref;

  List<Widget> getUserWidgets() {
    return MultipleViewData().getUserWidgets();
  }

  void initUserListWidget() {
    MultipleViewData().initUserListWidget();
  }

  int getUserListLength() {
    return MultipleViewData().getUserList().length;
  }

  String idUser() {
    return ref.read(appDataProvider.notifier).idUser;
  }
}
