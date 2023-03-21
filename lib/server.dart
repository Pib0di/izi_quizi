import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:izi_quizi/Factory%D0%A1lasses/AppData.dart';

// - - - - - - - - - - - - - SOCKET - - - - - - - - - -
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert' show json;
import 'dart:convert';
import 'jsonParse.dart';
import 'main.dart';
import 'FactoryСlasses/SlideData.dart';

class SocketConnection {
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8000'),
    // Uri.parse('wss://echo.websocket.events'),
  );
  void sendMessage(data) {
    _channel.sink.add(data);
  }

  Future<dynamic> ListenMessage() async {
    _channel.stream.listen((data) {
      print(data);
    });
    return _channel.stream;
  }

  WebSocketChannel getConnection() {
    return _channel;
  }
}

class User {
  User._();
  User(this.email);

  String email = '';
}

class Request {
  Request(this._connection);

  SocketConnection _connection;

  //- - - - - - - - - - - - - - - - - - - - BD - - - - - - - - - - - - - - - - -
  void setSlideData(String idUser, String presentName, String jsonSlide) {
    Map<String, dynamic> json() => {
          'request_to': 'bd',
          'action': "setSlideData",
          'idUser': idUser,
          'presentName': presentName,
          'slideData': jsonSlide,
        };
    _connection.sendMessage(jsonEncode(json()));
  }

  void getSlideData(int idPresent, String presentName) {
    Map<String, dynamic> json() => {
          'request_to': 'bd',
          'action': "getSlideData",
          'idPresent': idPresent,
          'presentName': presentName,
        };
    print("jsonEncode(json())=> ${jsonEncode(json())}");
    _connection.sendMessage(jsonEncode(json()));
  }

  void deletePresent(String email, String deletedPresent) {
    Map<String, dynamic> json() => {
          'request_to': 'bd',
          'action': "delete",
          'email': email,
          'nameDeletePresent': deletedPresent,
        };
    // var jsonRequest = jsonEncode(json());
    _connection.sendMessage(jsonEncode(json()));
    // Map<String, dynamic> users = jsonDecode(json);
  }

  void createPresent(String idUser, String namePresent) {
    Map<String, dynamic> json() => {
          'request_to': 'bd',
          'action': "create",
          'email': idUser,
          'namePresent': namePresent,
        };
    // var jsonRequest = jsonEncode(json());
    _connection.sendMessage(jsonEncode(json()));
  }

  void renamePresent(String email, String nameUpdate, String newName) {
    Map<String, dynamic> json() => {
          'request_to': 'bd',
          'action': "rename",
          'email': email,
          'nameUpdate': nameUpdate,
          'newName': newName,
        };
    // var jsonRequest = jsonEncode(json());
    _connection.sendMessage(jsonEncode(json()));
  }

  Future<void> listWidget(String idUser) async {
    Map<String, dynamic> json() => {
          'request_to': 'bd',
          'action': "presentList",
          'idUser': idUser,
        };
    _connection.sendMessage(jsonEncode(json()));
    // return "";
  }

  Future<String> authentication(String email, String pass) async {
    Map<String, dynamic> json() => {
          'request_to': 'user',
          'action': "auth",
          'email': email,
          'pass': pass,
        };
    _connection.sendMessage(jsonEncode(json()));
    return 'authentication';
  }

  Future<String> register(String email, String pass) async {
    Map<String, dynamic> json() => {
          'request_to': 'user',
          'action': "register",
          'email': email,
          'pass': pass,
        };
    // var jsonRequest = jsonEncode(json());
    _connection.sendMessage(jsonEncode(json()));
    return '_connection._channel';
  }
}



class ParseMessege {
  ParseMessege();

  Future<String> sfd() async {

    return "";
  }

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

  parse(dynamic _json) async {

    var data = Map<String, dynamic>.from(json.decode(_json));
    print("data => $data");
    switch (data['obj']) {
      case 'auth':
        {
          switch (data['valid']) {
            case 'true':
              {
                appData.authentication(true);
                idUser = data['idUser'];
                print("idUser => $idUser");
                break;
              }
            default:
              {
                // await Future.delayed(Duration(seconds: 2));
                appData.authentication(true);
                appData.authentication(false);
                print("Authorization failed");
              }
          }
          break;
        }
      case 'registration':
        {
          switch (data['valid']) {
            case 'true':
              {
                bool verification = true; // ????
                break;
              }
            default:
              {
                print("Registration failed");
              }
          }
          break;
        }
      case 'listWidget':
        {
          if (!data['list']!.isEmpty) {
            appData.setUserPresentName(data["list"]);
            widgetListIsReload = true;
          }
          break;
        }
      case 'create':
        {
          if (data['success'] == 'true') {
            print("present create => ${data['success']}");
            bool _presentCreate = true; // ????
          }
          break;
        }
      case 'SlideData':
        {
          print("data['list'] => ${data['list']}");
          // JsonParse jsonParse = JsonParse.fromJson(json.decode(data['list']));


          SlideData slideData = SlideData();
          slideData.setDataSlide(data);
          // slideData.set(JsonParse.fromJson(json.decode(data['list'])));
          // slideData.setItemsView(JsonParse.fromJson(json.decode(data['list'])));
          break;
        }
      default:
        {
          print('JSON parse error (Не найдено предусмотренное значение)');
        }
    }
  }
}
