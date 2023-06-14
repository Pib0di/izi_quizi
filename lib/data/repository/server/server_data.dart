import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/presentation/authentication/authentication_state.dart';
import 'package:izi_quizi/presentation/home_page/home_page_state.dart';
import 'package:izi_quizi/presentation/multiple_view/multiple_view_screen.dart';
import 'package:izi_quizi/presentation/multiple_view/multiple_view_state.dart';
import 'package:izi_quizi/presentation/single_view/single_view_state.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final webSocketProvider = StreamProvider<String>((ref) async* {
  final socket = SocketConnection._channel;

  socket.stream.listen((data) {
    ref.read(parseMessageProvider.notifier).parse(data);
  });
});

class SocketConnection {
  static final _channel = WebSocketChannel.connect(
    Uri.parse('ws://45.91.8.210:80'),
    // Uri.parse('ws://127.0.0.1:80'),
  );

  static void sendMessage(data) {
    // Timer? timer;
    // timer = Timer.periodic(const Duration(seconds: 5), (_) {
    // });
    _channel.sink.add(data);
  }

  static WebSocketChannel getConnection() {
    return _channel;
  }
}

//- - - - - - - - - - - - - - - - - - - - MultipleView - - - - - - - - - - - - - - - - -
void createRoom(String idUser, String idPresent) {
  Map<String, dynamic> json() => {
        'request_to': 'multipleView',
        'action': 'createRoom',
        'idUser': idUser,
        'idPresent': idPresent,
      };
  SocketConnection.sendMessage(jsonEncode(json()));
}

void joinRoom(String userName, String idRoom) {
  Map<String, dynamic> json() => {
        'request_to': 'multipleView',
        'action': 'joinRoom',
        'userName': userName,
        'idRoom': idRoom,
      };
  SocketConnection.sendMessage(jsonEncode(json()));
}

void getUserRoom(String userName, String idRoom) {
  Map<String, dynamic> json() => {
        'request_to': 'multipleView',
        'action': 'getUserRoom',
        'userName': userName,
        'idRoom': idRoom,
      };
  SocketConnection.sendMessage(jsonEncode(json()));
}

void removeUser(String idUserInRoom, String idRoom) {
  Map<String, dynamic> json() => {
        'request_to': 'multipleView',
        'action': 'removeUser',
        'idUserInRoom': idUserInRoom,
        'idRoom': idRoom,
      };
  SocketConnection.sendMessage(jsonEncode(json()));
}

void presentationManagement(String command, String idRoom) {
  Map<String, dynamic> json() => {
        'request_to': 'multipleView',
        'action': 'presentationManagement',
        'command': command,
        'idRoom': idRoom,
      };
  SocketConnection.sendMessage(jsonEncode(json()));
}

void presentationQuizRequest(
    String idRoom, int numSlide, String typeSlide, String data) {
  Map<String, dynamic> json() => {
        'request_to': 'multipleView',
        'action': 'presentationQuizRequest',
        'idRoom': idRoom,
        'numSlide': numSlide,
        'typeSlide': typeSlide,
        'data': data,
      };
  SocketConnection.sendMessage(jsonEncode(json()));
}

//- - - - - - - - - - - - - - - - - - - - BD - - - - - - - - - - - - - - - - -
void setPresentation(
  int idPresent,
  String idUser,
  String presentName,
  String jsonSlide,
) {
  Map<String, dynamic> json() => {
        'request_to': 'bd',
        'action': 'setSlideData',
        'idPresent': idPresent,
        'idUser': idUser,
        'presentName': presentName,
        'slideData': jsonSlide,
      };
  SocketConnection.sendMessage(jsonEncode(json()));
}

void getPresentation(int idPresent) {
  Map<String, dynamic> json() => {
        'request_to': 'bd',
        'action': 'getSlideData',
        'idPresent': idPresent,
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
          ref.read(slideDataProvider.notifier)
            ..clear()
            ..setSlidesSingleView();
          break;
        }
      case 'multipleView':
        {
          final idRoom = data['idRoom'];
          final presentName = data['presentName'];
          final idUserInRoom = data['idUser'];
          final appDataController = ref.read(appDataProvider.notifier);
          appDataController.idUserInRoom = idUserInRoom;

          print("multipleView create!!! $idRoom, $presentName");
          break;
        }
      case 'joinRoom':
        {
          final homePageController = ref.read(homePageProvider.notifier);
          final result = data['result'];
          final idUserInRoom = data['idUser'];
          final idRoom = data['idRoom'].toString();
          final appDataController = ref.read(appDataProvider.notifier);
          if (result == 'successful') {
            final idPresent = int.parse(idRoom.split('-')[1]);
            getPresentation(idPresent);
            appDataController.idUserInRoom = idUserInRoom;
            unawaited(
              Navigator.push(
                homePageController.context!,
                MaterialPageRoute(
                  builder: (context) => const MultipleView(),
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(homePageController.context!).showSnackBar(
              const SnackBar(content: Text('Такой конмнаты на существует!')),
            );
          }
          break;
        }
      case 'messageReceived':
        {
          final senderId = data['senderId'].toString();
          final message = data['message'].toString();
          final singleViewController = ref.read(singleViewProvider.notifier);

          final comand = message.split('-');
          if (comand.isNotEmpty &&
              comand[0] == 'set' &&
              int.tryParse(comand[1]) != null) {
            presentationQuizReport.forEach((key, value) {
              value.dataList.clear();
              value.numSlideList.clear();
            });
            singleViewController.set(int.tryParse(comand[1])!);
            ref.read(multipleViewProvider.notifier).isHideMenu = true;
            ref.read(multipleViewProvider.notifier).updateUi();
          } else if (message == 'start') {
            ref.read(multipleViewProvider.notifier).isHideMenu = true;
            ref.read(multipleViewProvider.notifier).updateUi();
          } else if (message == 'stop') {
            ref.read(multipleViewProvider.notifier).isHideMenu = false;
            ref.read(multipleViewProvider.notifier).updateUi();
          }

          break;
        }
      case 'getUser':
        {
          print('getUser => ${data['listUser']}');
          ref.read(multipleViewProvider.notifier).setUserList(data['listUser']);
          ref.read(multipleViewProvider.notifier).updateUi();
          break;
        }
      case 'removeUser':
        {
          final singleViewController = ref.read(singleViewProvider.notifier);
          await showDialog<String>(
            context: singleViewController.context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Вы были исключены из викторины'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('ОК'),
                ),
              ],
            ),
          );
          Navigator.pop(singleViewController.context);
          // Navigator.pop(singleViewController.context);
          print('removeUser???');
          break;
        }
      case 'disposeRoom':
        {
          final singleViewController = ref.read(singleViewProvider.notifier);
          await showDialog<String>(
            context: singleViewController.context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Организатор покинул комнату'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('ОК'),
                ),
              ],
            ),
          );
          Navigator.pop(singleViewController.context);
          print('disposeRoom???');
          break;
        }
      case 'presentationQuizRequest':
        {
          // presentationQuizReport.clear();
          // presentationQuizReport.dataList.clear();
          final idUser = data['idUser'].toString();
          final numSlide = data['numSlide'].toString();
          final typeSlide = data['typeSlide'].toString();
          final dataQuiz = data['data'].toString();

          if (presentationQuizReport.containsKey(idUser)) {
            presentationQuizReport[idUser]!.numSlideList.add(numSlide);
            presentationQuizReport[idUser]!.typeSlideList.add(typeSlide);
            presentationQuizReport[idUser]!.dataList.add(dataQuiz);
          } else {
            presentationQuizReport.addAll({
              idUser: Report(
                numSlide,
                typeSlide,
                dataQuiz,
              ),
            });
          }
          ref.read(multipleViewProvider.notifier).updateUi();
          break;
        }
      default:
        {}
    }
  }
}

Map<String, Report> presentationQuizReport = {};

class Report {
  Report(
    String numSlide,
    String typeSlide,
    String data,
  ) {
    numSlideList.add(numSlide);
    typeSlideList.add(typeSlide);
    dataList.add(data);
  }

  final numSlideList = <String>[];
  final typeSlideList = <String>[];
  final dataList = <String>[];
}
