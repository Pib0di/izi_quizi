import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// id of the element to be added to the slide
final homePageProvider = StateNotifierProvider((ref) {
  return HomePageController();
});

class HomePageController extends StateNotifier<int> {
  HomePageController() : super(0);

  final joinPresentTextController = TextEditingController();
  late TabController tabController;

  void updateUi() {
    ++state;
  }

  Map<String, dynamic> userPresentations = {};

  void setUserPresentName(Map<String, dynamic> userPresentName) {
    userPresentations = userPresentName;
  }

  Map<String, dynamic> getUserPresentName() {
    return userPresentations;
  }
}
