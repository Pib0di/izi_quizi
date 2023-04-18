import 'package:flutter/material.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/local/widgets/widgets_collection.dart';
import 'package:izi_quizi/main.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/creating_editing_screen.dart';

class HomePageCaseImpl {
  void joinRoom(String userName, String roomId) {
    request.joinRoom(userName, roomId);
  }

  void createQuiz(String idUser, String presentName) {
    request.createPresent(idUser, presentName);
    presentName = presentName;
  }

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
            ProjectName(myController),
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
                              PresentationEdit.create(myController.text),
                        ),
                      );
                    },
                    child: const Text('Создать'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
