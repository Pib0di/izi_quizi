import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/widgets/selection_slide/selection_slide_case.dart';
import 'package:izi_quizi/widgets/selection_slide/selection_slide_state.dart';

class SelectionSlide extends ConsumerWidget {
  SelectionSlide({
    this.audioSlide,
    this.freeResponseSlide,
    this.surveySlide,
    super.key,
  });

  bool? audioSlide = false;
  bool? freeResponseSlide = false;
  bool? surveySlide = false;

  String getType() {
    String type;
    if (audioSlide ?? false) {
      type = 'audio';
    } else if (freeResponseSlide ?? false) {
      type = 'freeResponseSlide';
    } else if (surveySlide ?? false) {
      type = 'surveySlide';
    } else {
      type = '';
    }
    return type;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectionSlideProvider);
    final selectionSlideController = ref.read(selectionSlideProvider.notifier);
    final slideDataController = ref.read(slideDataProvider.notifier);

    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                if (slideDataController.isPickImage(context.widget.key!))
                  Expanded(
                    child:
                        slideDataController.getMediaWidget(context.widget.key!),
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
                                  size: 60,
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
                                    size: 60,
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
                                    size: 60,
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
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: TextField(
                            maxLines: 100000,
                            controller: slideDataController
                                .getTextController(context.widget.key!),
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
            child: audioSlide ?? false
                ? const Recorder()
                : freeResponseSlide ?? false
                    ? Question(
                        surveySlide: surveySlide ?? false,
                        freeResponseSlide: freeResponseSlide ?? false,
                        key: UniqueKey(),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: slideDataController
                                  .getListQuestion(context.widget.key!),
                            ),
                          ),
                          Positioned(
                            right: -16,
                            child: FloatingActionButton(
                              onPressed: () {
                                String typeSlide;
                                if ((surveySlide ?? false) == true) {
                                  typeSlide = 'surveySlide';
                                } else if ((freeResponseSlide ?? false) ==
                                    true) {
                                  typeSlide = 'freeResponseSlide';
                                } else {
                                  typeSlide = '';
                                }
                                ref
                                    .read(slideDataProvider.notifier)
                                    .addListQuestion(
                                      typeSlide,
                                      context.widget.key!,
                                    );
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
