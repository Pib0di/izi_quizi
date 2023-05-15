import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/common/sidebar.dart';
import 'package:screenshot/screenshot.dart';

/// id of the element to be added to the slide
final createEditing = StateNotifierProvider((ref) {
  return CreateEditingState(ref);
});

class CreateEditingState extends StateNotifier<int> {
  CreateEditingState(this.ref) : super(0);

  Ref ref;

  ///presentation name
  final textController = TextEditingController();

  late int selectedSlide;
  bool onEnter = false;

  int get() {
    return state;
  }

  void set(int value) {
    state = value;
  }

  void updateUi() {
    ++state;
  }
}

final slidesPreviewProvider =
    StateNotifierProvider<SideSlidesPreview, int>((ref) {
  return SideSlidesPreview(ref);
});

///Боковое превью слайдов
class SideSlidesPreview extends StateNotifier<int> {
  SideSlidesPreview(this.ref) : super(0);

  final Ref ref;

  var selectedIndex = 0;
  var slideSelection = false;
  late ScreenshotController screenshotController;

  List<SidebarItem> sideList = [];

  int getLengthSideList() {
    return sideList.length;
  }

  void addItem() {
    sideList.add(
      SidebarItem.buttonID(
        keyDelete: UniqueKey(),
        buttonId: sideList.length,
      ),
    );
    updateCount();
  }

  void updateCount() {
    // AppDataState().ref!.watch(counterSlide.notifier).state = sideList.length;

    var countSlide = 1;
    for (var element in sideList) {
      element.setButtonId(countSlide);
      ++countSlide;
    }
    // updateUi();
  }

  Future<void> updateImage() async {
    final currentSlideNum = ref.read(currentSlideNumber.notifier).state - 1;
    final imageFile = await screenshotController.capture();
    if (currentSlideNum >= 0)
      sideList[currentSlideNum].setImagePreview(imageFile);
    updateUi();
  }

  List<SidebarItem> getSlide() {
    return sideList;
  }

  void setSlide(List<SidebarItem> list) {
    // sideList.clear();
    sideList = list;
  }

  void delItem(Key delItemKey) {
    var i = 0;
    final slideDataController = ref.read(slideDataProvider.notifier);
    if (sideList.isNotEmpty) {
      for (var item in sideList) {
        if (item.keyDelete == delItemKey) {
          sideList.removeAt(i);
          slideDataController.removeAt(i);
          break;
        }
        // if (item.buttonId == AppDataState().ref!.watch(buttonID.notifier).state) {
        //   // --appData.ref!.watch(buttonID.notifier).state;
        // }
        ++i;
      }
      updateCount();
    }
    // sideList.retainWhere((item) => item.key != delItemId);
  }

  void updateUi() {
    ++state;
  }
}
