
import '../data/repository/local/slide_data.dart';

///parse slides
class JsonParse {
  int? numSlide;
  List<SlidesData>? slidesData;

  JsonParse({this.numSlide, this.slidesData});

  JsonParse.fromJson(Map<String, dynamic> json) {
    numSlide = json['num_slide'];
    if (json['slides_data'] != null) {
      slidesData = <SlidesData>[];
      json['slides_data'].forEach((v) {
        slidesData!.add(SlidesData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['num_slide'] = numSlide;
    if (slidesData != null) {
      data['slides_data'] = slidesData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SlidesData {
  List<TextItems>? textItems;
  List<ImageItems>? imageItems;

  SlidesData({this.textItems, this.imageItems});

  SlidesData.fromJson(Map<String, dynamic> json) {
    if (json['text_items'] != null) {
      textItems = <TextItems>[];
      json['text_items'].forEach((v) {
        textItems!.add(TextItems.fromJson(v));
      });
    }
    if (json['image_items'] != null) {
      imageItems = <ImageItems>[];
      json['image_items'].forEach((v) {
        imageItems!.add(ImageItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (textItems != null) {
      data['text_items'] = textItems!.map((v) => v.toJson()).toList();
    }
    if (imageItems != null) {
      data['image_items'] = imageItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TextItems {
  String? text;
  double? offsetX;
  double? offsetY;
  double? width;
  double? height;
  String? property;

  TextItems(
      {this.text,
        this.offsetX,
        this.offsetY,
        this.width,
        this.height,
        this.property});

  TextItems.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    offsetX = json['offsetX'];
    offsetY = json['offsetY'];
    width = json['width'];
    height = json['height'];
    property = json['property'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['offsetX'] = offsetX;
    data['offsetY'] = offsetY;
    data['width'] = width;
    data['height'] = height;
    data['property'] = property;
    return data;
  }
}

class ImageItems {
  String? url;
  double? offsetX;
  double? offsetY;
  double? width;
  double? height;
  String? property;

  ImageItems(
      {this.url,
        this.offsetX,
        this.offsetY,
        this.width,
        this.height,
        this.property});

  ImageItems.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    offsetX = json['offsetX'];
    offsetY = json['offsetY'];
    width = json['width'];
    height = json['height'];
    property = json['property'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['offsetX'] = offsetX;
    data['offsetY'] = offsetY;
    data['width'] = width;
    data['height'] = height;
    data['property'] = property;
    return data;
  }
}

class SlideJson {
  static final SlideJson _instance = SlideJson._internal();
  factory SlideJson() { return _instance;}
  SlideJson._internal();

  JsonParse slideJson(){
    // static final JsonParse _instance = JsonParse._internal();
    // factory JsonParse() { return _instance; }
    // JsonParse._internal();

    SlideData data = SlideData();

    SlidesData slidesData;
    List<SlidesData> slidesDataList = [];

    data.getListSlide().forEach((v) {
      List<ImageItems> imageItemsList = [];
      List<TextItems> textItemsList = [];
      v.getListItems().forEach((a) {
        var dataText = a.getItemsShelDataText();
        if (dataText != null && dataText.type == "text"){
          TextItems textItems = TextItems(
            text: dataText.text,
            offsetX: dataText.offsetX,
            offsetY: dataText.offsetY,
            width: dataText.width,
            height: dataText.height,
            property: "txt",
          );
          textItemsList.add(textItems);
        }

        var dataImage = a.getItemsShelDataImage();
        if (dataImage != null && dataImage.type == "image"){
          ImageItems imageItems = ImageItems(
            url: dataImage.url,
            offsetX: dataImage.offsetX,
            offsetY: dataImage.offsetY,
            width: dataImage.width,
            height: dataImage.height,
            property: "txt",
          );
          imageItemsList.add(imageItems);
        }
      });
      slidesData = SlidesData(
        imageItems: imageItemsList,
        textItems: textItemsList,
      );
      slidesDataList.add(slidesData);
    });

    // JsonParse jsonParse = JsonParse(numSlide: 20, slidesData: slidesDataList);
    return JsonParse(numSlide: 20, slidesData: slidesDataList);
  }
}


