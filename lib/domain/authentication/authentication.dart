import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/main.dart';
import 'package:izi_quizi/presentation/authentication/authentication_state.dart';

class AuthenticationCase {
  void authorize(String email, String password) {
    request.authentication(email, password);
  }

  void register(String email, String password) {
    request.register(email, password);
  }

  String? checkPassword(String? pass) {
    bool isPasswordValid(String? password) {
      if (password == null) {
        return false;
      }
      if (password.length < 8) {
        return false;
      }
      if (!password.contains(RegExp(r'[a-z]'))) {
        return false;
      }
      if (!password.contains(RegExp(r'[A-Z]'))) {
        return false;
      }
      if (!password.contains(RegExp(r'\d'))) {
        return false;
      }
      // if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
      return true;
    }

    final passwordValid = isPasswordValid(pass);
    if (pass == null || pass.isEmpty || !passwordValid) {
      return 'Пароль должен содержать a-z, A-Z, 0-9 и содержать от 8 символов';
    }
    return null;
  }

  String? checkEmail(String? email) {
    if (email == null ||
        email.isEmpty ||
        !RegExp(r"^[a-zA-Z\d.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
            .hasMatch(email)) {
      return 'Неверный формат почты';
    }
    return null;
  }

  void update() {
    AppDataState().ref?.watch(authenticationPopupProvider.notifier).increment();
  }
}
