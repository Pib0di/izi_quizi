// ignore_for_file: avoid_dynamic_calls

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/server/server_data.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/create_editing_state.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/creating_editing_screen.dart';
import 'package:izi_quizi/presentation/home_page/common/present_card.dart';
import 'package:izi_quizi/presentation/home_page/home_page_state.dart';
import 'package:izi_quizi/utils/theme.dart';
import 'package:izi_quizi/widgets/enter_presentation_name.dart';

void joinTheRoom(String userName, String roomId) {
  joinRoom(userName, roomId);
}

void createQuizDialog(BuildContext context, WidgetRef ref) {
  final currentPresentName =
      ref.read(appDataProvider.notifier).currentPresentName;
  final appDataController = ref.read(appDataProvider.notifier);
  final createEditingController = ref.read(createEditing.notifier);
  final homePageController = ref.read(homePageProvider.notifier);

  showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        contentPadding: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 12.0),
        titlePadding: const EdgeInsets.fromLTRB(14.0, 24.0, 14.0, 10.0),
        title: const Text('Создать викторину'),
        children: <Widget>[
          EnterProjectName(currentPresentName),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Общий доступ',
                style: TextStyle(
                  fontSize: 20,
                  color: colorScheme.onBackground,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Consumer(
                builder: (context, ref, _) {
                  ref.watch(homePageProvider);
                  return Switch(
                    value: appDataController.isPublic,
                    onChanged: (bool value) {
                      appDataController.isPublic = value;
                      homePageController.updateUi();
                    },
                  );
                },
              ),
            ],
          ),
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
                    appDataController.presentName =
                        createEditingController.textController.text;
                    createPresent(
                      appDataController.idUser,
                      appDataController.presentName,
                      appDataController.isPublic,
                    );
                    getPublicListPresentation();
                    getUserListPresentation(appDataController.idUser);
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

List<Widget> getUserPresentations(HomePageController homePageController) {
  final presentCardList = <Widget>[];
  final userPresentation = homePageController.getUserPresentName();

  for (var i = 0; i < userPresentation.length; ++i) {
    final presentName = userPresentation.values.elementAt(i).split('&')[0];

    presentCardList.add(
      PresentCard(
        idPresent: userPresentation.keys.elementAt(i),
        presentName: presentName,
      ),
    );
  }
  return presentCardList;
}

List<Widget> getPublicPresentations(HomePageController homePageController) {
  final presentCardList = <Widget>[];
  final userPresentation = homePageController.getPublicPresentName();
  final userPresentationImage =
      homePageController.getPublicPresentationsImage();

  final imageNameMap = <String, dynamic>{};
  final imageNameList = <String>[];
  for (var i = 0; i < userPresentation.length; ++i) {
    final presentName =
        userPresentation.values.elementAt(i).split('&')[0].toString();
    final imageName =
        userPresentation.values.elementAt(i).split('&')[1].toString();

    var uint8List = Uint8List(0);
    if (userPresentationImage.isNotEmpty) {
      uint8List = userPresentationImage[userPresentation.keys.elementAt(i)];
    }

    imageNameMap.putIfAbsent(
      userPresentation.keys.elementAt(i),
      () => imageName,
    );
    imageNameList.add(imageName);
    presentCardList.add(
      PresentCard(
        isPublic: true,
        idPresent: userPresentation.keys.elementAt(i),
        presentName: presentName,
        uint8List: uint8List,
      ),
    );
  }
  if (imageNameMap.isNotEmpty) {
    getPublicListImagePresentation(imageNameMap);
  }

  return presentCardList;
}

List<Widget> getGeneralPresentations(HomePageController appDataController) {
  final presentCardList = <Widget>[];

  return presentCardList;
}
