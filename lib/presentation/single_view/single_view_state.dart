import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';

/// number of the current slide
final singleViewProvider = StateNotifierProvider((ref) {
  return SingleViewController(ref);
});

// state - number of the selected slide
class SingleViewController extends StateNotifier<int> {
  SingleViewController(this.ref) : super(0);

  Ref ref;
  late BuildContext context;

  int getTotalSlide() {
    return ref.read(slideDataProvider.notifier).getLengthListSlideWidget() - 1;
  }

  void increment() {
    if (state < getTotalSlide()) {
      ++state;
    }
  }

  void decrement() {
    if (state > 0) {
      --state;
    }
  }

  void set(int num) {
    if (num <= getTotalSlide() && num >= 0) {
      state = num;
    }
  }

  int getState() {
    return state;
  }
}
