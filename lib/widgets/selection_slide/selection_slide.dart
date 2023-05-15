import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/widgets/selection_slide/selection_slide_case.dart';
import 'package:izi_quizi/widgets/selection_slide/selection_slide_state.dart';

class SelectionSlide extends ConsumerWidget {
  const SelectionSlide({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectionSlideProvider.notifier);
    final selectionSlideController = ref.read(selectionSlideProvider.notifier);

    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                if (selectionSlideController.isPickImage)
                  Expanded(
                    child: selectionSlideController.getMediaWidget(),
                  )
                else
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ElevatedButton(
                            onPressed: selectionSlideController.pickImage,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.image,
                                ),
                                Text('Изображение')
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 125,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.audio_file_outlined,
                                  ),
                                  Text('Аудио')
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 125,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.video_camera_front_outlined,
                                  ),
                                  Text('Видео')
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 50,
                      right: 50,
                    ),
                    child: Container(
                      height: double.maxFinite,
                      decoration: BoxDecoration(
                        color: const Color(0xE5B7F1A1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: TextField(
                            controller: selectionSlideController.controller,
                            style: const TextStyle(
                              fontSize: 46,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Введите текст вопроса',
                            ),
                            // maxLines: null,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: selectionSlideController.audioSlide
                ? const Recorder()
                : selectionSlideController.freeResponseSlide
                    ? Question(
                        false,
                        key: UniqueKey(),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: selectionSlideController.list,
                            ),
                          ),
                          Positioned(
                            right: -16,
                            child: FloatingActionButton(
                              onPressed: () {
                                addQuestion(selectionSlideController);
                                selectionSlideController.updateUi();
                              },
                              backgroundColor: Colors.blue,
                              child: const Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
          ),
        ),
      ],
    );
  }
}
