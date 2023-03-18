import 'package:flutter/cupertino.dart';
import 'package:izi_quizi/slide.dart';

import '../jsonParse.dart';
import 'ItemsShel.dart';
import 'SlideItem.dart';

class SlideData{
  static final SlideData _instance = SlideData._internal();
  factory SlideData() { return _instance; }
  SlideData._internal();

  List<SlideItems> listSlide = [];


  void addListSlide(SlideItems slide){
    listSlide.add(slide);
  }
  int getLengthListSlide(){
    return listSlide.length;
  }

  SlideItems indexOfListSlide(int index){
    return listSlide[index];
  }

  List<SlideItems> getListSlide(){
    return listSlide;
  }

  void set(JsonParse jsonParse){
    listSlide.clear();
    jsonParse.slidesData?.forEach((element) {
      SlideItems slide = SlideItems();

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