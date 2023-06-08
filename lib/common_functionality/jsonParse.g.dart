// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jsonParse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Slides _$$_SlidesFromJson(Map<String, dynamic> json) => _$_Slides(
      numSlide: json['num_slide'] as int? ?? 10,
      slidesData: (json['slides_data'] as List<dynamic>?)
              ?.map((e) => SlideData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_SlidesToJson(_$_Slides instance) => <String, dynamic>{
      'num_slide': instance.numSlide,
      'slides_data': instance.slidesData,
    };

_$_SlideData _$$_SlideDataFromJson(Map<String, dynamic> json) => _$_SlideData(
      textItems: (json['text_items'] as List<dynamic>?)
              ?.map((e) => TextItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      imageItems: (json['image_items'] as List<dynamic>?)
              ?.map((e) => ImageItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      quizItem: json['quiz_item'] == null
          ? null
          : QuizItem.fromJson(json['quiz_item'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_SlideDataToJson(_$_SlideData instance) =>
    <String, dynamic>{
      'text_items': instance.textItems,
      'image_items': instance.imageItems,
      'quiz_item': instance.quizItem,
    };

_$_TextItem _$$_TextItemFromJson(Map<String, dynamic> json) => _$_TextItem(
      text: json['text'] as String?,
      offsetX: (json['offsetX'] as num?)?.toDouble(),
      offsetY: (json['offsetY'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      property: json['property'] as String?,
    );

Map<String, dynamic> _$$_TextItemToJson(_$_TextItem instance) =>
    <String, dynamic>{
      'text': instance.text,
      'offsetX': instance.offsetX,
      'offsetY': instance.offsetY,
      'width': instance.width,
      'height': instance.height,
      'property': instance.property,
    };

_$_ImageItem _$$_ImageItemFromJson(Map<String, dynamic> json) => _$_ImageItem(
      url: json['url'] as String?,
      offsetX: (json['offsetX'] as num?)?.toDouble(),
      offsetY: (json['offsetY'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      property: json['property'] as String?,
    );

Map<String, dynamic> _$$_ImageItemToJson(_$_ImageItem instance) =>
    <String, dynamic>{
      'url': instance.url,
      'offsetX': instance.offsetX,
      'offsetY': instance.offsetY,
      'width': instance.width,
      'height': instance.height,
      'property': instance.property,
    };

_$_QuizItem _$$_QuizItemFromJson(Map<String, dynamic> json) => _$_QuizItem(
      type: json['type'] as String? ?? 'null',
      urlImg: json['urlImg'] as String? ?? 'null',
      question: json['question'] as String? ?? 'null',
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isSurveyList: (json['isSurveyList'] as List<dynamic>?)
              ?.map((e) => e as bool)
              .toList() ??
          const [],
      audio: json['audio'] as String? ?? 'null',
      property: json['property'] as String? ?? 'null',
    );

Map<String, dynamic> _$$_QuizItemToJson(_$_QuizItem instance) =>
    <String, dynamic>{
      'type': instance.type,
      'urlImg': instance.urlImg,
      'question': instance.question,
      'questions': instance.questions,
      'isSurveyList': instance.isSurveyList,
      'audio': instance.audio,
      'property': instance.property,
    };
