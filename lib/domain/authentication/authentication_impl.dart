import 'package:izi_quizi/domain/authentication/authentication_case.dart';

import '../../../main.dart';

class AuthenticationImpl extends AuthenticationCase{
  @override
  void authorize(String email, String password) {
    request.authentication(email, password);
  }

  @override
  void register(String email, String password) {
    request.register(email, password);
  }

}