
abstract class Request{

  ///getting data for multiple viewing
  void createRoom(String idUser, String presentName);
  void joinRoom(String userName, String roomId);

  ///receiving and sending presentation slides from the server
  void getPresentation(int idPresent, String presentName);
  void setPresentation(String idUser, String presentName, String jsonSlide);

  void deletePresent(String email, String deletedPresent);
  void createPresent(String idUser, String namePresent);
  void renamePresent(String email, String nameUpdate, String newName);

  ///requesting a list of presentations owned by a user with ID = [idUser]
  Future<void> listWidget(String idUser);

  Future<String> authentication(String email, String password);
  Future<String> register(String email, String pass);

}

abstract class ParseMessage {
  ///parsing messages received from the server and updating the UI (remake??)
  parse(dynamic jsonData);
}