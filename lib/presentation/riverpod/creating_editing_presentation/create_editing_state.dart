import 'package:flutter_riverpod/flutter_riverpod.dart';

/// id of the element to be added to the slide
final numAddItem = StateNotifierProvider((ref) {
  return ItemId();
});

class ItemId extends StateNotifier<int> {
  ItemId(): super(0);

  void set(int value) => state = value;
}