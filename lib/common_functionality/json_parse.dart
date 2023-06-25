// ignore_for_file: invalid_annotation_target

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';

part 'jsonParse.freezed.dart';
part 'jsonParse.g.dart';

///auto generate: flutter pub run build_runner build --delete-conflicting-outputs

@freezed
class Slides with _$Slides {
  factory Slides({
    @Default(10) @JsonKey(name: 'num_slide') int numSlide,
    @Default([]) @JsonKey(name: 'slides_data') List<SlideData>? slidesData,
  }) = _Slides;

  factory Slides.fromJson(Map<String, dynamic> json) => _$SlidesFromJson(json);
}

@freezed
class SlideData with _$SlideData {
  factory SlideData({
    @Default([]) @JsonKey(name: 'text_items') List<TextItem>? textItems,
    @Default([]) @JsonKey(name: 'image_items') List<ImageItem>? imageItems,
    @JsonKey(name: 'quiz_item') QuizItem? quizItem,
  }) = _SlideData;

  factory SlideData.fromJson(Map<String, dynamic> json) =>
      _$SlideDataFromJson(json);
}

@freezed
class TextItem with _$TextItem {
  factory TextItem({
    String? text,
    double? offsetX,
    double? offsetY,
    double? width,
    double? height,
    String? property,
  }) = _TextItem;

  factory TextItem.fromJson(Map<String, dynamic> json) =>
      _$TextItemFromJson(json);
}

@freezed
class ImageItem with _$ImageItem {
  factory ImageItem({
    String? url,
    double? offsetX,
    double? offsetY,
    double? width,
    double? height,
    String? property,
  }) = _ImageItem;

  factory ImageItem.fromJson(Map<String, dynamic> json) =>
      _$ImageItemFromJson(json);
}

@freezed
class QuizItem with _$QuizItem {
  factory QuizItem({
    @Default('null') String? type,
    @Default('null') String? urlImg,
    @Default('null') String? question,
    @Default([]) List<String>? questions,
    @Default([]) List<bool>? isSurveyList,
    @Default('null') String? audio,
    @Default('null') String? property,
  }) = _QuizItem;

  factory QuizItem.fromJson(Map<String, dynamic> json) =>
      _$QuizItemFromJson(json);
}

final slideJsonProvider = StateNotifierProvider<SlideJson, int>((ref) {
  return SlideJson(ref);
});

class SlideJson extends StateNotifier<int> {
  SlideJson(this.ref) : super(0);

  Ref ref;

  Slides slidesToJson() {
    final dataSlide = ref.read(slideDataProvider.notifier);

    SlideData slideData;
    final slideDataList = <SlideData>[];

    dataSlide.getListSlide().forEach((v) {
      final imageItemsList = <ImageItem>[];
      final textItemsList = <TextItem>[];
      v.getListItems().forEach((a) {
        final dataText = a.getItemsShelDataText();
        if (dataText != null && dataText.type == 'text') {
          final textItem = TextItem(
            text: dataText.text,
            offsetX: dataText.offsetX,
            offsetY: dataText.offsetY,
            width: dataText.width,
            height: dataText.height,
            property: 'txt',
          );
          textItemsList.add(textItem);
        }

        final dataImage = a.getItemsShelDataImage();
        if (dataImage != null && dataImage.type == 'image') {
          final imageItem = ImageItem(
            url: dataImage.url,
            offsetX: dataImage.offsetX,
            offsetY: dataImage.offsetY,
            width: dataImage.width,
            height: dataImage.height,
            property: 'txt',
          );
          imageItemsList.add(imageItem);
        }
      });
      slideData = SlideData(
        imageItems: imageItemsList,
        textItems: textItemsList,
      );
      slideDataList.add(slideData);
    });

    final slideDataController = ref.read(slideDataProvider.notifier);
    for (var i = 0;
    i < slideDataController.getListSelectionSlide().length;
    ++i) {
      final selectionSlide = slideDataController.getListSelectionSlide()[i];

      final questions = <String>[];
      final isSurveyList = <bool>[];
      slideDataController
          .getListQuestion(selectionSlide.key!)
          .forEach((element) {
        questions.add(element.getTextEditingController().text);
        isSurveyList.add(element.isSurvey);
      });
      final question = slideDataController
          .getTextController(selectionSlide.key!)!
          .value
          .text;
      final quizItem = QuizItem(
        type: selectionSlide.getType(),
        questions: questions,
        question: question,
        isSurveyList: isSurveyList,
        urlImg: selectionSlide.getUrl(),
      );

      slideData = SlideData(
        quizItem: quizItem,
      );
      slideDataList.add(slideData);
    }

    return Slides(numSlide: 20, slidesData: slideDataList);
  }
}
