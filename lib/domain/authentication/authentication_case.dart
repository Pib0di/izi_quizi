abstract class AuthenticationCase {
  void authorize(String email, String password);

  void register(String email, String password);

  String? checkPassword(String? pass);

  String? checkEmail(String? email);

  void update();
}
