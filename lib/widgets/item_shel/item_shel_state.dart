import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final itemNum = StateProvider((ref) => 0);

final itemShelProvider = StateNotifierProvider((ref) {
  return ItemsShelController(ref);
});

// state - number of the selected slide
class ItemsShelController extends StateNotifier<int> {
  ItemsShelController(this.ref) : super(0);

  Ref ref;

  int itemCount = 0;
  String text = '';
  String url = '';
  double width = 300, height = 100;
  Offset offsetPos = Offset.zero;
  Widget? widgetInit;
  double left = 100, top = 100;

  Offset offset = Offset.zero;
  double angle = 0;

  bool hover = false;
  bool select = false;

  BoxBorder? border;
  BoxBorder? setBorder = Border.all(
    strokeAlign: BorderSide.strokeAlignOutside,
    color: const Color(0xDDB236BD),
    width: 4,
  );

  int getState() {
    return state;
  }

  void updateUi() {
    ++state;
  }

  void set(int value) => state = value;
}
