import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mysql_client/mysql_client.dart';

import 'multiple_processing.dart';

SQL sql = SQL();

Future<void> main() async {
  final server = await HttpServer.bind('127.0.0.1', 80);
  // final server = await HttpServer.bind('45.91.8.210', 80);
  print('Listening on ${server.address}:${server.port}');

  await for (var request in server) {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      print('request.method => ${request.method}');
      handleWebSocket(request);
    } else {
      request.response.statusCode = HttpStatus.badRequest;
      request.response.reasonPhrase = 'WebSocket connections only';
      await request.response.close();
    }
  }
}

void handleWebSocket(HttpRequest request) {
  WebSocketTransformer.upgrade(request).then((webSocket) async {
    webSocket.listen(
      (message) async {
        final answer = await redirection(message, webSocket);

        if (webSocket.readyState == WebSocket.open) {
          print('add => ${jsonEncode(answer)}');
          webSocket.add(jsonEncode(answer));
        }
      },
      onDone: () {
        final id = webSocket.hashCode.toRadixString(16).toString();
        for (var room in Room.rooms.values) {
          if (room.users.isNotEmpty && room.users.first.id == id) {
            room.dispose();
            break;
          } else if (room.users.isEmpty) {
            room.dispose();
          } else if (room.users.isNotEmpty) {
            room.removeUser(id);
          }
        }
        print('Room.rooms.length => ${Room.rooms.length}');
      },
    );
  });
}

class SQL {
  // late String host = 'localhost',
  //     user = 'root',
  //     password = '1234',
  //     db = 'iziqizi';
  // int port = 3306;

  late String host = '45.91.8.210',
      user = 'root',
      password = '1234',
      db = 'iziqizi';
  int port = 85;

  Future<Map<dynamic, String>> listWidget(String userId) async {
    final conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      password: password,
      databaseName: db,
    );
    await conn.connect();
    final userPresent = <dynamic, String>{};

    try {
      IResultSet result;
      if (conn.connected) {
        result = await conn.execute(
          'SELECT present.presentName, present.idPresent FROM iziqizi.present where present.userId = :userId;',
          {'userId': userId},
        );
        result.rowsStream.listen((row) {
          userPresent['${row.colAt(1)}'] = row.colAt(0)!;
        });
      }
      await Future.delayed(const Duration(milliseconds: 1500));
    } on Exception {
      // return "e.toString()";
    }
    await conn.close();
    // userPresent.forEach((k, v) => list.add(PresentNameMap(k, v)));
    // list = userPresent.values.toList();

    return userPresent;
  }

  Future<String> authentication(String? email, String? pass) async {
    final conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      password: password,
      databaseName: db,
    );
    await conn.connect();

    if (conn.connected) {
      try {
        final result = await conn.execute(
          'SELECT idUser, password FROM iziqizi.user WHERE email = :email;',
          {'email': email},
        );
        // await Future.delayed(const Duration(milliseconds: 1500));
        await conn.close();
        print('result.rows.first.colAt(0) => ${result.rows.first.colAt(0)}');

        if (result.isNotEmpty) {
          if (pass.toString() == result.rows.first.colAt(1).toString()) {
            print(
                'result.rows.first.colAt(0) => ${result.rows.first.colAt(0)}');
            return 'authorized ${result.rows.first.colAt(0)}';
          } else {
            return 'authErr';
          }
        } else {
          return 'QueryError';
        }
      } catch (err) {
        return err.toString();
      }
    }
    return 'ErrConnected';
  }

  Future<int> connection() async {
    final conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      password: password,
      databaseName: db,
    );
    await conn.connect();
    if (conn.connected) {
      // var result = await conn.execute("CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER "
      //     "VIEW `view` AS "
      //     "SELECT DISTINCT `users`.`email` AS `userPresent`, `present`.`present` AS `Present` "
      //     "FROM ((`present` JOIN `users`) JOIN `1-m`) "
      //     "WHERE (`users`.`email` = '2001andru@mail.ru')''"
      // );
      final result2 = await conn.execute('SELECT `Present` FROM `view`;');
      result2.rowsStream.listen((event) {});
      await conn.close();
      return 0;
    } else {
      return 404;
    }
  }

  Future<String> register(String email, String pass) async {
    final emailValid = RegExp(
      r"^[a-zA-Z\d.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z\d](?:[a-zA-Z\d-]{0,253}[a-zA-Z\d])?(?:\.[a-zA-Z\d](?:[a-zA-Z\d-]{0,253}[a-zA-Z\d])?)*$",
    ).hasMatch(email);

    bool isPasswordValid(String password) {
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
      if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        return false;
      }
      return true;
    }

    final passwordValid = isPasswordValid(pass);

    final conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      password: password,
      databaseName: db,
    );
    await conn.connect();

    if (conn.connected) {
      if (emailValid && passwordValid) {
        await conn.execute(
            'INSERT INTO `iziquiziusers`.`users` (`email`, `password`) '
            'VALUES (:email, :password);',
            {
              'email': email,
              'password': pass,
            });
        await conn.close();
        return 'Register';
      } else {
        return 'RegisterError';
      }
    } else {
      return 'ConnectErr';
    }
  }

  Future<String> createPresent(String? namePresent, String? email) async {
    final conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      password: password,
      databaseName: db,
    );
    await conn.connect();
    if (conn.connected) {
      try {
        await conn.execute(
          'INSERT INTO `iziqizi`.`present` (`userId`, `presentName`) VALUES (:idUser, :name);',
          {'idUser': email, 'name': '$namePresent'},
        );
        await conn.execute(
          'SELECT idPresent FROM iziqizi.present where userId = (:idUser) ;',
          {'idUser': email, 'name': '$namePresent'},
        );
        return 'success';
      } on Exception catch (e) {
        return ('CreateError => $e');
      } finally {
        await conn.close();
      }
    } else {
      return ('Create present connect error');
    }
  }

  Future<void> deletePresent(String? nameDeletePresent, String? email) async {
    final conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      password: password,
      databaseName: db,
    );
    await conn.connect();
    if (conn.connected) {
      try {
        await conn.execute(
          'DELETE FROM `iziquiziusers`.`present` WHERE (`present` = :nameDeletePresent);',
          {'nameDeletePresent': '$nameDeletePresent'},
        );
      } catch (e) {
        await conn.close();
      }

      await conn.close();
    } else {}
  }

  Future<String> presentRename(
    String? nameUpdate,
    String? newName,
    String? email,
  ) async {
    final conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      password: password,
      databaseName: db,
    );
    await conn.connect();
    if (conn.connected) {
      try {
        await conn.execute(
            'UPDATE `iziquiziusers`.`present` SET `present` = :newName WHERE (`present` = :nameUpdate);',
            {
              'newName': '$newName',
              'nameUpdate': '$nameUpdate',
            });
        return 'success';
      } catch (e) {
        return (e.toString());
      } finally {
        await conn.close();
      }
    } else {
      return 'ConnErr';
    }
  }

  Future<String> getSlideData(int idPresent) async {
    final conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      password: password,
      databaseName: db,
    );
    await conn.connect();
    var json = '';
    if (conn.connected) {
      try {
        final result = await conn.execute(
            'SELECT present.slides_data FROM iziqizi.present where present.idPresent = :idPresent;',
            {
              'idPresent': idPresent,
            });
        for (final row in result.rows) {
          json += row.colAt(0)!;
        }
      } finally {
        await conn.close();
      }
      await Future.delayed(const Duration(milliseconds: 500));
      return json;
    } else {
      return 'Connected 404';
    }
  }

  Future<void> setSlideData(
    int idPresent,
    String idUser,
    String presentName,
    String jsonSlide,
  ) async {
    final conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      password: password,
      databaseName: db,
    );
    await conn.connect();
    if (conn.connected) {
      try {
        await conn.execute(
            'UPDATE `iziqizi`.`present` SET `slides_data` = (:jsonSlide) WHERE (`idPresent` = :idPresent) and (`userId` = :idUser) and (`presentName` = :presentName);',
            {
              'idPresent': idPresent,
              'idUser': idUser,
              'presentName': presentName,
              'jsonSlide': jsonSlide,
            });
      } finally {
        await conn.close();
      }
    } else {}
  }
}

Future<Map<String, dynamic>> redirection(data, WebSocket webSocket) async {
  final jsonData = Map<String, dynamic>.from(json.decode(data));
  print('request => $jsonData');
  switch (jsonData['request_to']) {
    // *********************** Database queries *************************
    case 'bd':
      {
        switch (jsonData['action']) {
          case 'create':
            {
              final res = await sql.createPresent(
                jsonData['namePresent'],
                jsonData['email'],
              );
              if (res.toString() == 'success') {
                return {
                  'obj': 'create',
                  'success': 'true',
                };
              } else {
                return {
                  'obj': 'create',
                  'success': 'false',
                };
              }
            }
          case 'rename':
            {
              await sql.presentRename(
                jsonData['nameUpdate'],
                jsonData['newName'],
                jsonData['email'],
              );
              break;
            }
          case 'delete':
            {
              await sql.deletePresent(
                jsonData['nameDeletePresent'],
                jsonData['email'],
              );
              break;
            }
          case 'presentList':
            {
              final list = await sql.listWidget(jsonData['idUser']);
              Map<String, dynamic> json() => {
                    'obj': 'listWidget',
                    'list': list,
                  };
              return json();
            }
          case 'setSlideData':
            {
              await sql.setSlideData(
                jsonData['idPresent'],
                jsonData['idUser'],
                jsonData['presentName'],
                jsonData['slideData'],
              );
              break;
            }
          case 'getSlideData':
            {
              final list = await sql.getSlideData(
                jsonData['idPresent'],
              );
              Map<String, dynamic> json() => {
                    'obj': 'SlideData',
                    'list': list,
                  };
              return json();
            }
          default:
            {}
        }
        break;
      }
  // *********************** User queries *************************
    case 'user':
      {
        switch (jsonData['action']) {
          case 'auth':
            {
              final auth =
                  await sql.authentication(jsonData['email'], jsonData['pass']);
              final lst = auth.split(' ');
              if (lst[0] == 'authorized') {
                Map<String, dynamic> json() => {
                      'obj': 'auth',
                      'valid': 'true',
                      'idUser': lst[1],
                    };
                return json();
              } else {
                return {
                  'obj': 'auth',
                  'valid': 'false',
                };
              }
            }
          case 'register':
            {
              await sql.deletePresent(
                jsonData['nameDeletePresent'],
                jsonData['email'],
              );
              break;
            }
          default:
            {}
        }
        break;
      }

    // *********************** Multiple queries *************************
    case 'multipleView':
      {
        switch (jsonData['action']) {
          case 'createRoom':
            {
              final String idUser = jsonData['idUser'];
              final String idPresent = jsonData['idPresent'];
              final idRoom = '$idUser-$idPresent';

              final room = Room.getOrCreateRoom(idRoom);
              final user = User.name(webSocket, idUser, idUser);
              room.addUser(user);

              final presentName = jsonData['presentName'].toString();
              Map<String, dynamic> json() => {
                    'obj': 'multipleView',
                    'idUser': user.id,
                    'idRoom': idRoom,
                    'presentName': presentName,
                  };
              // webSocket.listen((event) { }).onDone(() {
              //   room.removeUser(idUser);
              // });
              return json();
              break;
            }
          case 'joinRoom':
            {
              final String userName = jsonData['userName'];
              final String idRoom = jsonData['idRoom'];

              Map<String, dynamic> json;
              if (Room.rooms.containsKey(idRoom) == true) {
                json = {
                  'obj': 'joinRoom',
                  'result': 'successful',
                  'idRoom': idRoom,
                  'idUser': webSocket.hashCode.toRadixString(16).toString(),
                };

                final room = Room.getOrCreateRoom(idRoom);
                final user = User.name(
                  webSocket,
                  userName,
                  webSocket.hashCode.toRadixString(16),
                );
                room.addUser(user);
                final list = room.getListUser();
                room.sendUserList(
                  list,
                );
              } else {
                json = {
                  'obj': 'joinRoom',
                  'result': 'error',
                };
              }
              return json;
              break;
            }
          case 'getUserRoom':
            {
              final String userName = jsonData['userName'];
              final String idRoom = jsonData['idRoom'];
              if (Room.rooms.containsKey(idRoom) == true) {
                final room = Room.getOrCreateRoom(idRoom);
                final list = room.getListUser();
                room.sendUserList(
                  list,
                );
              }
              break;
            }
          case 'removeUser':
            {
              final String idUserInRoom = jsonData['idUserInRoom'];
              final String idRoom = jsonData['idRoom'];
              if (Room.rooms.containsKey(idRoom) == true) {
                final room = Room.getOrCreateRoom(idRoom);
                room.removeUser(idUserInRoom);
                final list = room.getListUser();
                room.sendUserList(
                  list,
                );
              }
              break;
            }
          case 'presentationManagement':
            {
              final String command = jsonData['command'];
              final String idRoom = jsonData['idRoom'];
              final User? user;

              if (Room.rooms.containsKey(idRoom) == true) {
                final room = Room.getOrCreateRoom(idRoom);
                user = room.getUser(webSocket.hashCode.toRadixString(16));
                if (user != null) {
                  room.broadcastMessage(user, command);
                }
              }
              break;
            }
          case 'presentationQuizRequest':
            {
              final String idRoom = jsonData['idRoom'];
              final int numSlide = jsonData['numSlide'];
              final String typeSlide = jsonData['typeSlide'];
              final String data = jsonData['data'];

              final User? user;

              if (Room.rooms.containsKey(idRoom) == true) {
                final room = Room.getOrCreateRoom(idRoom);
                user = room.getUser(webSocket.hashCode.toRadixString(16));
                if (user != null) {
                  final report = Report(
                    numSlide,
                    typeSlide,
                    data,
                  );
                  var isFound = false;
                  for (var element in user.report) {
                    if ((element.numSlide ?? -1) == numSlide) {
                      isFound = true;
                      element = report;
                      break;
                    }
                  }
                  if (!isFound) {
                    user.report.add(report);
                  }

                  final hostUser = room.users.first;
                  // final userId = <String>[];
                  // final numSlideList = <String>[];
                  // final typeSlideList = <String>[];
                  // final dataList = <String>[];
                  hostUser.send({
                    'obj': 'presentationQuizRequest',
                    'idUser': user.id,
                    'numSlide': report.numSlide.toString(),
                    'typeSlide': report.typeSlide ?? '',
                    'data': report.data ?? '',
                  });
                  for (var user in room.users) {
                    for (var report in user.report) {
                      // userId.add(user.id);
                      // numSlideList.add(report.numSlide.toString());
                      // typeSlideList.add(report.typeSlide ?? '');
                      // dataList.add(report.data ?? '');
                    }
                    // print ('dataList => $dataList');
                  }
                  // hostUser.send({
                  //   'obj': 'presentationQuizRequest',
                  //   'idUser': userId,
                  //   'numSlide': numSlideList,
                  //   'typeSlide': typeSlideList,
                  //   'data': dataList,
                  // });

                  // room.broadcastMessage(user, command);
                }
              }
              break;
            }
          default:
            {}
        }
        break;
      }
    default:
      {}
  }
  return {
    'obj': 'err',
  };
}
