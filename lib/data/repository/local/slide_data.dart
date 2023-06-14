import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/common_functionality/jsonParse.dart';
import 'package:izi_quizi/data/repository/local/slide_items.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/create_editing_state.dart';
import 'package:izi_quizi/presentation/multiple_view/multiple_view_state.dart';
import 'package:izi_quizi/presentation/single_view/single_view_screen.dart';
import 'package:izi_quizi/widgets/item_shel/items_shel.dart';
import 'package:izi_quizi/widgets/selection_slide/selection_slide.dart';
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
  Map<Key, TextEditingController> selectSlideTextController = {};
  Map<Key, Widget?> listMediaWidget = {};

  List<SelectionSlide> listSelectionSlide = [];
  List<SlideItems> listSlide = [];

  Map<String, dynamic> dataSlide = {};

  void clear() {
    sequenceArray.clear();
    listSlide.clear();
    // dataSlide.clear();
    ref.read(slidesPreviewProvider.notifier).sideList.clear();
  }

  List<Widget> getSlideSingleView() {
    final listWidget = <Widget>[];
    var listSlideCounter = 0;
    var slideWidgetCounter = 0;
    for (var i = 0; i < sequenceArray.length; ++i) {
      if (sequenceArray[i] == 0) {
        listWidget.add(listSlide[listSlideCounter].getSlideView());
        ++listSlideCounter;
      }
      if (sequenceArray[i] == 1) {
        // listWidget.add(listSlideWidget[slideWidgetCounter]);
        listWidget.add(listSelectionSlide[slideWidgetCounter]);
        ++slideWidgetCounter;
      }
    }
    return listWidget;
  }

  void setMediaWidget(Widget widget, Key key) {
    listMediaWidget.putIfAbsent(key, () => widget);
  }

  Widget getMediaWidget(Key key) {
    return listMediaWidget[key] ?? const CircularProgressIndicator();
  }

  bool isPickImage(Key key) {
    return listMediaWidget[key] != null;
  }

  void setDataSlide(Map<String, dynamic> data) {
    dataSlide = data;
    ref.read(multipleViewProvider.notifier).updateUi();
  }

  void addListSlide(SlideItems item) {
    listSlide.add(item);
    sequenceArray.add(0);
  }

  void addSelectionSlide(SelectionSlide selectionSlide) {
    listSelectionSlide.add(selectionSlide);
    sequenceArray.add(1);
  }

  List<SelectionSlide> getListSelectionSlide() {
    return listSelectionSlide;
  }

  void initializeQuestion(String typeSlide, Key key) {
    // final indexSlide = listSlideWidget.length - 1;
    final indexSlide = listSelectionSlide.length - 1;
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
    if (listQuestion[key]!.length < 5) {
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
  }

  void parseListQuestion(String typeSlide, Key key, bool? survey) {
    Question question;
    if (typeSlide == 'surveySlide') {
      question = Question(
        surveySlide: true,
        key: UniqueKey(),
      );
      question!.isSurvey = survey ?? false;
    } else if (typeSlide == 'freeResponseSlide') {
      question = Question(
        freeResponseSlide: true,
        key: UniqueKey(),
      );
    } else {
      question = Question(
        key: UniqueKey(),
      );
    }
    listQuestion.putIfAbsent(key, () => []);
    addListQuestion(typeSlide, key);
  }

  void deleteListQuestion(Key deleteKey) {
    final currentKey =
        ref.read(selectionSlideProvider.notifier).currentKeySelectSlide;
    if (listQuestion.isNotEmpty) {
      final list = listQuestion[currentKey];
      if (list != null) {
        if (list.length > 2) {
          listQuestion[currentKey]!
              .removeWhere((element) => element.key == deleteKey);
          ref.read(selectionSlideProvider.notifier).updateUi();
        }
      }
    }
  }

  List<Question> getListQuestion(Key key) {
    final list = <Question>[];
    return listQuestion[key] ?? list;
  }

  TextEditingController? getTextController(Key key) {
    // final textController = TextEditingController();
    return selectSlideTextController[key];
  }

  void addSelectSlideTextController(Key key) {
    final textController = TextEditingController();
    selectSlideTextController.putIfAbsent(key, () => textController);
  }

  void isSurveySlide(Key key, Key keyParent) {
    final list = getListQuestion(keyParent);
    for (var i = 0; i < list.length; ++i) {
      if (list[i].key == key) {
        getListQuestion(keyParent)[i].isSurvey =
            !getListQuestion(keyParent)[i].isSurvey;
        ref.read(selectionSlideProvider.notifier).updateUi();
      }
    }

    // updateUi();
  }

  int getLengthListSlideWidget() {
    // return listSlideWidget.length + listSlide.length;
    return sequenceArray.length;
  }

  SlideItems indexOfListSlide(int index) {
    if (index < 0) {
      index = 0;
    }
    if (listSlide.isEmpty) {
      listSlide.add(SlideItems());
      index = 0;
    }
    final countWidget = countWidgetSlides(index);
    if (listSlide.length < index - countWidget) {
      return listSlide.last;
    }
    return listSlide[index - countWidget];
  }

  int countWidgetSlides(var currentCountSlide) {
    final slideDataController = ref.read(slideDataProvider.notifier);
    var countWidget = 0;
    for (var j = 0; j < currentCountSlide; ++j) {
      if (slideDataController.sequenceArray[j] == 1) {
        ++countWidget;
      }
    }
    return countWidget;
  }

  void removeAt(int index) {
    listSlide.removeAt(index);
  }

  List<SlideItems> getListSlide() {
    return listSlide;
  }

  List<Widget> getList() {
    // return listSlideWidget;
    return listSelectionSlide;
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
        // listWidget.add(listSlideWidget[slideWidgetCounter]);
        listWidget.add(listSelectionSlide[slideWidgetCounter]);
        ++slideWidgetCounter;
      }
    }
    return listWidget;
  }

  JsonParse dataSlideParse(Map<String, dynamic> data) {
    // return JsonParse.fromJson(json.decode(data['list']));
    return JsonParse.fromJson(json.decode(data['list']));
  }

  Slides getSlidesJson(Map<String, dynamic> data) {
    return Slides.fromJson(json.decode(data['list']));
  }

  void setSlidesEdit() {
    final slides = getSlidesJson(dataSlide);
    listSlide.clear();
    // listSlideWidget.clear();
    listSelectionSlide.clear();
    sequenceArray.clear();

    slides.slidesData?.forEach((element) {
      final slide = SlideItems();
      SelectionSlide? quizSlide;

      ref.read(slidesPreviewProvider.notifier).addItem();

      element.textItems?.forEach((element) {
        final textItem = ItemsShel.textWidgetJson(
          key: UniqueKey(),
          text: element.text!,
          width: element.width!,
          height: element.height!,
          left: element.offsetX!,
          top: element.offsetY!,
        );
        slide.addItemShel(textItem);
      });
      element.imageItems?.forEach((element) {
        final imageItem = ItemsShel.imageWidgetJson(
          key: UniqueKey(),
          url: element.url!,
          width: element.width!,
          height: element.height!,
          left: element.offsetX!,
          top: element.offsetY!,
        );
        slide.addItemShel(imageItem);
      });

      final slideDataController = ref.read(slideDataProvider.notifier);
      if (element.quizItem != null) {
        final typeQuizSlide = element.quizItem?.type;
        if (typeQuizSlide == 'surveySlide') {
          quizSlide = SelectionSlide(
            surveySlide: true,
            key: UniqueKey(),
          );
        } else if (typeQuizSlide == 'freeResponseSlide') {
          quizSlide = SelectionSlide(
            freeResponseSlide: true,
            key: UniqueKey(),
          );
        } else if (typeQuizSlide == '') {
          quizSlide = SelectionSlide(
            key: UniqueKey(),
          );
        } else if (typeQuizSlide == 'audio') {
          quizSlide = SelectionSlide(
            audioSlide: true,
            key: UniqueKey(),
          );
        }
      }

      if (quizSlide != null) {
        final quizSlideKey = quizSlide.key!;
        slideDataController
          ..addSelectionSlide(quizSlide)
          ..addSelectSlideTextController(quizSlideKey);
        var i = 0;
        element.quizItem!.questions?.forEach((value) {
          print('element.quizItem => ${value}');
          slideDataController.parseListQuestion(
            quizSlide!.getType(),
            quizSlideKey,
            true,
          );
          slideDataController
              .getListQuestion(quizSlideKey)
              .last
              .getTextEditingController()
              .text = value;
          slideDataController.getListQuestion(quizSlideKey).last.isSurvey =
              element.quizItem!.isSurveyList![i];
          ++i;
        });
        if (element.quizItem!.urlImg != null) {
          quizSlide.url = element.quizItem!.urlImg;
        }
        slideDataController.getTextController(quizSlideKey)?.text =
            element.quizItem!.question ?? 'nulllll';
      } else {
        addListSlide(slide);
      }
    });
  }

  void setSlidesSingleView() {
    final slides = getSlidesJson(dataSlide);
    listSlide.clear();
    // listSlideWidget.clear();
    listSelectionSlide.clear();
    slides.slidesData?.forEach((element) {
      final slide = SlideItems();
      SelectionSlide? quizSlide;

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
          url: element.url,
          width: element.width!,
          height: element.height!,
          left: element.offsetX!,
          top: element.offsetY!,
        );
        slide.addItemsView(itemsViewImage);
      });

      final slideDataController = ref.read(slideDataProvider.notifier);
      if (element.quizItem != null) {
        final typeQuizSlide = element.quizItem?.type;
        if (typeQuizSlide == 'surveySlide') {
          quizSlide = SelectionSlide(
            surveySlide: true,
            key: UniqueKey(),
          );
        } else if (typeQuizSlide == 'freeResponseSlide') {
          quizSlide = SelectionSlide(
            freeResponseSlide: true,
            key: UniqueKey(),
          );
        } else if (typeQuizSlide == '') {
          quizSlide = SelectionSlide(
            key: UniqueKey(),
          );
        } else if (typeQuizSlide == 'audio') {
          quizSlide = SelectionSlide(
            audioSlide: true,
            key: UniqueKey(),
          );
        }
      }

      if (quizSlide != null) {
        final quizSlideKey = quizSlide.key!;
        slideDataController
          ..addSelectionSlide(quizSlide)
          ..addSelectSlideTextController(quizSlideKey);
        var i = 0;
        element.quizItem!.questions?.forEach((value) {
          print('element.quizItem => ${value}');
          slideDataController.parseListQuestion(
            quizSlide!.getType(),
            quizSlideKey,
            true,
          );
          slideDataController
              .getListQuestion(quizSlideKey)
              .last
              .getTextEditingController()
              .text = value;
          slideDataController.getListQuestion(quizSlideKey).last.isSurvey =
              element.quizItem!.isSurveyList![i];
          ++i;
        });
        if (element.quizItem!.urlImg != null) {
          quizSlide.url = element.quizItem!.urlImg;
        }
        slideDataController.getTextController(quizSlideKey)?.text =
            element.quizItem!.question ?? 'nulllll';
      } else {
        addListSlide(slide);
      }
    });
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
