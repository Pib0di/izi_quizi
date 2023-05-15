import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/main.dart';
import 'package:izi_quizi/presentation/authentication/authentication_state.dart';
import 'package:izi_quizi/presentation/home_page/home_page_state.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final webSocketProvider = StreamProvider<String>((ref) async* {
  final socket = SocketConnection._channel;

  socket.stream.listen((data) {
    ref.read(parseMessageProvider.notifier).parse(data);
  });

  // final webSocket = WebSocketChannel.connect(Uri.parse(url));
  // await for (final value in webSocket.stream) {
  //   print('value.toString() => ${value.toString()}');
  //   yield value.toString();
  // }
});

class SocketConnection {
  static final _channel = WebSocketChannel.connect(
    // Uri.parse('ws://185.251.89.216:80'),
    Uri.parse('ws://localhost:5000'),
  );

  static void sendMessage(data) {
    _channel.sink.add(data);
  }

  static WebSocketChannel getConnection() {
    return _channel;
  }
}

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

Future<void> getListWidget(String idUser) async {
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

final parseMessageProvider = StateNotifierProvider<ParseMessage, int>((ref) {
  return ParseMessage(ref);
});

class ParseMessage extends StateNotifier<int> {
  ParseMessage(this.ref) : super(0);

  final Ref ref;

  Future<void> parse(jsonData) async {
    print("jsonData => $jsonData");

    final data = Map<String, dynamic>.from(json.decode(jsonData));
    switch (data['obj']) {
      case 'auth':
        {
          switch (data['valid']) {
            case 'true':
              {
                ref
                    .read(authenticationProvider.notifier)
                    .authorized(data['idUser']);
                ref.read(homePageProvider.notifier).updateUi();
                ref.read(appDataProvider.notifier).idUser = data['idUser'];
                break;
              }
            default:
              {
                ref.read(authenticationProvider.notifier).notAuthorized();

                // AppDataState()
                //   ..authentication(true)
                //   ..authentication(false);
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
            ref
                .read(homePageProvider.notifier)
                .setUserPresentName(data['list']);
            ref.read(homePageProvider.notifier).updateUi();
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
          ref.read(slideDataProvider.notifier).setDataSlide(data);
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
