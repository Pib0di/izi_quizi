import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:izi_quizi/main.dart';

import '../Screen/SingleView/ViewPresentation.dart';
import '../jsonParse.dart';
import '../model/ItemsShel.dart';
import '../model/SlideItem.dart';
import 'AppData.dart';
import 'SideSlides.dart';

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

  void addListSlide(SlideItems slide) {
    listSlide.add(slide);
  }

  int getLengthListSlide() {
    return listSlide.length;
  }

  SlideItems indexOfListSlide(int index) {
    return listSlide[index];
  }

  List<SlideItems> getListSlide() {
    return listSlide;
  }

  JsonParse dataSlideParse(Map<String, dynamic> data) {
    return JsonParse.fromJson(json.decode(data['list']));
  }

  void setItemsEdit() {
    AppData appData = AppData();

    SideSlides sideSlides = SideSlides();
    JsonParse jsonParse = dataSlideParse(dataSlide);
    listSlide.clear();
    jsonParse.slidesData?.forEach((element) {
      SlideItems slide = SlideItems();
      final numSlide = appData.ref!.watch(counterSlide.notifier);
      NavSlideButton navSlideButton = NavSlideButton.buttonID(
        key: UniqueKey(),
        buttonId: numSlide.state,
      );
      sideSlides.addSlide(navSlideButton);
      ++numSlide.state;


      element.textItems?.forEach((element) {
        ItemsShel itemsShelText = ItemsShel.textWidgetJson(
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
        ItemsShel itemsShelImage = ItemsShel.imageWidgetJson(
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
    JsonParse jsonParse = dataSlideParse(dataSlide);
    listSlide.clear();
    jsonParse.slidesData?.forEach((element) {
      SlideItems slide = SlideItems();
      element.textItems?.forEach((element) {
        ItemsViewPresentation itemsViewText =
            ItemsViewPresentation.textWidgetJson(
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
        ItemsViewPresentation itemsViewImage =
            ItemsViewPresentation.imageWidgetJson(
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
  String type = "standard";
  String text = '';
  double offsetX = 0;
  double offsetY = 0;
  double width = 0;
  double height = 0;
  String property = '';
}

class ItemsShelDataImage {
  String type = "standard";
  String? url;
  double offsetX = 0;
  double offsetY = 0;
  double width = 0;
  double height = 0;
  String? property;
}
