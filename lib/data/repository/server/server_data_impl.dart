import 'dart:async';
import 'package:izi_quizi/data/repository/server/server_data.dart';
import 'package:izi_quizi/main.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import '../local/app_data.dart';
import '../local/slide_data.dart';

class SocketConnection {

  static final _channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:5000'),
  );

  static void sendMessage(data) {
    _channel.sink.add(data);
  }

  static WebSocketChannel getConnection() {
    return _channel;
  }
}

class RequestImpl extends Request {
  RequestImpl();

  //- - - - - - - - - - - - - - - - - - - - MultipleView - - - - - - - - - - - - - - - - -
  @override
  void createRoom(String idUser, String presentName) {
    Map<String, dynamic> json() => {
      'request_to': 'MultipleView',
      'action': "createRoom",
      'idUser': idUser,
      'presentName': presentName,
    };
    SocketConnection.sendMessage(jsonEncode(json()));
  }
  @override
  void joinRoom(String userName, String roomId) {
    Map<String, dynamic> json() => {
      'request_to': 'MultipleView',
      'action': "joinRoom",
      'userName': userName,
      'roomId': roomId,
    };
    SocketConnection.sendMessage(jsonEncode(json()));
  }


  //- - - - - - - - - - - - - - - - - - - - BD - - - - - - - - - - - - - - - - -
  @override
  void setPresentation(String idUser, String presentName, String jsonSlide) {
    Map<String, dynamic> json() => {
          'request_to': 'bd',
          'action': "setSlideData",
          'idUser': idUser,
          'presentName': presentName,
          'slideData': jsonSlide,
        };
    SocketConnection.sendMessage(jsonEncode(json()));
  }

  @override
  void getPresentation(int idPresent, String presentName) {
    Map<String, dynamic> json() => {
          'request_to': 'bd',
          'action': "getSlideData",
          'idPresent': idPresent,
          'presentName': presentName,
        };
    SocketConnection.sendMessage(jsonEncode(json()));
  }

  @override
  void deletePresent(String email, String deletedPresent) {
    Map<String, dynamic> json() => {
          'request_to': 'bd',
          'action': "delete",
          'email': email,
          'nameDeletePresent': deletedPresent,
        };
    // var jsonRequest = jsonEncode(json());
    SocketConnection.sendMessage(jsonEncode(json()));
    // Map<String, dynamic> users = jsonDecode(json);
  }

  @override
  void createPresent(String idUser, String namePresent) {
    Map<String, dynamic> json() => {
          'request_to': 'bd',
          'action': "create",
          'email': idUser,
          'namePresent': namePresent,
        };
    // var jsonRequest = jsonEncode(json());
    SocketConnection.sendMessage(jsonEncode(json()));
  }

  @override
  void renamePresent(String email, String nameUpdate, String newName) {
    Map<String, dynamic> json() => {
          'request_to': 'bd',
          'action': "rename",
          'email': email,
          'nameUpdate': nameUpdate,
          'newName': newName,
        };
    SocketConnection.sendMessage(jsonEncode(json()));
  }

  @override
  Future<void> listWidget(String idUser) async {
    Map<String, dynamic> json() => {
          'request_to': 'bd',
          'action': "presentList",
          'idUser': idUser,
        };
    SocketConnection.sendMessage(jsonEncode(json()));
  }

  @override
  Future<String> authentication(String email, String pass) async {
    Map<String, dynamic> json() => {
          'request_to': 'user',
          'action': "auth",
          'email': email,
          'pass': pass,
        };
    SocketConnection.sendMessage(jsonEncode(json()));
    return 'authentication';
  }

  @override
  Future<String> register(String email, String password) async {
    Map<String, dynamic> json() => {
          'request_to': 'user',
          'action': "register",
          'email': email,
          'pass': password,
        };
    SocketConnection.sendMessage(jsonEncode(json()));
    return '_connection._channel';
  }
}

class ParseMessageImpl extends ParseMessage {
  // Future<String> getStreamValue(Stream<dynamic> stream, String expectedValue) async {
  //   Completer<String> completer = Completer<String>();
  //   StreamSubscription<dynamic>? subscription;
  //
  //   // Listen to the stream and check for the expected value
  //   subscription = stream.listen((json) {
  //     var data = Map<String, dynamic>.from(json.decode(json));
  //     switch (data['obj']) {
  //       case 'auth':
  //         {
  //           switch (data['valid']) {
  //             case 'true':
  //               {
  //                 isAuth = true;
  //                 idUser = data['idUser'];
  //                 print("idUser => $idUser");
  //                 break;
  //               }
  //             default:
  //               {
  //                 print("Authorization failed");
  //               }
  //           }
  //           break;
  //         }
  //     }
  //     if (data['valid'] == 'true'){
  //
  //     }
  //     if (data == expectedValue) {
  //       completer.complete(data.toString());
  //       subscription!.cancel();
  //     }
  //   });
  //
  //   return completer.future;
  // }

  @override
  parse(dynamic jsonData) async {
    var data = Map<String, dynamic>.from(json.decode(jsonData));
    print("data => $data");
    switch (data['obj']) {
      case 'auth':
        {
          switch (data['valid']) {
            case 'true':
              {
                appData.authentication(true);
                AppData.idUser = data['idUser'];
                print("idUser => ${AppData.idUser}");
                break;
              }
            default:
              {
                appData.authentication(true);
                appData.authentication(false);
                print("Authorization failed");
              }
          }
          break;
        }
      case 'registration':{
          switch (data['valid']) {
            case 'true':{
                // bool verification = true; // ????
                break;
              }
            default:{
                print("Registration failed");
              }
          }
          break;
        }
      case 'listWidget':{
          if (!data['list']!.isEmpty) {
            appData.setUserPresentName(data["list"]);
            widgetListIsReload = true;
          }
          break;
        }
      case 'create':{
          if (data['success'] == 'true') {
            print("present create => ${data['success']}");
            // bool _presentCreate = true; // ????
          }
          break;
        }
      case 'SlideData':{
          print("data['list'] => ${data['list']}");
          // JsonParse jsonParse = JsonParse.fromJson(json.decode(data['list']));

          SlideData slideData = SlideData();
          slideData.setDataSlide(data);
          // slideData.set(JsonParse.fromJson(json.decode(data['list'])));
          // slideData.setItemsView(JsonParse.fromJson(json.decode(data['list'])));
          break;
        }
      case 'listUser':{
        if (!data['list']!.isEmpty) {
          multipleViewData.setUserList(data["list"]);
        }
       break;
      }
      default:
        {
          print('JSON parse error (Не найдено предусмотренное значение)');
        }
    }
  }
}
