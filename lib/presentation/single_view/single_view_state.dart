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

  int getState() {
    return state;
  }

  void set(int value) => state = value;
}
