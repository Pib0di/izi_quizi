import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/common_functionality/jsonParse.dart';
import 'package:izi_quizi/data/repository/local/slide_items.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/create_editing_state.dart';
import 'package:izi_quizi/presentation/single_view/single_view_screen.dart';
import 'package:izi_quizi/widgets/item_shel/items_shel.dart';
import 'package:izi_quizi/widgets/selection_slide/selection_slide_case.dart';
import 'package:izi_quizi/widgets/selection_slide/selection_slide_state.dart';

/// номер текущего слайда
final currentSlideNumber = StateProvider((ref) => 0);

/// ключ элемента в слайде для удаления
const Key key = Key('');
final delItemKey = StateProvider<Key>(
  (ref) => key,
);

final slideDataProvider = StateNotifierProvider<SlideData, int>((ref) {
  return SlideData(ref);
});

/// Информация слайда (элементы на нем)
class SlideData extends StateNotifier<int> {
  SlideData(this.ref) : super(0);

  Ref ref;
  List<int> sequenceArray = [];

  //номер слайда и его возможный список вопросов
  Map<Key, List<Question>> listQuestion = {};
  List<Widget> listSlideWidget = [];

  List<SlideItems> listSlide = [];
  Map<String, dynamic> dataSlide = {};

  void clear() {
    sequenceArray.clear();
    listSlideWidget.clear();
    listSlide.clear();
    dataSlide.clear();
  }

  void setDataSlide(Map<String, dynamic> data) {
    dataSlide = data;
  }

  Map<String, dynamic> getDataSlide() {
    return dataSlide;
  }

  void addListSlide(SlideItems item) {
    listSlide.add(item);
    sequenceArray.add(0);
  }

  void addListSlideWidget(Widget item) {
    listSlideWidget.add(item);
    sequenceArray.add(1);
  }

  void initializeQuestion(String typeSlide, Key key) {
    final indexSlide = listSlideWidget.length - 1;
    var list = <Question>[];
    if (!listQuestion.containsKey(indexSlide) && typeSlide == 'surveySlide') {
      list = <Question>[
        Question(
          surveySlide: true,
          key: UniqueKey(),
        ),
        Question(
          surveySlide: true,
          key: UniqueKey(),
        )
      ];
    } else if (!listQuestion.containsKey(indexSlide) &&
        typeSlide == 'freeResponseSlide') {
      list = <Question>[
        Question(
          freeResponseSlide: true,
          key: UniqueKey(),
        ),
        Question(
          freeResponseSlide: true,
          key: UniqueKey(),
        )
      ];
    } else {
      list = <Question>[
        Question(
          key: UniqueKey(),
        ),
        Question(
          key: UniqueKey(),
        )
      ];
    }

    listQuestion.putIfAbsent(key, () => list);
  }

  void addListQuestion(String typeSlide, Key key) {
    if (typeSlide == 'surveySlide') {
      listQuestion[key]?.add(
        Question(
          surveySlide: true,
          key: UniqueKey(),
        ),
      );
    } else if (typeSlide == 'freeResponseSlide') {
      listQuestion[key]?.add(
        Question(
          freeResponseSlide: true,
          key: UniqueKey(),
        ),
      );
    } else {
      listQuestion[key]?.add(
        Question(
          key: UniqueKey(),
        ),
      );
    }
    ref.read(selectionSlideProvider.notifier).updateUi();
  }

  void deleteListQuestion(Key deleteKey) {
    final list = listQuestion[deleteKey]!;
    if (list.length > 2) {
      listQuestion[deleteKey]!
          .removeWhere((element) => element.key == deleteKey);
    }
  }

  List<Question> getListQuestion(Key key) {
    final list = <Question>[];
    return listQuestion[key] ?? list;
  }

  void isSurveySlide(Key key) {
    final list = getListQuestion(key);
    for (var i = 0; i < list.length; ++i) {
      if (list[i].key == key) {
        list[i].isSurvey = !list[i].isSurvey;
      }
    }
    // updateUi();
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

  List<Widget> getSlide() {
    final listWidget = <Widget>[];
    var listSlideCounter = 0;
    var slideWidgetCounter = 0;
    for (var i = 0; i < sequenceArray.length; ++i) {
      if (sequenceArray[i] == 0) {
        listWidget.add(listSlide[listSlideCounter].getSlide());
        ++listSlideCounter;
      }
      if (sequenceArray[i] == 1) {
        listWidget.add(listSlideWidget[slideWidgetCounter]);
        ++slideWidgetCounter;
      }
    }
    return listWidget;
  }

  JsonParse dataSlideParse(Map<String, dynamic> data) {
    return JsonParse.fromJson(json.decode(data['list']));
  }

  void setItemsEdit() {
    final jsonParse = dataSlideParse(dataSlide);
    listSlide.clear();
    jsonParse.slidesData?.forEach((element) {
      final slide = SlideItems();

      ref.read(slidesPreviewProvider.notifier).addItem();

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
