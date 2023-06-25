// ignore_for_file: avoid_dynamic_calls

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/presentation/home_page/authentication/authentication_state.dart';
import 'package:izi_quizi/presentation/home_page/home_page_state.dart';
import 'package:izi_quizi/presentation/multiple_view/multiple_view_screen.dart';
import 'package:izi_quizi/presentation/multiple_view/multiple_view_state.dart';
import 'package:izi_quizi/presentation/single_view/single_view_state.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final webSocketProvider = StreamProvider<String>((ref) async* {
  ref.onDispose(() {});
  SocketConnection.websocket().listen(
        (data) {
      ref.read(parseMessageProvider.notifier).parse(data);
    },
    onError: (error) {},
    onDone: SocketConnection.reconnect,
  );

  // final socket = SocketConnection.channel.stream.listen(
  //   (data) {
  //     ref.read(parseMessageProvider.notifier).parse(data);
  //   },
  //   onError: (error) {
  //     print('Ошибка приема сообщения: $error');
  //   },
  //   onDone: () {
  //     print('Соединение закрыто');
  //     SocketConnection.reconnect();
  //   },
  // );
});

class WebSocket {
  late StreamController<String> _streamController = StreamController<String>();

  Stream<String> get stream => _streamController.stream;

  // Метод для перезапуска потока
  void restartStream() {
    // Закройте предыдущий поток
    _streamController.close();

    // Создайте новый поток
    _streamController = StreamController<String>();
  }

  // Метод для отправки данных по потоку
  void sendToStream(String data) {
    _streamController.sink.add(data);
  }

  // Метод для закрытия потока
  void closeStream() {
    _streamController.close();
  }
}

final container = ProviderContainer();
final webSocket = container.read(webSocketProvider);

class SocketConnection {
  static var channel = WebSocketChannel.connect(
    Uri.parse('ws://45.91.8.210:80'),
    // Uri.parse('ws://127.0.0.1:80'), //local
  );

  static void reconnect() {
    if (channel.closeCode == null) {
      // channel.sink.close();
    }
    channel = WebSocketChannel.connect(
      Uri.parse('ws://45.91.8.210:80'),
      // Uri.parse('ws://127.0.0.1:80'), //local
    );
  }

  static void sendMessage(data) {
    if (channel.closeCode == null) {
      // reconnect();
    } else {
      reconnect();
    }
    channel.sink.add(data);
  }

  static WebSocketChannel getConnection() {
    return channel;
  }

  static Stream websocket() {
    return SocketConnection.channel.stream;
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
  String idRoom,
  int numSlide,
  String typeSlide,
  String data,
) {
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
void setPresentation(String idPresent,
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

void getPresentation(String idPresent) {
  Map<String, dynamic> json() => {
    'request_to': 'bd',
    'action': 'getSlideData',
    'idPresent': idPresent,
  };
  SocketConnection.sendMessage(jsonEncode(json()));
}

void deletePresent(String email, String idDeletedPresent) {
  Map<String, dynamic> json() => {
    'request_to': 'bd',
    'action': 'deletePresentation',
    'email': email,
    'idDeletedPresent': idDeletedPresent,
  };
  // var jsonRequest = jsonEncode(json());
  SocketConnection.sendMessage(jsonEncode(json()));
  // Map<String, dynamic> users = jsonDecode(json);
}

void createPresent(String idUser, String namePresent, bool isPublic) {
  Map<String, dynamic> json() => {
    'request_to': 'bd',
    'action': 'create',
    'email': idUser,
    'isPublic': isPublic,
    'namePresent': namePresent,
  };
  // var jsonRequest = jsonEncode(json());
  SocketConnection.sendMessage(jsonEncode(json()));
}

void renamePresent(String idPresent, String newName) {
  Map<String, dynamic> json() => {
    'request_to': 'bd',
    'action': 'rename',
    'newName': newName,
    'idPresent': idPresent,
  };
  SocketConnection.sendMessage(jsonEncode(json()));
}

Future<void> getUserListPresentation(String idUser) async {
  Map<String, dynamic> json() => {
    'request_to': 'bd',
    'action': 'presentList',
    'idUser': idUser,
  };
  SocketConnection.sendMessage(jsonEncode(json()));
}

Future<void> getPublicListPresentation() async {
  Map<String, dynamic> json() => {
        'request_to': 'bd',
        'action': 'publicPresentList',
      };
  SocketConnection.sendMessage(jsonEncode(json()));
}

Future<void> getPublicListImagePresentation(
  Map<String, dynamic> imageName,
) async {
  Map<String, dynamic> json() => {
        'request_to': 'bd',
        'action': 'imageRequest',
        'imageName': imageName,
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

void uploadImage(Uint8List imageBytes, String idPresent) {
  Map<String, dynamic> json() => {
        'request_to': 'bd',
        'action': 'uploadImage',
        'imageBytes': imageBytes,
        'idPresent': idPresent,
      };
  SocketConnection.sendMessage(jsonEncode(json()));
}

final parseMessageProvider = StateNotifierProvider<ParseMessage, int>((ref) {
  return ParseMessage(ref);
});

class ParseMessage extends StateNotifier<int> {
  ParseMessage(this.ref) : super(0);

  final Ref ref;

  Future<void> parse(jsonData) async {
    final data = Map<String, dynamic>.from(json.decode(jsonData));
    switch (data['obj']) {
      case 'auth':
        {
          switch (data['valid']) {
            case 'true':
              {
                final appDataController = ref.read(appDataProvider.notifier);
                ref
                    .read(authenticationProvider.notifier)
                    .authorized(data['idUser']);
                ref.read(homePageProvider.notifier).updateUi();
                appDataController
                  ..idUser = data['idUser'].toString()
                  ..isAuthorized = true;

                await getUserListPresentation(appDataController.idUser);
                break;
              }
            default:
              {
                ref.read(authenticationProvider.notifier).notAuthorized();
              }
          }
          break;
        }
      case 'registration':
        {
          final valid = data['valid'];
          if (valid == 'success') {
            ScaffoldMessenger.of(ref.read(homePageProvider.notifier).context!)
                .showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
                content: Center(
                  child: Text(
                    'Регистрация прошла успешно',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          } else if (valid == 'error') {
            ref.read(authenticationProvider.notifier).registrationError = true;
            ref.read(authenticationProvider.notifier).update();
            ScaffoldMessenger.of(ref.read(homePageProvider.notifier).context!)
                .showSnackBar(
              SnackBar(
                backgroundColor: Colors.red.shade100,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 1, milliseconds: 500),
                content: Center(
                  child: Text(
                    'Ошибка регистрации нового пользователя',
                    style: TextStyle(
                      color: Colors.redAccent.withAlpha(90),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }
          break;
        }
      case 'presentList':
        {
          final Map<String, dynamic> list = data['list'];
          if (list.isNotEmpty) {
            ref.read(homePageProvider.notifier)
              ..currentPosition = 0
              ..userPresentations.clear()
              ..setUserPresentName(data['list'])
              ..updateUi();
          }
          break;
        }
      case 'publicPresentList':
        {
          final Map<String, dynamic> list = data['list'];
          if (list.isNotEmpty) {
            ref.read(homePageProvider.notifier)
              ..publicPresentName.clear()
              ..setPublicPresentName(data['list'])
              ..updateUi();
          }
          break;
        }
      case 'imageRequest':
        {
          final idPresentList = data['idPresentList'].cast<String>();
          final List<dynamic> uint8List = data['uint8List'];

          final finalUint8List = <Uint8List>[];
          for (var element in uint8List) {
            final imageBytes = Uint8List.fromList(element.cast<int>());
            finalUint8List.add(imageBytes);
          }
          final uint8Lists = finalUint8List.cast<Uint8List>();

          if (idPresentList.isNotEmpty && uint8List.isNotEmpty) {
            ref.read(homePageProvider.notifier)
              ..setPublicPresentNameImage(idPresentList, uint8Lists)
              ..updateUi();
          }
          break;
        }
      case 'renamePresent':
        {
          final result = data['result'].toString();
          if (result == 'renameSuccess') {
            ScaffoldMessenger.of(ref.read(homePageProvider.notifier).context!)
                .showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
                content: Center(
                  child: Text(
                    'Перзентация успешно переименована',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }
          final appDataController = ref.read(appDataProvider.notifier);
          await getUserListPresentation(appDataController.idUser);
          break;
        }
      case 'deletePresentation':
        {
          final String result = data['result'];

          if (result.isNotEmpty && result == 'successful') {
            unawaited(getPublicListPresentation());
            ScaffoldMessenger.of(ref.read(homePageProvider.notifier).context!)
                .showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
                content: Center(
                  child: Text(
                    'Перзентация успешно удалена',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }
          final appDataController = ref.read(appDataProvider.notifier);
          await getUserListPresentation(appDataController.idUser);
          break;
        }
      case 'create':
        {
          if (data['success'] == 'true') {
            final homePageController = ref.read(homePageProvider.notifier);
            final appDataController = ref.read(appDataProvider.notifier)
              ..idPresent = data['idPresent'];
            unawaited(getUserListPresentation(appDataController.idUser));
            unawaited(getPublicListPresentation());
            ScaffoldMessenger.of(homePageController.context!).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
                content: Center(
                  child: Text(
                    'Перзентация создана',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }
          break;
        }
      case 'SlideData':
        {
          ref.read(slideDataProvider.notifier).setDataSlide(data);
          ref.read(slideDataProvider.notifier)
            ..clearPresentation()
            ..setSlidesSingleView();
          break;
        }
      case 'multipleView':
        {
          final idUserInRoom = data['idUser'];
          ref.read(appDataProvider.notifier).idUserInRoom = idUserInRoom;

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
            final idPresent = idRoom.split('-')[1];
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
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
                content: Center(
                  child: Text(
                    'Такой конмнаты на существует!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }
          break;
        }
      case 'messageReceived':
        {
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
          ref.read(multipleViewProvider.notifier).setUserList(data['listUser']);
          ref.read(multipleViewProvider.notifier).updateUi();
          break;
        }
      case 'removeUser':
        {
          final singleViewController = ref.read(singleViewProvider.notifier);
          unawaited(
            showDialog<String>(
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
            ),
          );
          Navigator.pop(singleViewController.context);
          // Navigator.pop(singleViewController.context);
          break;
        }
      case 'disposeRoom':
        {
          print('disposeRoom');
          final singleViewController = ref.read(singleViewProvider.notifier);
          unawaited(
            showDialog<String>(
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
            ),
          );
          Navigator.pop(singleViewController.context);
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
  Report(String numSlide,
      String typeSlide,
      String data,) {
    numSlideList.add(numSlide);
    typeSlideList.add(typeSlide);
    dataList.add(data);
  }

  final numSlideList = <String>[];
  final typeSlideList = <String>[];
  final dataList = <String>[];
}
