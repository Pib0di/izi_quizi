import 'package:flutter/material.dart';

abstract class HomePageCase {
  void createQuiz(String idUser, String presentName);

  ///quiz creation dialog box
  void createQuizDialog(BuildContext context);

  void joinRoom(String userName, String roomId);
}
