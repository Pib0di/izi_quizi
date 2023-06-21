import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationProvider = StateNotifierProvider.autoDispose((ref) {
  return AuthenticationController();
});

class AuthenticationController extends StateNotifier<int> {
  AuthenticationController() : super(0);

  bool buttonPressed = false;
  bool registrationError = false;
  bool authorizeError = false;

  final controllerEmail = TextEditingController(text: 'test@test');
  final controllerPass = TextEditingController(text: '1234qwerASD');
  final formKey = GlobalKey<FormState>();

  bool isAuth = false;

  void authorized(String idUser) {
    ++state;
    isAuth = true;
  }

  void notAuthorized() {
    ++state;
    authorizeError = true;
    isAuth = false;
  }

  void update() {
    ++state;
  }
}

class AuthData {
  AuthData({
    required this.isAuth,
    required this.idUser,
  });

  bool isAuth;
  String idUser;
}
