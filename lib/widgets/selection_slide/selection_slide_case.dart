import 'dart:io' as file;
import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/widgets/button_delete.dart';
import 'package:izi_quizi/widgets/selection_slide/selection_slide_state.dart';
import 'package:universal_html/html.dart' as html;

// void addQuestion(SelectionSlideController selectionSlideController) {
//   // if (selectionSlideController.list.length < 5) {
//   //   selectionSlideController.list.add(
//   //     Question(
//   //       surveySlide: surveySlide,
//   //       key: UniqueKey(),
//   //     ),
//   //   );
//   // }
// }

class Question extends ConsumerWidget {
  Question({this.surveySlide, this.freeResponseSlide, super.key});

  final TextEditingController textEditingController = TextEditingController();
  bool isSurvey = false;
  bool? surveySlide;
  bool? freeResponseSlide;

  TextEditingController getTextEditingController() {
    return textEditingController;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectionSlideProvider);
    final selectionSlideController = ref.read(selectionSlideProvider.notifier);
    print('surveySlide2 => $surveySlide');
    return Expanded(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: double.maxFinite,
              decoration: BoxDecoration(
                // color: getRandomColor(),
                // color: const Color(0xffddf59d),
                color: Theme.of(context).colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    enabled: !(freeResponseSlide ?? false),
                    controller: textEditingController,
                    style: const TextStyle(
                      fontSize: 26,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: freeResponseSlide ?? false
                          ? 'Участники будут вводить здесь свои ответы'
                          : 'Введите текст',
                    ),
                    maxLines: null,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Row(
              children: [
                if (surveySlide ?? false)
                  CheckButton(
                    keyParent: context.widget.key!,
                    key: context.widget.key!,
                    isSurvey: isSurvey,
                  ),
                if (!(freeResponseSlide ?? false))
                  Center(
                    child: ButtonDelete.deleteItemId(context.widget.key!, key: UniqueKey(),),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Color getRandomColor() {
  final random = Random();
  final r = 128 + random.nextInt(128); // оттенок красного (128-255)
  final g = 128 + random.nextInt(128); // оттенок зеленого (128-255)
  final b = 128 + random.nextInt(128); // оттенок синего (128-255)
  return Color.fromRGBO(r, g, b, 0.7);
}

Future<void> pickImageWeb(Ref ref) async {
  Uint8List? imageData;

  final input = html.FileUploadInputElement()..click();
  input.onChange.listen((event) {
    final file = input.files!.first;
    final reader = html.FileReader()..readAsArrayBuffer(file);

    reader.onLoad.listen((event) {
      imageData = reader.result as Uint8List;
      final imageWidget = Container(
        height: double.maxFinite,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: MemoryImage(imageData!),
            fit: BoxFit.contain,
          ),
        ),
      );
      // ref.read(selectionSlideProvider.notifier).setMediaWidget(imageWidget);
      final keyCurrentSlide = ref.read(selectionSlideProvider.notifier).currentKeySelectSlide;
      ref.read(slideDataProvider.notifier).setMediaWidget(imageWidget, keyCurrentSlide);
      ref.read(selectionSlideProvider.notifier).updateUi();
    });
  });
  ref.read(selectionSlideProvider.notifier).updateUi();
}

Future<void> pickImagePC(Ref ref) async {
  final result = await FilePicker.platform.pickFiles(
    dialogTitle: "Выберите изображение или gif",
    type: FileType.image,
    // allowedExtensions: ['jpg','gif','jpeg'],
  );

  if (result != null) {
    final imageFile = file.File(result.files.single.path!);

    final imageWidget = Container(
      // margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Image.file(imageFile).image,
          fit: BoxFit.contain,
        ),
      ),
    );
    // ref.read(selectionSlideProvider.notifier).setMediaWidget(imageWidget);
    final keyCurrentSlide = ref.read(selectionSlideProvider.notifier).currentKeySelectSlide;
    ref.read(slideDataProvider.notifier).setMediaWidget(imageWidget,keyCurrentSlide );
    ref.read(selectionSlideProvider.notifier).updateUi();
  } else {
    // User canceled the picker
  }
  ref.read(selectionSlideProvider.notifier).updateUi();
}

class CheckButton extends ConsumerWidget {
  const CheckButton({required this.isSurvey, required this.keyParent, super.key});

  final bool isSurvey;
  final Key keyParent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectionSlideProvider);
    final selectionSlideController = ref.read(selectionSlideProvider.notifier);
    final slideDataController = ref.read(slideDataProvider.notifier);
    return Positioned(
      right: 0,
      child: Container(
        margin: const EdgeInsets.all(5),
        width: 30,
        height: 30,
        child: RawMaterialButton(
          fillColor: Colors.grey,
          shape: const CircleBorder(),
          elevation: 0.0,
          onPressed: () {
            slideDataController.isSurveySlide(context.widget.key!, ref.read(selectionSlideProvider.notifier).currentKeySelectSlide);
            selectionSlideController.updateUi();
          },
          child: isSurvey
              ? const Icon(
                  Icons.check_circle_outline,
                  color: Colors.lightGreenAccent,
                  size: 30,
                )
              : Icon(
                  Icons.check_circle,
                  color: Colors.grey[300],
                  size: 30,
                ),
        ),
      ),
    );
  }
}

class Recorder extends ConsumerWidget {
  const Recorder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectionSlideController = ref.read(selectionSlideProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: double.maxFinite,
        decoration: BoxDecoration(
          // color: getRandomColor(),
          // color: const Color(0xffddf59d),
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${selectionSlideController.recordDuration} cек',
                        style: const TextStyle(
                          fontSize: 46,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RawMaterialButton(
                        // fillColor: Colors.grey,
                        shape: const CircleBorder(),
                        // elevation: 0.0,
                        onPressed: () {
                          if (selectionSlideController.recording) {
                            selectionSlideController.stop();
                          } else {
                            selectionSlideController.start();
                          }
                          selectionSlideController.updateUi();
                        },
                        child: selectionSlideController.recording
                            ? Column(
                                children: const [
                                  Icon(
                                    Icons.stop_circle_rounded,
                                    color: Colors.redAccent,
                                    size: 100,
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Icon(
                                    Icons.keyboard_voice_sharp,
                                    // color: Color(0xE58FDC73),
                                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                                    size: 100,
                                  ),
                                ],
                              ),
                      ),
                      selectionSlideController.recording
                          ? const Text(
                              'Остановить',
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            )
                          : const Text(
                              'Записать ответ',
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        '',
                        style: TextStyle(
                          fontSize: 46,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RawMaterialButton(
                        // fillColor: Colors.grey,
                        shape: const CircleBorder(),
                        // elevation: 0.0,
                        onPressed: () {
                          if (!selectionSlideController.isPlayRecord ||
                              selectionSlideController.recording) {
                            selectionSlideController
                              ..playRecord()
                              ..updateUi();
                          }
                        },
                        child: selectionSlideController.recording
                            ? Column(
                                children: const [
                                  SizedBox(
                                    height: 90,
                                    width: 90,
                                    child: Icon(
                                      Icons.play_circle_outline_outlined,
                                      color: Color(0xE58A8A8A),
                                      size: 100,
                                    ),
                                  ),
                                ],
                              )
                            : selectionSlideController.isPlayRecord
                                ? Column(
                                    children: const [
                                      SizedBox(
                                        height: 90,
                                        width: 90,
                                        child: CircularProgressIndicator(
                                          color: Colors.deepOrangeAccent,
                                          strokeWidth: 8,
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Icon(
                                        Icons.play_circle_outline_outlined,
                                        color: Theme.of(context).colorScheme.onTertiaryContainer,
                                        size: 100,
                                      ),
                                    ],
                                  ),
                      ),
                      selectionSlideController.isPlayRecord
                          ? const Text(
                              'Прослушать',
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            )
                          : const Text(
                              'Прослушать',
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
