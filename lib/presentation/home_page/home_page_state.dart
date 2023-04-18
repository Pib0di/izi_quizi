import 'package:flutter_riverpod/flutter_riverpod.dart';

/// id of the element to be added to the slide
final isAuthorized = StateNotifierProvider((ref) {
  return IsAuth();
});

class IsAuth extends StateNotifier<int> {
  IsAuth() : super(0);

  bool isAuth = false;

  void set(bool value) => isAuth = value;
}
