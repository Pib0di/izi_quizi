import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/common_functionality/jsonParse.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/common/side_slides.dart';
import 'package:izi_quizi/presentation/single_view/single_view_screen.dart';
import 'package:izi_quizi/widgets/items_shel.dart';
import 'package:izi_quizi/widgets/slide_item.dart';

/// номер текущего слайда
final buttonID = StateProvider((ref) => 0);

/// количество созданных слайдов
final counterSlide = StateProvider((ref) => 0);

/// номер элемента в слайде для удаления
const Key key = Key('');
final delItemId = StateProvider<Key>(
  (ref) => key,
);

/// Информация слайда (элементы на нем)
class SlideData {
  static final SlideData _instance = SlideData._internal();

  factory SlideData() {
    return _instance;
  }

  SlideData._internal();

  List<SlideItems> listSlide = [];

  Map<String, dynamic> dataSlide = {};

  void setDataSlide(Map<String, dynamic> data) {
    dataSlide = data;
  }

  Map<String, dynamic> getDataSlide() {
    return dataSlide;
  }

  void addListSlide(SlideItems item) {
    listSlide.add(item);
  }

  int getLengthListSlide() {
    return listSlide.length;
  }

  SlideItems indexOfListSlide(int index) {
    if (index < 0) {
      index = 0;
    }
    if (listSlide.isEmpty) {
      listSlide.add(SlideItems());
    }
    return listSlide[index];
  }

  void removeAt(int index) {
    listSlide.removeAt(index);
  }

  List<SlideItems> getListSlide() {
    return listSlide;
  }

  JsonParse dataSlideParse(Map<String, dynamic> data) {
    return JsonParse.fromJson(json.decode(data['list']));
  }

  void setItemsEdit() {
    final sideSlides = SideSlidesPreview();
    final jsonParse = dataSlideParse(dataSlide);
    listSlide.clear();
    jsonParse.slidesData?.forEach((element) {
      final slide = SlideItems();

      // AppData appData = AppData();
      // final numSlide = appData.ref!.watch(counterSlide.notifier);
      // ++numSlide.state;

      sideSlides.addSlide();

      element.textItems?.forEach((element) {
        final itemsShelText = ItemsShel.textWidgetJson(
          key: UniqueKey(),
          text: element.text!,
          width: element.width!,
          height: element.height!,
          left: element.offsetX!,
          top: element.offsetY!,
        );
        slide.addItemShel(itemsShelText);
      });
      element.imageItems?.forEach((element) {
        final itemsShelImage = ItemsShel.imageWidgetJson(
          key: UniqueKey(),
          url: element.url!,
          width: element.width!,
          height: element.height!,
          left: element.offsetX!,
          top: element.offsetY!,
        );
        slide.addItemShel(itemsShelImage);
      });

      listSlide.add(slide);
    });
  }

  void setItemsView() {
    final jsonParse = dataSlideParse(dataSlide);
    listSlide.clear();
    jsonParse.slidesData?.forEach((element) {
      final slide = SlideItems();
      element.textItems?.forEach((element) {
        final itemsViewText = ItemsViewPresentation.textWidgetJson(
          key: UniqueKey(),
          text: element.text!,
          width: element.width!,
          height: element.height!,
          left: element.offsetX!,
          top: element.offsetY!,
        );
        slide.addItemsView(itemsViewText);
      });
      element.imageItems?.forEach((element) {
        final itemsViewImage = ItemsViewPresentation.imageWidgetJson(
          key: UniqueKey(),
          url: element.url!,
          width: element.width!,
          height: element.height!,
          left: element.offsetX!,
          top: element.offsetY!,
        );
        slide.addItemsView(itemsViewImage);
      });
      listSlide.add(slide);
    });
  }
}

class ItemsShelDataText {
  String type = 'standard';
  String text = '';
  double offsetX = 0;
  double offsetY = 0;
  double width = 0;
  double height = 0;
  String property = '';
}

class ItemsShelDataImage {
  String type = 'standard';
  String? url;
  double offsetX = 0;
  double offsetY = 0;
  double width = 0;
  double height = 0;
  String? property;
}
