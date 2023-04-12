import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:izi_quizi/Widgets/widgets_collection.dart';
import 'package:izi_quizi/main.dart';

import '../../data/repository/local/app_data.dart';
import '../../presentation/screen/creating_editing_screen.dart';
import 'home_page_case.dart';

class HomePageCaseImpl extends HomePageCase {
  @override
  void joinRoom(String userName, String roomId) {
    request.joinRoom(userName, roomId);
  }

  @override
  void createQuiz(String idUser, String presentName) {
    request.createPresent(idUser, presentName);
    presentName = presentName;
  }

  @override
  void createQuizDialog(BuildContext context) {
    final myController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: const Color(0xE5F4FFF0),
            contentPadding: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 12.0),
            titlePadding: const EdgeInsets.fromLTRB(14.0, 24.0, 14.0, 10.0),
            title: const Text('Создать викторину'),
            children: <Widget>[
              ProgectName(myController),
              SizedBox(
                height: 60.0,
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade300,
                        padding: const EdgeInsets.all(16.0),
                        textStyle: const TextStyle(fontSize: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        print("cancel");
                        Navigator.pop(context, ClipRRect);
                      },
                      child: const Text('Отмена'),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade300,
                        padding: const EdgeInsets.all(16.0),
                        textStyle: const TextStyle(fontSize: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        createQuiz(AppData.idUser, myController.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PresentationEdit.create(myController.text)),
                        );
                      },
                      child: const Text('Создать'),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
