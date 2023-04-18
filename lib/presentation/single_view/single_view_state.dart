import 'package:flutter_riverpod/flutter_riverpod.dart';

/// number of the current slide
final slideNumProvider = StateNotifierProvider((ref) {
  return Counter();
});

class Counter extends StateNotifier<int> {
  Counter() : super(0);

  void increment() => ++state;

  void decrement() => --state;

  void set(int value) => state = value;
}
