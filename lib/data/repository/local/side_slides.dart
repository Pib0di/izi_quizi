import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/data/repository/local/widgets/slide_item.dart';
import 'package:izi_quizi/data/repository/local/widgets/widgets_collection.dart';
import 'package:izi_quizi/main.dart';
import 'package:screenshot/screenshot.dart';

///Боковое выбора слайдов при редоактировании
class SideSlides {
  static final SideSlides _instance = SideSlides._internal();

  factory SideSlides() {
    return _instance;
  }

  SideSlides._internal();

  ScreenshotController screenshotController = ScreenshotController();

  Future updatePreview(int index) async {
    await screenshotController.capture().then((capturedImage) async {
      sideList[index - 1].setImagePreview(capturedImage);
      //   // sideList.forEach((element) {
      //   //   element.setImagePreview(capturedImage);
      //   // });
    }).catchError((onError) {});
  }

  List<NavSlideButton> sideList = [];

  int getLengthSideList() {
    return sideList.length;
  }

  void addSlide() {
    sideList.add(
      NavSlideButton.buttonID(
        keyDelete: UniqueKey(),
        buttonId: sideList.length,
      ),
    );
    updateCount();
  }

  void updateCount() {
    final appData = AppData();
    appData.ref!.watch(counterSlide.notifier).state = sideList.length;

    var countSlide = 1;
    for (var element in sideList) {
      element.setButtonId(countSlide);
      ++countSlide;
    }
  }

  List<NavSlideButton> getSlide() {
    return sideList;
  }

  void setSlide(List<NavSlideButton> list) {
    // sideList.clear();
    sideList = list;
  }

  void delItem(Key delItemId) {
    var i = 0;
    final slideData = SlideData();
    for (var item in sideList) {
      if (item.key == delItemId) {
        sideList.removeAt(i);
        slideData.removeAt(i - 1);
      }
      if (item.buttonId == appData.ref!.watch(buttonID.notifier).state) {
        // --appData.ref!.watch(buttonID.notifier).state;
      }
      ++i;
    }
    // sideList.retainWhere((item) => item.key != delItemId);
  }
}

class NavSlideButton extends ConsumerStatefulWidget {
  // NavSlideButton({Key? key}) : super(key: key);
  NavSlideButton.buttonID({required this.buttonId, required this.keyDelete})
      : super(key: key);

  void setButtonId(int id) {
    buttonId = id;
  }

  void setImagePreview(Uint8List? capturedImage) {
    imageFile = capturedImage!;
  }

  final Key keyDelete;
  Uint8List imageFile = Uint8List(0);
  int buttonId = -10;

  @override
  NavSlideButtonState createState() => NavSlideButtonState();
}

class NavSlideButtonState extends ConsumerState<NavSlideButton> {
  double width = 0;
  double widthBorder = 0;
  bool select = false;

  void kh(bool b) {
    setState(() {
      if (b) {
        widthBorder = 3;
      } else {
        widthBorder = 0;
      }
    });
  }

  Widget _hoverMenu = const Text('');
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final hoverMenu2 = ButtonDelete.deleteItemId(widget.keyDelete);
    void hoverMenu(bool b) {
      setState(() {
        if (b) {
          _hoverMenu = hoverMenu2;
        } else {
          _hoverMenu = const Text('');
        }
      });
    }

    final counter = ref.watch(buttonID.notifier);
    ref
      ..watch(buttonID)
      ..watch(counterSlide);

    width = counter.state == widget.buttonId ? 3 : 0;
    // var decorationImage = DecorationImage(
    //   // image: widget._imageFile != null ? MemoryImage(widget._imageFile!) : MemoryImage(widget._imageFile!),
    //   image: MemoryImage(widget.imageFile),
    //   // image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
    //   fit: BoxFit.cover,
    // );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          MouseRegion(
            onEnter: (e) {
              hoverMenu(true);
            },
            onExit: (e) {
              // counter.state == ButtonID ? hoverMenu(true) : hoverMenu(false);
              hoverMenu(false);
            },
            child: Stack(
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  height: 111,
                  decoration: BoxDecoration(
                    border: Border.all(
                      strokeAlign: BorderSide.strokeAlignOutside,
                      width: counter.state == widget.buttonId
                          ? width
                          : widthBorder,
                      // selectButtonID == ButtonID ? 3 : 0,
                    ),
                    color: const Color(0xff84b67c),
                    image: DecorationImage(
                      image: MemoryImage(widget.imageFile),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ElevatedButton(
                    onHover: kh,
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.only(bottom: 10),
                    ),
                    // shape: const RoundedRectangleBorder(),
                    onPressed: () {
                      sideSlides.updatePreview(widget.buttonId);
                      counter.state = widget.buttonId;
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xE5DFFFD6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                            '${widget.buttonId}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                counter.state == widget.buttonId ? hoverMenu2 : _hoverMenu,
              ],
            ),
          ),
          const SizedBox(
            height: 7,
          )
        ],
      ),
    );
  }
}

SideSlides sideSlides = SideSlides();

class ListSlide extends ConsumerStatefulWidget {
  const ListSlide({super.key});

  @override
  ListSlideState createState() => ListSlideState();
}

class ListSlideState extends ConsumerState<ListSlide> {
  Future<void> waitUntilBuildComplete() async {
    await Future.delayed(Duration.zero);
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    sideSlides.updateCount();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(counterSlide.notifier);
    final delId = ref.watch(delItemId);
    // final delIdd = ref.watch(counterSlide);

    sideSlides.delItem(delId);
    waitUntilBuildComplete();

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: sideSlides.getSlide().length,
            itemBuilder: (BuildContext context, int index) {
              return sideSlides.getSlide()[index];
            },
          ),
        ),
        const SizedBox(
          height: 7,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 6),
          child: ElevatedButton(
            style: ButtonStyle(
              alignment: Alignment.center,
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 5),
              ),
            ),
            onPressed: () {
              setState(() {
                sideSlides.addSlide();
                SlideData().addListSlide(SlideItems());
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[Text('Добавить')],
            ),
          ),
        )
      ],
    );
  }
}
