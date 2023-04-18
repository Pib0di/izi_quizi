import 'dart:async';
import 'dart:convert';

import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/main.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketConnection {
  static final _channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:3000'),
  );

  static void sendMessage(data) {
    _channel.sink.add(data);
  }

  static WebSocketChannel getConnection() {
    return _channel;
  }
}

class RequestImpl {
  RequestImpl();

  //- - - - - - - - - - - - - - - - - - - - MultipleView - - - - - - - - - - - - - - - - -
  void createRoom(String idUser, String presentName) {
    Map<String, dynamic> json() => {
          'request_to': 'MultipleView',
          'action': 'createRoom',
          'idUser': idUser,
          'presentName': presentName,
        };
    SocketConnection.sendMessage(jsonEncode(json()));
  }

  void joinRoom(String userName, String roomId) {
    Map<String, dynamic> json() => {
          'request_to': 'MultipleView',
          'action': 'joinRoom',
          'userName': userName,
          'roomId': roomId,
        };
    SocketConnection.sendMessage(jsonEncode(json()));
  }

  //- - - - - - - - - - - - - - - - - - - - BD - - - - - - - - - - - - - - - - -
  void setPresentation(String idUser, String presentName, String jsonSlide) {
    Map<String, dynamic> json() => {
          'request_to': 'bd',
          'action': 'setSlideData',
          'idUser': idUser,
          'presentName': presentName,
          'slideData': jsonSlide,
        };
    SocketConnection.sendMessage(jsonEncode(json()));
  }

  void getPresentation(int idPresent, String presentName) {
    Map<String, dynamic> json() => {
          'request_to': 'bd',
          'action': 'getSlideData',
          'idPresent': idPresent,
          'presentName': presentName,
        };
    SocketConnection.sendMessage(jsonEncode(json()));
  }

  void deletePresent(String email, String deletedPresent) {
    Map<String, dynamic> json() => {
          'request_to': 'bd',
          'action': 'delete',
          'email': email,
          'nameDeletePresent': deletedPresent,
        };
    // var jsonRequest = jsonEncode(json());
    SocketConnection.sendMessage(jsonEncode(json()));
    // Map<String, dynamic> users = jsonDecode(json);
  }

  void createPresent(String idUser, String namePresent) {
    Map<String, dynamic> json() => {
          'request_to': 'bd',
          'action': 'create',
          'email': idUser,
          'namePresent': namePresent,
        };
    // var jsonRequest = jsonEncode(json());
    SocketConnection.sendMessage(jsonEncode(json()));
  }

  void renamePresent(String email, String nameUpdate, String newName) {
    Map<String, dynamic> json() => {
          'request_to': 'bd',
          'action': 'rename',
          'email': email,
          'nameUpdate': nameUpdate,
          'newName': newName,
        };
    SocketConnection.sendMessage(jsonEncode(json()));
  }

  Future<void> listWidget(String idUser) async {
    Map<String, dynamic> json() => {
          'request_to': 'bd',
          'action': 'presentList',
          'idUser': idUser,
        };
    SocketConnection.sendMessage(jsonEncode(json()));
  }

  Future<String> authentication(String email, String pass) async {
    Map<String, dynamic> json() => {
          'request_to': 'user',
          'action': 'auth',
          'email': email,
          'pass': pass,
        };
    SocketConnection.sendMessage(jsonEncode(json()));
    return 'authentication';
  }

  Future<String> register(String email, String password) async {
    Map<String, dynamic> json() => {
          'request_to': 'user',
          'action': 'register',
          'email': email,
          'pass': password,
        };
    SocketConnection.sendMessage(jsonEncode(json()));
    return '_connection._channel';
  }
}

class ParseMessageImpl {
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

  Future<void> parse(jsonData) async {
    final data = Map<String, dynamic>.from(json.decode(jsonData));
    switch (data['obj']) {
      case 'auth':
        {
          switch (data['valid']) {
            case 'true':
              {
                appData.authentication(true);
                AppData.idUser = data['idUser'];
                break;
              }
            default:
              {
                appData
                  ..authentication(true)
                  ..authentication(false);
              }
          }
          break;
        }
      case 'registration':
        {
          switch (data['valid']) {
            case 'true':
              {
                // bool verification = true; // ????
                break;
              }
            default:
              {}
          }
          break;
        }
      case 'listWidget':
        {
          if (!data['list']!.isEmpty) {
            appData.setUserPresentName(data['list']);
            widgetListIsReload = true;
          }
          break;
        }
      case 'create':
        {
          if (data['success'] == 'true') {
            // bool _presentCreate = true; // ????
          }
          break;
        }
      case 'SlideData':
        {
          SlideData().setDataSlide(data);
          break;
        }
      case 'listUser':
        {
          if (!data['list']!.isEmpty) {
            multipleViewData.setUserList(data['list']);
          }
          break;
        }
      default:
        {}
    }
  }
}
