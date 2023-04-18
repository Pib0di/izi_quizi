import 'package:flutter_riverpod/flutter_riverpod.dart';

final authUpdate = StateNotifierProvider((ref) {
  return AuthUpdate();
});

class AuthUpdate extends StateNotifier<int> {
  AuthUpdate() : super(0);

  void increment() {
    ++state;
  }
}
