import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/common_functionality/jsonParse.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/domain/create_editing_case.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/common/creating_editing_area.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/create_editing_state.dart';
import 'package:izi_quizi/widgets/enter_presentation_name.dart';

class PresentationEdit extends ConsumerWidget {
  const PresentationEdit.create({super.key});

  const PresentationEdit.edit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slideJsonController = ref.read(slideJsonProvider.notifier);
    final createEditingController = ref.read(createEditing.notifier);
    final appDataController = ref.read(appDataProvider.notifier);

    final presentationNameController = createEditingController.textController;
    final currentNamePresent = appDataController.currentPresentName;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(currentNamePresent.text),
        actions: [
          Row(
            children: [
              const Text(
                'Переименовать',
                style: TextStyle(
                  color: Colors.white60,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              RawMaterialButton(
                enableFeedback: false,
                fillColor: Colors.lightGreen,
                shape: const CircleBorder(),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: const Text('Переименовать викторину'),
                        children: <Widget>[
                          EnterProjectName(presentationNameController),
                          SizedBox(
                            height: 60.0,
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(16.0),
                                    textStyle: const TextStyle(fontSize: 20),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context, ClipRRect);
                                  },
                                  child: const Text('Отмена'),
                                ),
                                const Spacer(),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(16.0),
                                    textStyle: const TextStyle(fontSize: 20),
                                  ),
                                  onPressed: () {
                                    renameQuiz(
                                      appDataController.email,
                                      appDataController.presentName,
                                      presentationNameController.text,
                                    );
                                    currentNamePresent.text =
                                        presentationNameController.text;
                                    Navigator.pop(context, ClipRRect);
                                  },
                                  child: const Text('Переименовать'),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child:
                    const Icon(Icons.refresh, size: 25, color: Colors.white60),
              ),
              const Text(
                'Сохранить',
                style: TextStyle(
                  color: Colors.white60,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              RawMaterialButton(
                enableFeedback: false,
                fillColor: Colors.lightGreen,
                shape: const CircleBorder(),
                onPressed: () {
                  final jsonSlide = slideJsonController.slideJson();
                  saveQuiz(
                    appDataController.idUser,
                    appDataController.presentName,
                    jsonEncode(jsonSlide.toJson()),
                  );
                },
                child: const Icon(Icons.save, size: 25, color: Colors.white60),
              ),
            ],
          )
        ],
      ),
      body: const CreatingEditingArea(),
    );
  }
}
