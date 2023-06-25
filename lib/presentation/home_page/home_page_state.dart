import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// id of the element to be added to the slide
final homePageProvider = StateNotifierProvider((ref) {
  return HomePageController();
});

class HomePageController extends StateNotifier<int> {
  HomePageController() : super(0);
  final formKey = GlobalKey<FormState>();
  final joinPresentTextController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  double currentPosition = 0;
  final nameController = TextEditingController();
  late TabController tabController;
  BuildContext? context;

  void updateUi() {
    ++state;
  }

  Map<String, dynamic> userPresentations = {};
  Map<String, dynamic> publicPresentName = {};
  Map<String, dynamic> publicPresentNameImage = {};

  void setUserPresentName(Map<String, dynamic> userPresentName) {
    userPresentations = userPresentName;
  }

  void setPublicPresentName(Map<String, dynamic> userPresentName) {
    publicPresentName = userPresentName;
  }

  void setPublicPresentNameImage(
    List<String> idPresentList,
    List<Uint8List> uint8List,
  ) {
    for (var i = 0; i < idPresentList.length; ++i) {
      // publicPresentNameImage.putIfAbsent(idPresentList[i], () => uint8List[i].cast<Uint8List>());
      final uint8Data = Uint8List.fromList(uint8List[i].cast<int>());
      publicPresentNameImage.putIfAbsent(idPresentList[i], () => uint8Data);
    }
  }

  Map<String, dynamic> getUserPresentName() {
    return userPresentations;
  }

  Map<String, dynamic> getPublicPresentName() {
    return publicPresentName;
  }

  Map<String, dynamic> getPublicPresentationsImage() {
    return publicPresentNameImage;
  }
}
