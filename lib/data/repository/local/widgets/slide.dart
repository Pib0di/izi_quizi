import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/data/repository/local/widgets/items_shel.dart';
import 'package:izi_quizi/data/repository/local/widgets/slide_item.dart';
import 'package:izi_quizi/main.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/create_editing_state.dart';
import 'package:universal_html/html.dart';

class PresentationCreationArea extends ConsumerWidget {
  PresentationCreationArea({super.key});

  final SlideData data = SlideData();

  final int numWidget = 0;

  final List<Widget> listWidgets = [];

  final List<SlideItems> listSlide = [];

  Future<Uint8List> imageElementToUint8List(
    ImageElement imageElement,
  ) async {
    // Create a Canvas element and set its dimensions to match the image element
    final canvas = CanvasElement(
      width: imageElement.width,
      height: imageElement.height,
    );

    // Draw the image element onto the canvas
    final context = canvas.context2D..drawImage(imageElement, 0, 0);

    // Get the ImageData object from the canvas
    final imageData = context.getImageData(
      0,
      0,
      imageElement.width!.toInt(),
      imageElement.height!.toInt(),
    );

    return Uint8List.view(imageData.data.buffer);
  }

  Future<void> pickFileWeb(int buttonId, WidgetRef ref) async {
    Uint8List? imageData;

    final input = FileUploadInputElement()..click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = FileReader()..readAsArrayBuffer(file);

      reader.onLoad.listen((event) {
        imageData = reader.result as Uint8List;
        final imageWidget = Container(
          // margin: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(imageData!),
              fit: BoxFit.cover,
            ),
          ),
        );
        final imageBox = ItemsShel.imageWidget(UniqueKey(), imageWidget);

        data.indexOfListSlide(buttonId).addItemShel(imageBox);
        // listSlide[buttonId].addItem(imageBox);
      });
    });

    // todo: FilePicker для
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   dialogTitle: "Выберите изображение или gif",
    //   type: FileType.image,
    //   // allowedExtensions: ['jpg','gif','jpeg'],
    // );
    //
    // if (result != null) {
    //   PlatformFile file = result.files.single;
    //
    //   print(file.path);
    //   // File _file = File(file.path!);
    //   File _file = File(file.path!);
    //   // __fileProvidere.state = _file;
    //   // print("${__fileProvidere.state}");
    //   Widget imageWidget = Container(
    //     // margin: const EdgeInsets.all(0),
    //     decoration: BoxDecoration(
    //       image: DecorationImage(
    //         image: Image.file(_file).image,
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //   );
    //
    //   // TextBox textBox = TextBox.image(UniqueKey(), _file);
    //   TextBox imageBox = TextBox.widget(UniqueKey(), imageWidget);
    //
    //   listSlide[buttonId].addItem(imageBox);
    // } else {
    //   // User canceled the picker
    // }
    ref.watch(numAddItem.notifier).set(-100);
  }

  void addWidget(int idWidget) {
    // listWidgets.add(_selectWidget[idWidget]);
  }

  final _selectWidget = <Widget>[
    // Slide(),
    Container(
      width: 290,
      height: 290,
      color: Colors.yellow,
    ),
  ];

  Widget sideMenu(int numWidget) {
    // listWidgets.add(container);
    return Container(
      width: 200,
      color: Colors.black54,
      child: Container(
        child: _selectWidget[numWidget],
      ),
    );
  }

  Widget area() {
    // listWidgets.add(container2);
    // listWidgets.add(MyStateful());
    return Expanded(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // print('constraints.maxWidth => ${constraints.maxWidth}');
            return OverflowBox(
              maxWidth: double.infinity,
              maxHeight: double.infinity,
              child: Transform.scale(
                scale: constraints.maxWidth < 1920
                    ? constraints.maxWidth / 1920
                    : 1920 / constraints.maxWidth,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.grey[350],
                  width: constraints.maxWidth *
                      (constraints.maxWidth < 1920
                          ? 1920 / constraints.maxWidth
                          : constraints.maxWidth / 1920),
                  height: constraints.maxHeight *
                      (constraints.maxWidth < 1920
                          ? 1920 / constraints.maxWidth
                          : constraints.maxWidth / 1920),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [listWidgets[0]],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonId = ref.watch(buttonID.notifier);
    ref.watch(counterSlide);

    final addItem = ref.watch(numAddItem) as int;
    ref
      ..watch(numAddItem.notifier)
      ..watch(fileProvider);

    //удаление элементов из слайда
    final itemId = ref.watch(delItemId);

    if (addItem == 1) {
      // TextSlide textBox = TextSlide.Id(data.indexOfListSlide(_buttonID.state).lengthArr());
      final itemsShel = ItemsShel.id(
        UniqueKey(),
        data.indexOfListSlide(buttonId.state - 1).lengthArr(),
      );
      data.indexOfListSlide(buttonId.state - 1).addItemShel(itemsShel);
    }

    if (addItem == -4) {
      pickFileWeb(buttonId.state, ref);
    }

    data.indexOfListSlide(buttonId.state - 1).delItem(itemId);

    return Expanded(
      child: Flexible(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Consumer(
                    builder: (context, ref, _) {
                      var count = ref.watch(buttonID);
                      if (count > 0) {
                        --count;
                      }
                      // if (_numAddItem == 1){
                      //   print(" listWidgets.length => ${listWidgets.length}");
                      //   // listWidgets[_buttonID.state];
                      // }
                      return OverflowBox(
                        maxWidth: double.infinity,
                        maxHeight: double.infinity,
                        child: Transform.scale(
                          scale: constraints.maxWidth < 1920
                              ? constraints.maxWidth / 1920
                              : 1920 / constraints.maxWidth,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.grey[350],
                            width: constraints.maxWidth *
                                (constraints.maxWidth < 1920
                                    ? 1920 / constraints.maxWidth
                                    : constraints.maxWidth / 1920),
                            height: constraints.maxHeight *
                                (constraints.maxWidth < 1920
                                    ? 1920 / constraints.maxWidth
                                    : constraints.maxWidth / 1920),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // listWidgets[count],
                                IndexedStack(
                                  sizing: StackFit.expand,
                                  index: count,
                                  children: <Widget>[
                                    for (SlideItems name in data.getListSlide())
                                      (name.getSlide()),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
