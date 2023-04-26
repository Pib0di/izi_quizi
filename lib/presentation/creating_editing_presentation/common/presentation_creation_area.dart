import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/main.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/common/side_slides.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/create_editing_state.dart';
import 'package:izi_quizi/widgets/items_shel.dart';
import 'package:izi_quizi/widgets/slide_item.dart';
import 'package:screenshot/screenshot.dart';
import 'package:universal_html/html.dart';

class PresentationCreationArea extends ConsumerWidget {
  const PresentationCreationArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonId = ref.watch(buttonID.notifier);
    ref.watch(counterSlide);

    final addItem = ref.watch(createEditing);

    ref.watch(fileProvider);

    //удаление элементов из слайда
    final itemId = ref.watch(delItemId);

    if (addItem == 1) {
      // TextSlide textBox = TextSlide.Id(data.indexOfListSlide(_buttonID.state).lengthArr());
      final itemsShel = ItemsShel.id(
        UniqueKey(),
        SlideData().indexOfListSlide(buttonId.state - 1).lengthArr(),
      );
      SlideData().indexOfListSlide(buttonId.state - 1).addItemShel(itemsShel);
    }

    if (addItem == -4) {
      pickFileWeb(buttonId.state, ref);
    }

    SlideData().indexOfListSlide(buttonId.state - 1).delItem(itemId);

    return Expanded(
      child: Screenshot(
        controller: sideSlides.screenshotController,
        child: Expanded(
          child: Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Consumer(
                        builder: (context, ref, _) {
                          var count = ref.watch(buttonID);
                          if (count > 0) {
                            --count;
                          }
                          if (count <= 0) {
                            count = 0;
                          }
                          return OverflowBox(
                            maxWidth: double.infinity,
                            maxHeight: double.infinity,
                            child: Transform.scale(
                              scale: constraints.maxWidth < 1920
                                  ? constraints.maxWidth / 1920
                                  : 1920 / constraints.maxWidth,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                                      index: 0,
                                      children: <Widget>[
                                        for (SlideItems name
                                            in SlideData().getListSlide())
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
        ),
      ),
    );
  }
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: MemoryImage(imageData!),
            fit: BoxFit.cover,
          ),
        ),
      );
      final imageBox = ItemsShel.imageWidget(UniqueKey(), imageWidget);

      SlideData().indexOfListSlide(buttonId).addItemShel(imageBox);
      // listSlide[buttonId].addItem(imageBox);
    });
  });
  ref.watch(createEditing.notifier).set(-100);

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
}
