// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jsonParse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Slides _$SlidesFromJson(Map<String, dynamic> json) {
  return _Slides.fromJson(json);
}

/// @nodoc
mixin _$Slides {
  @JsonKey(name: 'num_slide')
  int get numSlide => throw _privateConstructorUsedError;
  @JsonKey(name: 'slides_data')
  List<SlideData>? get slidesData => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SlidesCopyWith<Slides> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SlidesCopyWith<$Res> {
  factory $SlidesCopyWith(Slides value, $Res Function(Slides) then) =
      _$SlidesCopyWithImpl<$Res, Slides>;
  @useResult
  $Res call(
      {@JsonKey(name: 'num_slide') int numSlide,
      @JsonKey(name: 'slides_data') List<SlideData>? slidesData});
}

/// @nodoc
class _$SlidesCopyWithImpl<$Res, $Val extends Slides>
    implements $SlidesCopyWith<$Res> {
  _$SlidesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? numSlide = null,
    Object? slidesData = freezed,
  }) {
    return _then(_value.copyWith(
      numSlide: null == numSlide
          ? _value.numSlide
          : numSlide // ignore: cast_nullable_to_non_nullable
              as int,
      slidesData: freezed == slidesData
          ? _value.slidesData
          : slidesData // ignore: cast_nullable_to_non_nullable
              as List<SlideData>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SlidesCopyWith<$Res> implements $SlidesCopyWith<$Res> {
  factory _$$_SlidesCopyWith(_$_Slides value, $Res Function(_$_Slides) then) =
      __$$_SlidesCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'num_slide') int numSlide,
      @JsonKey(name: 'slides_data') List<SlideData>? slidesData});
}

/// @nodoc
class __$$_SlidesCopyWithImpl<$Res>
    extends _$SlidesCopyWithImpl<$Res, _$_Slides>
    implements _$$_SlidesCopyWith<$Res> {
  __$$_SlidesCopyWithImpl(_$_Slides _value, $Res Function(_$_Slides) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? numSlide = null,
    Object? slidesData = freezed,
  }) {
    return _then(_$_Slides(
      numSlide: null == numSlide
          ? _value.numSlide
          : numSlide // ignore: cast_nullable_to_non_nullable
              as int,
      slidesData: freezed == slidesData
          ? _value._slidesData
          : slidesData // ignore: cast_nullable_to_non_nullable
              as List<SlideData>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Slides implements _Slides {
  _$_Slides(
      {@JsonKey(name: 'num_slide')
          this.numSlide = 10,
      @JsonKey(name: 'slides_data')
          final List<SlideData>? slidesData = const []})
      : _slidesData = slidesData;

  factory _$_Slides.fromJson(Map<String, dynamic> json) =>
      _$$_SlidesFromJson(json);

  @override
  @JsonKey(name: 'num_slide')
  final int numSlide;
  final List<SlideData>? _slidesData;
  @override
  @JsonKey(name: 'slides_data')
  List<SlideData>? get slidesData {
    final value = _slidesData;
    if (value == null) return null;
    if (_slidesData is EqualUnmodifiableListView) return _slidesData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Slides(numSlide: $numSlide, slidesData: $slidesData)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Slides &&
            (identical(other.numSlide, numSlide) ||
                other.numSlide == numSlide) &&
            const DeepCollectionEquality()
                .equals(other._slidesData, _slidesData));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, numSlide, const DeepCollectionEquality().hash(_slidesData));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SlidesCopyWith<_$_Slides> get copyWith =>
      __$$_SlidesCopyWithImpl<_$_Slides>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SlidesToJson(
      this,
    );
  }
}

abstract class _Slides implements Slides {
  factory _Slides(
          {@JsonKey(name: 'num_slide') final int numSlide,
          @JsonKey(name: 'slides_data') final List<SlideData>? slidesData}) =
      _$_Slides;

  factory _Slides.fromJson(Map<String, dynamic> json) = _$_Slides.fromJson;

  @override
  @JsonKey(name: 'num_slide')
  int get numSlide;
  @override
  @JsonKey(name: 'slides_data')
  List<SlideData>? get slidesData;
  @override
  @JsonKey(ignore: true)
  _$$_SlidesCopyWith<_$_Slides> get copyWith =>
      throw _privateConstructorUsedError;
}

SlideData _$SlideDataFromJson(Map<String, dynamic> json) {
  return _SlideData.fromJson(json);
}

/// @nodoc
mixin _$SlideData {
  @JsonKey(name: 'text_items')
  List<TextItem>? get textItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_items')
  List<ImageItem>? get imageItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'quiz_item')
  QuizItem? get quizItem => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SlideDataCopyWith<SlideData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SlideDataCopyWith<$Res> {
  factory $SlideDataCopyWith(SlideData value, $Res Function(SlideData) then) =
      _$SlideDataCopyWithImpl<$Res, SlideData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'text_items') List<TextItem>? textItems,
      @JsonKey(name: 'image_items') List<ImageItem>? imageItems,
      @JsonKey(name: 'quiz_item') QuizItem? quizItem});

  $QuizItemCopyWith<$Res>? get quizItem;
}

/// @nodoc
class _$SlideDataCopyWithImpl<$Res, $Val extends SlideData>
    implements $SlideDataCopyWith<$Res> {
  _$SlideDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? textItems = freezed,
    Object? imageItems = freezed,
    Object? quizItem = freezed,
  }) {
    return _then(_value.copyWith(
      textItems: freezed == textItems
          ? _value.textItems
          : textItems // ignore: cast_nullable_to_non_nullable
              as List<TextItem>?,
      imageItems: freezed == imageItems
          ? _value.imageItems
          : imageItems // ignore: cast_nullable_to_non_nullable
              as List<ImageItem>?,
      quizItem: freezed == quizItem
          ? _value.quizItem
          : quizItem // ignore: cast_nullable_to_non_nullable
              as QuizItem?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $QuizItemCopyWith<$Res>? get quizItem {
    if (_value.quizItem == null) {
      return null;
    }

    return $QuizItemCopyWith<$Res>(_value.quizItem!, (value) {
      return _then(_value.copyWith(quizItem: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_SlideDataCopyWith<$Res> implements $SlideDataCopyWith<$Res> {
  factory _$$_SlideDataCopyWith(
          _$_SlideData value, $Res Function(_$_SlideData) then) =
      __$$_SlideDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'text_items') List<TextItem>? textItems,
      @JsonKey(name: 'image_items') List<ImageItem>? imageItems,
      @JsonKey(name: 'quiz_item') QuizItem? quizItem});

  @override
  $QuizItemCopyWith<$Res>? get quizItem;
}

/// @nodoc
class __$$_SlideDataCopyWithImpl<$Res>
    extends _$SlideDataCopyWithImpl<$Res, _$_SlideData>
    implements _$$_SlideDataCopyWith<$Res> {
  __$$_SlideDataCopyWithImpl(
      _$_SlideData _value, $Res Function(_$_SlideData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? textItems = freezed,
    Object? imageItems = freezed,
    Object? quizItem = freezed,
  }) {
    return _then(_$_SlideData(
      textItems: freezed == textItems
          ? _value._textItems
          : textItems // ignore: cast_nullable_to_non_nullable
              as List<TextItem>?,
      imageItems: freezed == imageItems
          ? _value._imageItems
          : imageItems // ignore: cast_nullable_to_non_nullable
              as List<ImageItem>?,
      quizItem: freezed == quizItem
          ? _value.quizItem
          : quizItem // ignore: cast_nullable_to_non_nullable
              as QuizItem?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SlideData implements _SlideData {
  _$_SlideData(
      {@JsonKey(name: 'text_items')
          final List<TextItem>? textItems = const [],
      @JsonKey(name: 'image_items')
          final List<ImageItem>? imageItems = const [],
      @JsonKey(name: 'quiz_item')
          this.quizItem})
      : _textItems = textItems,
        _imageItems = imageItems;

  factory _$_SlideData.fromJson(Map<String, dynamic> json) =>
      _$$_SlideDataFromJson(json);

  final List<TextItem>? _textItems;
  @override
  @JsonKey(name: 'text_items')
  List<TextItem>? get textItems {
    final value = _textItems;
    if (value == null) return null;
    if (_textItems is EqualUnmodifiableListView) return _textItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ImageItem>? _imageItems;
  @override
  @JsonKey(name: 'image_items')
  List<ImageItem>? get imageItems {
    final value = _imageItems;
    if (value == null) return null;
    if (_imageItems is EqualUnmodifiableListView) return _imageItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'quiz_item')
  final QuizItem? quizItem;

  @override
  String toString() {
    return 'SlideData(textItems: $textItems, imageItems: $imageItems, quizItem: $quizItem)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SlideData &&
            const DeepCollectionEquality()
                .equals(other._textItems, _textItems) &&
            const DeepCollectionEquality()
                .equals(other._imageItems, _imageItems) &&
            (identical(other.quizItem, quizItem) ||
                other.quizItem == quizItem));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_textItems),
      const DeepCollectionEquality().hash(_imageItems),
      quizItem);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SlideDataCopyWith<_$_SlideData> get copyWith =>
      __$$_SlideDataCopyWithImpl<_$_SlideData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SlideDataToJson(
      this,
    );
  }
}

abstract class _SlideData implements SlideData {
  factory _SlideData(
      {@JsonKey(name: 'text_items') final List<TextItem>? textItems,
      @JsonKey(name: 'image_items') final List<ImageItem>? imageItems,
      @JsonKey(name: 'quiz_item') final QuizItem? quizItem}) = _$_SlideData;

  factory _SlideData.fromJson(Map<String, dynamic> json) =
      _$_SlideData.fromJson;

  @override
  @JsonKey(name: 'text_items')
  List<TextItem>? get textItems;
  @override
  @JsonKey(name: 'image_items')
  List<ImageItem>? get imageItems;
  @override
  @JsonKey(name: 'quiz_item')
  QuizItem? get quizItem;
  @override
  @JsonKey(ignore: true)
  _$$_SlideDataCopyWith<_$_SlideData> get copyWith =>
      throw _privateConstructorUsedError;
}

TextItem _$TextItemFromJson(Map<String, dynamic> json) {
  return _TextItem.fromJson(json);
}

/// @nodoc
mixin _$TextItem {
  String? get text => throw _privateConstructorUsedError;
  double? get offsetX => throw _privateConstructorUsedError;
  double? get offsetY => throw _privateConstructorUsedError;
  double? get width => throw _privateConstructorUsedError;
  double? get height => throw _privateConstructorUsedError;
  String? get property => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TextItemCopyWith<TextItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TextItemCopyWith<$Res> {
  factory $TextItemCopyWith(TextItem value, $Res Function(TextItem) then) =
      _$TextItemCopyWithImpl<$Res, TextItem>;
  @useResult
  $Res call(
      {String? text,
      double? offsetX,
      double? offsetY,
      double? width,
      double? height,
      String? property});
}

/// @nodoc
class _$TextItemCopyWithImpl<$Res, $Val extends TextItem>
    implements $TextItemCopyWith<$Res> {
  _$TextItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = freezed,
    Object? offsetX = freezed,
    Object? offsetY = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? property = freezed,
  }) {
    return _then(_value.copyWith(
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      offsetX: freezed == offsetX
          ? _value.offsetX
          : offsetX // ignore: cast_nullable_to_non_nullable
              as double?,
      offsetY: freezed == offsetY
          ? _value.offsetY
          : offsetY // ignore: cast_nullable_to_non_nullable
              as double?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      property: freezed == property
          ? _value.property
          : property // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TextItemCopyWith<$Res> implements $TextItemCopyWith<$Res> {
  factory _$$_TextItemCopyWith(
          _$_TextItem value, $Res Function(_$_TextItem) then) =
      __$$_TextItemCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? text,
      double? offsetX,
      double? offsetY,
      double? width,
      double? height,
      String? property});
}

/// @nodoc
class __$$_TextItemCopyWithImpl<$Res>
    extends _$TextItemCopyWithImpl<$Res, _$_TextItem>
    implements _$$_TextItemCopyWith<$Res> {
  __$$_TextItemCopyWithImpl(
      _$_TextItem _value, $Res Function(_$_TextItem) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = freezed,
    Object? offsetX = freezed,
    Object? offsetY = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? property = freezed,
  }) {
    return _then(_$_TextItem(
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      offsetX: freezed == offsetX
          ? _value.offsetX
          : offsetX // ignore: cast_nullable_to_non_nullable
              as double?,
      offsetY: freezed == offsetY
          ? _value.offsetY
          : offsetY // ignore: cast_nullable_to_non_nullable
              as double?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      property: freezed == property
          ? _value.property
          : property // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TextItem implements _TextItem {
  _$_TextItem(
      {this.text,
      this.offsetX,
      this.offsetY,
      this.width,
      this.height,
      this.property});

  factory _$_TextItem.fromJson(Map<String, dynamic> json) =>
      _$$_TextItemFromJson(json);

  @override
  final String? text;
  @override
  final double? offsetX;
  @override
  final double? offsetY;
  @override
  final double? width;
  @override
  final double? height;
  @override
  final String? property;

  @override
  String toString() {
    return 'TextItem(text: $text, offsetX: $offsetX, offsetY: $offsetY, width: $width, height: $height, property: $property)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TextItem &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.offsetX, offsetX) || other.offsetX == offsetX) &&
            (identical(other.offsetY, offsetY) || other.offsetY == offsetY) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.property, property) ||
                other.property == property));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, text, offsetX, offsetY, width, height, property);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TextItemCopyWith<_$_TextItem> get copyWith =>
      __$$_TextItemCopyWithImpl<_$_TextItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TextItemToJson(
      this,
    );
  }
}

abstract class _TextItem implements TextItem {
  factory _TextItem(
      {final String? text,
      final double? offsetX,
      final double? offsetY,
      final double? width,
      final double? height,
      final String? property}) = _$_TextItem;

  factory _TextItem.fromJson(Map<String, dynamic> json) = _$_TextItem.fromJson;

  @override
  String? get text;
  @override
  double? get offsetX;
  @override
  double? get offsetY;
  @override
  double? get width;
  @override
  double? get height;
  @override
  String? get property;
  @override
  @JsonKey(ignore: true)
  _$$_TextItemCopyWith<_$_TextItem> get copyWith =>
      throw _privateConstructorUsedError;
}

ImageItem _$ImageItemFromJson(Map<String, dynamic> json) {
  return _ImageItem.fromJson(json);
}

/// @nodoc
mixin _$ImageItem {
  String? get url => throw _privateConstructorUsedError;
  double? get offsetX => throw _privateConstructorUsedError;
  double? get offsetY => throw _privateConstructorUsedError;
  double? get width => throw _privateConstructorUsedError;
  double? get height => throw _privateConstructorUsedError;
  String? get property => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ImageItemCopyWith<ImageItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageItemCopyWith<$Res> {
  factory $ImageItemCopyWith(ImageItem value, $Res Function(ImageItem) then) =
      _$ImageItemCopyWithImpl<$Res, ImageItem>;
  @useResult
  $Res call(
      {String? url,
      double? offsetX,
      double? offsetY,
      double? width,
      double? height,
      String? property});
}

/// @nodoc
class _$ImageItemCopyWithImpl<$Res, $Val extends ImageItem>
    implements $ImageItemCopyWith<$Res> {
  _$ImageItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? offsetX = freezed,
    Object? offsetY = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? property = freezed,
  }) {
    return _then(_value.copyWith(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      offsetX: freezed == offsetX
          ? _value.offsetX
          : offsetX // ignore: cast_nullable_to_non_nullable
              as double?,
      offsetY: freezed == offsetY
          ? _value.offsetY
          : offsetY // ignore: cast_nullable_to_non_nullable
              as double?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      property: freezed == property
          ? _value.property
          : property // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ImageItemCopyWith<$Res> implements $ImageItemCopyWith<$Res> {
  factory _$$_ImageItemCopyWith(
          _$_ImageItem value, $Res Function(_$_ImageItem) then) =
      __$$_ImageItemCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? url,
      double? offsetX,
      double? offsetY,
      double? width,
      double? height,
      String? property});
}

/// @nodoc
class __$$_ImageItemCopyWithImpl<$Res>
    extends _$ImageItemCopyWithImpl<$Res, _$_ImageItem>
    implements _$$_ImageItemCopyWith<$Res> {
  __$$_ImageItemCopyWithImpl(
      _$_ImageItem _value, $Res Function(_$_ImageItem) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? offsetX = freezed,
    Object? offsetY = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? property = freezed,
  }) {
    return _then(_$_ImageItem(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      offsetX: freezed == offsetX
          ? _value.offsetX
          : offsetX // ignore: cast_nullable_to_non_nullable
              as double?,
      offsetY: freezed == offsetY
          ? _value.offsetY
          : offsetY // ignore: cast_nullable_to_non_nullable
              as double?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      property: freezed == property
          ? _value.property
          : property // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ImageItem implements _ImageItem {
  _$_ImageItem(
      {this.url,
      this.offsetX,
      this.offsetY,
      this.width,
      this.height,
      this.property});

  factory _$_ImageItem.fromJson(Map<String, dynamic> json) =>
      _$$_ImageItemFromJson(json);

  @override
  final String? url;
  @override
  final double? offsetX;
  @override
  final double? offsetY;
  @override
  final double? width;
  @override
  final double? height;
  @override
  final String? property;

  @override
  String toString() {
    return 'ImageItem(url: $url, offsetX: $offsetX, offsetY: $offsetY, width: $width, height: $height, property: $property)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ImageItem &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.offsetX, offsetX) || other.offsetX == offsetX) &&
            (identical(other.offsetY, offsetY) || other.offsetY == offsetY) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.property, property) ||
                other.property == property));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, url, offsetX, offsetY, width, height, property);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ImageItemCopyWith<_$_ImageItem> get copyWith =>
      __$$_ImageItemCopyWithImpl<_$_ImageItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ImageItemToJson(
      this,
    );
  }
}

abstract class _ImageItem implements ImageItem {
  factory _ImageItem(
      {final String? url,
      final double? offsetX,
      final double? offsetY,
      final double? width,
      final double? height,
      final String? property}) = _$_ImageItem;

  factory _ImageItem.fromJson(Map<String, dynamic> json) =
      _$_ImageItem.fromJson;

  @override
  String? get url;
  @override
  double? get offsetX;
  @override
  double? get offsetY;
  @override
  double? get width;
  @override
  double? get height;
  @override
  String? get property;
  @override
  @JsonKey(ignore: true)
  _$$_ImageItemCopyWith<_$_ImageItem> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizItem _$QuizItemFromJson(Map<String, dynamic> json) {
  return _QuizItem.fromJson(json);
}

/// @nodoc
mixin _$QuizItem {
  String? get type => throw _privateConstructorUsedError;
  String? get urlImg => throw _privateConstructorUsedError;
  String? get question => throw _privateConstructorUsedError;
  List<String>? get questions => throw _privateConstructorUsedError;
  List<bool>? get isSurveyList => throw _privateConstructorUsedError;
  String? get audio => throw _privateConstructorUsedError;
  String? get property => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuizItemCopyWith<QuizItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizItemCopyWith<$Res> {
  factory $QuizItemCopyWith(QuizItem value, $Res Function(QuizItem) then) =
      _$QuizItemCopyWithImpl<$Res, QuizItem>;
  @useResult
  $Res call(
      {String? type,
      String? urlImg,
      String? question,
      List<String>? questions,
      List<bool>? isSurveyList,
      String? audio,
      String? property});
}

/// @nodoc
class _$QuizItemCopyWithImpl<$Res, $Val extends QuizItem>
    implements $QuizItemCopyWith<$Res> {
  _$QuizItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? urlImg = freezed,
    Object? question = freezed,
    Object? questions = freezed,
    Object? isSurveyList = freezed,
    Object? audio = freezed,
    Object? property = freezed,
  }) {
    return _then(_value.copyWith(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      urlImg: freezed == urlImg
          ? _value.urlImg
          : urlImg // ignore: cast_nullable_to_non_nullable
              as String?,
      question: freezed == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String?,
      questions: freezed == questions
          ? _value.questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isSurveyList: freezed == isSurveyList
          ? _value.isSurveyList
          : isSurveyList // ignore: cast_nullable_to_non_nullable
              as List<bool>?,
      audio: freezed == audio
          ? _value.audio
          : audio // ignore: cast_nullable_to_non_nullable
              as String?,
      property: freezed == property
          ? _value.property
          : property // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_QuizItemCopyWith<$Res> implements $QuizItemCopyWith<$Res> {
  factory _$$_QuizItemCopyWith(
          _$_QuizItem value, $Res Function(_$_QuizItem) then) =
      __$$_QuizItemCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? type,
      String? urlImg,
      String? question,
      List<String>? questions,
      List<bool>? isSurveyList,
      String? audio,
      String? property});
}

/// @nodoc
class __$$_QuizItemCopyWithImpl<$Res>
    extends _$QuizItemCopyWithImpl<$Res, _$_QuizItem>
    implements _$$_QuizItemCopyWith<$Res> {
  __$$_QuizItemCopyWithImpl(
      _$_QuizItem _value, $Res Function(_$_QuizItem) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? urlImg = freezed,
    Object? question = freezed,
    Object? questions = freezed,
    Object? isSurveyList = freezed,
    Object? audio = freezed,
    Object? property = freezed,
  }) {
    return _then(_$_QuizItem(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      urlImg: freezed == urlImg
          ? _value.urlImg
          : urlImg // ignore: cast_nullable_to_non_nullable
              as String?,
      question: freezed == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String?,
      questions: freezed == questions
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isSurveyList: freezed == isSurveyList
          ? _value._isSurveyList
          : isSurveyList // ignore: cast_nullable_to_non_nullable
              as List<bool>?,
      audio: freezed == audio
          ? _value.audio
          : audio // ignore: cast_nullable_to_non_nullable
              as String?,
      property: freezed == property
          ? _value.property
          : property // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_QuizItem implements _QuizItem {
  _$_QuizItem(
      {this.type = 'null',
      this.urlImg = 'null',
      this.question = 'null',
      final List<String>? questions = const [],
      final List<bool>? isSurveyList = const [],
      this.audio = 'null',
      this.property = 'null'})
      : _questions = questions,
        _isSurveyList = isSurveyList;

  factory _$_QuizItem.fromJson(Map<String, dynamic> json) =>
      _$$_QuizItemFromJson(json);

  @override
  @JsonKey()
  final String? type;
  @override
  @JsonKey()
  final String? urlImg;
  @override
  @JsonKey()
  final String? question;
  final List<String>? _questions;
  @override
  @JsonKey()
  List<String>? get questions {
    final value = _questions;
    if (value == null) return null;
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<bool>? _isSurveyList;
  @override
  @JsonKey()
  List<bool>? get isSurveyList {
    final value = _isSurveyList;
    if (value == null) return null;
    if (_isSurveyList is EqualUnmodifiableListView) return _isSurveyList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final String? audio;
  @override
  @JsonKey()
  final String? property;

  @override
  String toString() {
    return 'QuizItem(type: $type, urlImg: $urlImg, question: $question, questions: $questions, isSurveyList: $isSurveyList, audio: $audio, property: $property)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_QuizItem &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.urlImg, urlImg) || other.urlImg == urlImg) &&
            (identical(other.question, question) ||
                other.question == question) &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions) &&
            const DeepCollectionEquality()
                .equals(other._isSurveyList, _isSurveyList) &&
            (identical(other.audio, audio) || other.audio == audio) &&
            (identical(other.property, property) ||
                other.property == property));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      urlImg,
      question,
      const DeepCollectionEquality().hash(_questions),
      const DeepCollectionEquality().hash(_isSurveyList),
      audio,
      property);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_QuizItemCopyWith<_$_QuizItem> get copyWith =>
      __$$_QuizItemCopyWithImpl<_$_QuizItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_QuizItemToJson(
      this,
    );
  }
}

abstract class _QuizItem implements QuizItem {
  factory _QuizItem(
      {final String? type,
      final String? urlImg,
      final String? question,
      final List<String>? questions,
      final List<bool>? isSurveyList,
      final String? audio,
      final String? property}) = _$_QuizItem;

  factory _QuizItem.fromJson(Map<String, dynamic> json) = _$_QuizItem.fromJson;

  @override
  String? get type;
  @override
  String? get urlImg;
  @override
  String? get question;
  @override
  List<String>? get questions;
  @override
  List<bool>? get isSurveyList;
  @override
  String? get audio;
  @override
  String? get property;
  @override
  @JsonKey(ignore: true)
  _$$_QuizItemCopyWith<_$_QuizItem> get copyWith =>
      throw _privateConstructorUsedError;
}
