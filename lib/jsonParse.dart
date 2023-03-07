
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
  List<ImageItems>? imageItems;
  List<TextItems>? textItems;

  SlidesData({this.imageItems, this.textItems});

  SlidesData.fromJson(Map<String, dynamic> json) {
    if (json['image_items'] != null) {
      imageItems = <ImageItems>[];
      json['image_items'].forEach((v) {
        imageItems!.add(ImageItems.fromJson(v));
      });
    }
    if (json['text_items'] != null) {
      textItems = <TextItems>[];
      json['text_items'].forEach((v) {
        textItems!.add(TextItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (imageItems != null) {
      data['image_items'] = imageItems!.map((v) => v.toJson()).toList();
    }
    if (textItems != null) {
      data['text_items'] = textItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImageItems {
  String? url;
  String? offset;
  String? widthHeight;
  String? property;

  ImageItems({this.url, this.offset, this.widthHeight, this.property});

  ImageItems.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    offset = json['offset'];
    widthHeight = json['width_height'];
    property = json['property'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['offset'] = offset;
    data['width_height'] = widthHeight;
    data['property'] = property;
    return data;
  }
}

class TextItems {
  String? text;
  String? offset;
  String? widthHeight;
  String? property;

  TextItems({this.text, this.offset, this.widthHeight, this.property});

  TextItems.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    offset = json['offset'];
    widthHeight = json['width_height'];
    property = json['property'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['offset'] = offset;
    data['width_height'] = widthHeight;
    data['property'] = property;
    return data;
  }
}

