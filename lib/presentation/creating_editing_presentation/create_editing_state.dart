import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// id of the element to be added to the slide
final createEditing = StateNotifierProvider((ref) {
  return CreateEditingState();
});

class CreateEditingState extends StateNotifier<int> {
  CreateEditingState() : super(0);

  late BuildContext context;

  int get() {
    return state;
  }

  void set(int value) {
    state = value;
  }
}
