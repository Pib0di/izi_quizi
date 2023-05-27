import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/server/server_data.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/creating_editing_screen.dart';
import 'package:izi_quizi/presentation/home_page/common/present_card.dart';
import 'package:izi_quizi/presentation/home_page/home_page_state.dart';
import 'package:izi_quizi/widgets/enter_presentation_name.dart';

void joinTheRoom(String userName, String roomId) {
  joinRoom(userName, roomId);
}

void createQuiz(String idUser, String presentName) {
  createPresent(idUser, presentName);
  presentName = presentName;
}

void createQuizDialog(BuildContext context, WidgetRef ref) {
  final currentPresentName =
      ref.read(appDataProvider.notifier).currentPresentName;
  final appDataController = ref.read(appDataProvider.notifier);

  showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        contentPadding: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 12.0),
        titlePadding: const EdgeInsets.fromLTRB(14.0, 24.0, 14.0, 10.0),
        title: const Text('Создать викторину'),
        children: <Widget>[
          EnterProjectName(currentPresentName),
          SizedBox(
            height: 60.0,
            child: Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
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
                    padding: const EdgeInsets.all(16.0),
                    textStyle: const TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // ref.read(slideDataProvider.notifier).clear();
                    createQuiz(
                      appDataController.idUser,
                      currentPresentName.text,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PresentationEdit.create(),
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

List<Widget> getUserPresentations(HomePageController appDataController) {
  final presentCardList = <Widget>[];
  for (var i = 0; i < appDataController.getUserPresentName().length; ++i) {
    presentCardList.add(
      PresentCard(
        idPresent: int.parse(
          appDataController.getUserPresentName().keys.elementAt(i),
        ).toInt(),
        presentName: appDataController.getUserPresentName().values.elementAt(i),
      ),
    );
  }
  return presentCardList;
}

List<Widget> getGeneralPresentations(HomePageController appDataController) {
  final presentCardList = <Widget>[];

  return presentCardList;
}
