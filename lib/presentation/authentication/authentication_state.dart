import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationPopupProvider = StateNotifierProvider((ref) {
  return AuthenticationState();
});

class AuthenticationState extends StateNotifier<int> {
  AuthenticationState() : super(0);

  bool buttonPressed = false;

  final controllerEmail = TextEditingController();
  final controllerPass = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final isAuth = false;

  void increment() {
    ++state;
  }
}
