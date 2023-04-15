import 'package:izi_quizi/domain/authentication/authentication_case.dart';

import '../../../main.dart';
import '../../presentation/riverpod/authentication/authentication_state.dart';

class AuthenticationImpl extends AuthenticationCase{
  @override
  void authorize(String email, String password) {
    request.authentication(email, password);
  }

  @override
  void register(String email, String password) {
    request.register(email, password);
  }

  @override
  String? checkPassword(String? pass){
    bool isPasswordValid(String? password) {
      if (password == null) return false;
      if (password.length < 8) return false;
      if (!password.contains(RegExp(r"[a-z]"))) return false;
      if (!password.contains(RegExp(r"[A-Z]"))) return false;
      if (!password.contains(RegExp(r"[0-9]"))) return false;
      // if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
      return true;
    }

    final bool passwordValid = isPasswordValid(pass);
    if (pass == null || pass.isEmpty || !passwordValid) {
      return "Пароль должен содержать a-z, A-Z, 0-9 и содержать от 8 символов";
    }
    return null;
  }

  @override
  String? checkEmail(String? email) {
    if (email == null ||
        email.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
            .hasMatch(email)) {
      return 'Неверный формат почты';
    }
    return null;
  }

  @override
  void update() {
    appData.ref?.watch(authUpdate.notifier).increment();
  }
}