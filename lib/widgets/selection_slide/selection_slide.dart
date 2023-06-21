import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/widgets/buttonFactory.dart';
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
  String? url;

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

  String? getUrl() {
    return url;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectionSlideProvider);
    final selectionSlideController = ref.read(selectionSlideProvider.notifier);
    final slideDataController = ref.read(slideDataProvider.notifier);
    final appDataController = ref.read(appDataProvider.notifier);
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // if (slideDataController.isPickImage(context.widget.key!))
                if (url != 'null' && url != null)
                  Expanded(
                    // child:
                    //     slideDataController.getMediaWidget(context.widget.key!),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          // image: NetworkImage(url ?? ''),
                          image: CachedNetworkImageProvider(url ?? ''),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                else if (!appDataController.viewingMode)
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ElevatedButton(
                            // onPressed: selectionSlideController.pickImage,
                            onPressed: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext showDialogContext) =>
                                    AlertDialog(
                                  title: const Text(
                                    'Вставьте изображение или gif',
                                  ),
                                  content: IntrinsicHeight(
                                    child: Column(
                                      children: [
                                        Form(
                                          child: TextFormField(
                                            onChanged: (value) {
                                              selectionSlideController
                                                  .updateUi();
                                            },
                                            controller: selectionSlideController
                                                .urlTextController,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText:
                                                  'https://animal/cat.jpg',
                                              labelText: 'URL',
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                        Container(
                                          width: 300,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              // image: NetworkImage(createEditingController.urlTextController.text ?? ''),
                                              // image: CachedNetworkImageProvider(url ?? ''),
                                              image: CachedNetworkImageProvider(
                                                  selectionSlideController
                                                          .urlTextController
                                                          .text ??
                                                      ''),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    ConsumerTextButton.showDialog(
                                      closeAfterClicking: true,
                                      child: const Text('отмена'),
                                    ),
                                    ConsumerTextButton.showDialog(
                                      closeAfterClicking: true,
                                      child: const Text('вставить'),
                                      onPressed: () {
                                        url = selectionSlideController
                                            .urlTextController.text;
                                        selectionSlideController.updateUi();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
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
                            readOnly: appDataController.viewingMode,
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
                        if (!appDataController.viewingMode)
                          FloatingActionButton(
                            onPressed: () {
                              String typeSlide;
                              if ((surveySlide ?? false) == true) {
                                typeSlide = 'surveySlide';
                              } else if ((freeResponseSlide ?? false) == true) {
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
                      ],
                    ),
        ),
      ],
    );
  }
}
