import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';

/// number of the current slide
final singleView = StateNotifierProvider((ref) {
  return SingleViewState();
});

// state - number of the selected slide
class SingleViewState extends StateNotifier<int> {
  SingleViewState() : super(0);
  final totalSlide = SlideData().getLengthListSlide() - 1;

  int getTotalSlide() => totalSlide;

  void increment() {
    if (state < totalSlide) {
      ++state;
    }
  }

  void decrement() {
    if (state > 0) {
      --state;
    }
  }

  void set(int value) => state = value;
}
