import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// id of the element to be added to the slide
final homePage = StateNotifierProvider((ref) {
  return HomePageState();
});

class HomePageState extends StateNotifier<int> {
  HomePageState() : super(0);

  final controller = TextEditingController();

  bool isAuth = false;

  void set(bool value) {
    isAuth = value;
    ++state;
  }
}
