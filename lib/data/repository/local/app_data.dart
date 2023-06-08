import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final appDataProvider = StateNotifierProvider((ref) {
  return AppDataState();
});

class AppDataState extends StateNotifier<int> {
  AppDataState() : super(0);

  final currentPresentName = TextEditingController();

  int idPresent = 0;
  String idUser = '1';
  String email = '';
  String presentName = '';
  bool isMobile = false;
  bool isMobileDevice = true;

  Map<String, dynamic> userPresentations = {};

  Map<String, dynamic> getUserPresentName() {
    return userPresentations;
  }

  void setIdUser(String userId) {
    idUser = userId;
  }

  void setEmail(String userEmail) {
    email = userEmail;
  }

  Future<void> checkMobileMode() async {
    isMobile = await isMobileBrowser();

    if (Platform.isAndroid || Platform.isIOS) {
      isMobileDevice = true;
    } else {
      isMobileDevice = false;
    }
  }

  WidgetRef? ref;

  void updateUi() {
    ++state;
  }
}

Future<bool> isMobileBrowser() async {
  try {
    final response =
        await http.get(Uri.parse('https://httpbin.org/user-agent'));
    final userAgent = response.body;

    if (userAgent.contains('Mobile')) {
      return true;
      // typeBrowser = 'Mobile';
    } else if (userAgent.contains('Browser')) {
      return true;
      // typeBrowser = 'Browser';
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

class AppData {
  AppData(
    this.idUser,
    this.email,
    this.presentName,
    this.typeBrowser,
    this.isMobile,
  );

  String idUser;
  String email;
  String presentName;
  String typeBrowser;
  bool isMobile = false;

  Map<String, dynamic> userPresentations = {};
}
