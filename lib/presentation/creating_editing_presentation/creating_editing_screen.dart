import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:izi_quizi/common_functionality/jsonParse.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/domain/creating_editing_presentation/create_editing.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/common/creating_editing_area.dart';
import 'package:izi_quizi/widgets/widgets_collection.dart';

class PresentationEdit extends StatelessWidget {
  PresentationEdit.create(String name, {super.key}) : currentNamePresent = name;

  PresentationEdit.edit(String name, {super.key}) : currentNamePresent = name;
  late final String currentNamePresent;
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(currentNamePresent),
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
                          ProjectName(myController),
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
                                    CreateEditingCase().renameQuiz(
                                      AppDataState.email,
                                      AppDataState.presentName,
                                      myController.text,
                                    );
                                    currentNamePresent = myController.text;
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
                  final jsonSlide = SlideJson().slideJson();
                  CreateEditingCase().saveQuiz(
                    AppDataState.idUser,
                    AppDataState.presentName,
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


