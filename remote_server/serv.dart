import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mysql_client/mysql_client.dart';

// import 'package:path_provider/path_provider.dart';

import 'multiple_processing.dart';

SQL sql = SQL();

Future<void> main() async {
  // final server = await HttpServer.bind('127.0.0.1', 80);
  final server = await HttpServer.bind('172.17.0.3', 80); //СЕРВЕР

  await for (var request in server) {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
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
      },
    );
  });
}

String generateUniqueFileName(String extension) {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final random = DateTime.now().microsecondsSinceEpoch % 10000;
  final uniqueName = '$timestamp$random';
  final fileName = '$uniqueName.$extension';
  return fileName;
}

class SQL {
  //local
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

  Future<Map<dynamic, String>> publicPresentList() async {
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
      IResultSet imageName;
      if (conn.connected) {
        result = await conn.execute(
          'SELECT present.presentName, present.idPresent, present.image_name FROM iziqizi.present where present.public = \'true\';',
        );
        result.rowsStream.listen((row) {
          userPresent['${row.colAt(1)}'] = '${row.colAt(0)!}&${row.colAt(2)!}';
        });
      }
      await Future.delayed(const Duration(milliseconds: 1500));
    } on Exception {
      // return "e.toString()";
    }
    await conn.close();

    return userPresent;
  }

  Future<Map<dynamic, String>> userPresentList(String userId) async {
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
          'SELECT present.presentName, present.idPresent, present.image_name FROM iziqizi.present where present.userId = :userId;',
          {'userId': userId},
        );
        result.rowsStream.listen((row) {
          userPresent['${row.colAt(1)}'] = '${row.colAt(0)!}&${row.colAt(2)!}';
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

        if (result.isNotEmpty) {
          if (pass.toString() == result.rows.first.colAt(1).toString()) {
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
          'SELECT user.email FROM iziqizi.user where user.email = (:email) and user.password = (:pass);',
          {'email': email, 'pass': pass},
        );
        for (final row in result.rows) {
          // if (row.colAt(0) != null){
          //   json += row.colAt(0)!;
          // }
        }
        if (result.rows.isEmpty ||
            result.rows.first
                    .colAt(0)
                    .toString()
                    .toLowerCase()
                    .compareTo(email.toLowerCase()) !=
                0) {
          await conn.execute(
              'INSERT INTO `iziqizi`.`user` (`email`, `password`) '
              'VALUES (:email, :password);',
              {
                'email': email,
                'password': pass,
              });
        } else {
          return 'error';
        }

        return 'success';
      } on Exception catch (e) {
        return ('CreateError => $e');
      } finally {
        await conn.close();
      }
    } else {
      return 'ConnectErr';
    }
  }

  Future<String> createPresent(
    String? namePresent,
    String? email,
    bool isPublic,
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
          'INSERT INTO `iziqizi`.`present` (`userId`, `presentName`, `public`) VALUES (:idUser, :name, :isPublic);',
          {'idUser': email, 'name': '$namePresent', 'isPublic': '$isPublic'},
        );
        final result = await conn.execute(
          'SELECT idPresent FROM iziqizi.present where userId = (:idUser) ;',
          {'idUser': email, 'name': '$namePresent'},
        );
        final json = result.rows.last.colAt(0).toString();
        await Future.delayed(const Duration(milliseconds: 500));
        return 'success-$json';
      } on Exception catch (e) {
        return ('CreateError => $e');
      } finally {
        await conn.close();
      }
    } else {
      return ('Create present connect error');
    }
  }

  Future<String> deletePresent(String? nameDeletePresent, String? email) async {
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
          'DELETE FROM `iziqizi`.`present` WHERE (`idPresent` = :nameDeletePresent);',
          {'nameDeletePresent': nameDeletePresent ?? ''},
        );
        await conn.close();
        return 'successful';
      } catch (e) {
        await conn.close();
      }
    } else {}
    return 'error';
  }

  Future<String> presentRename(
    String? newName,
    String? idPresent,
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
        final result = await conn.execute(
            'UPDATE `iziqizi`.`present` SET `presentName` = :newName WHERE (`idPresent` = :idPresent);',
            // 'UPDATE `iziquiziusers`.`present` SET `present` = :newName WHERE (`present` = :nameUpdate);',
            {
              'newName': newName,
              'idPresent': idPresent,
            });
        return 'renameSuccess';
      } catch (e) {
        return (e.toString());
      } finally {
        await conn.close();
      }
    } else {
      return 'ConnErr';
    }
  }

  Future<String> getSlideData(String idPresent) async {
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
          if (row.colAt(0) != null) {
            json += row.colAt(0)!;
          }
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
    String idPresent,
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
            // 'UPDATE `iziqizi`.`present` SET `slides_data` = :jsonSlide WHERE `userId` = :idUser and `presentName` = :presentName;',
            'UPDATE `iziqizi`.`present` SET `slides_data` = :jsonSlide WHERE (`userId` = :idUser) and (`presentName` = :presentName);',
            {
              // 'idPresent': idPresent,
              'jsonSlide': jsonSlide,
              'idUser': idUser,
              'presentName': presentName,
            });
      } finally {
        await conn.close();
      }
    } else {}
  }

  Future<String> addPreview(String imageName, String idPresent) async {
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
        print('idPresent => $idPresent');
        await conn.execute(
          'UPDATE `iziqizi`.`present` SET `image_name` = :imageName WHERE (`idPresent` = :idPresent);',
          {
            'imageName': imageName,
            'idPresent': idPresent,
          },
        );

        return 'success';
      } on Exception catch (e) {
        return ('error');
      } finally {
        await conn.close();
      }
    } else {
      return ('Create present connect error');
    }
  }
}

Future<Map<String, dynamic>> redirection(data, WebSocket webSocket) async {
  final jsonData = Map<String, dynamic>.from(json.decode(data));
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
                jsonData['isPublic'],
              );
              final result = res.split('-');
              if (result[0] == 'success') {
                return {
                  'obj': 'create',
                  'success': 'true',
                  'idPresent': result[1],
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
              final result = await sql.presentRename(
                jsonData['newName'],
                jsonData['idPresent'],
              );
              return {
                'obj': 'renamePresent',
                'result': result,
              };
            }
          case 'deletePresentation':
            {
              final result = await sql.deletePresent(
                jsonData['idDeletedPresent'],
                jsonData['email'],
              );
              return {
                'obj': 'deletePresentation',
                'result': result,
              };
            }
          case 'uploadImage':
            {
              final imageBytes =
                  Uint8List.fromList(jsonData['imageBytes'].cast<int>());
              final uniqueFileName = generateUniqueFileName('jpg');
              await sql.addPreview(uniqueFileName, jsonData['idPresent']);

              void saveFileLocally(Uint8List imageBytes) async {
                final directory = Directory('/var/lib/docker/volumes');

                final filePath = '${directory.path}/$uniqueFileName';

                if (!directory.existsSync()) {
                  directory.createSync(recursive: true);
                }
                final file = File(filePath);
                await file.writeAsBytes(imageBytes);
                print('Файл успешно сохранен по пути: $filePath');
              }

              saveFileLocally(imageBytes);
              return {
                'obj': 'uploadImage',
                'result': 'fileBytes',
              };
            }
          case 'presentList': //user present list
            {
              final list = await sql.userPresentList(jsonData['idUser']);
              Map<String, dynamic> json() => {
                    'obj': 'presentList',
                    'list': list,
                  };
              return json();
            }
          case 'publicPresentList':
            {
              final list = await sql.publicPresentList();
              Map<String, dynamic> json() => {
                    'obj': 'publicPresentList',
                    'list': list,
                  };
              return json();
            }
          case 'imageRequest':
            {
              final Map<String, dynamic> imageNameList = jsonData['imageName'];

              final directory = Directory('/var/lib/docker/volumes');
              final uint8List = <Uint8List>[];
              final idPresentList = <String>[];

              Future<void> imageName(
                List<Uint8List> uint8List,
                List<String> idPresentList,
              ) async {
                imageNameList.forEach((key, value) async {
                  final filePath = '${directory.path}/$value';
                  final file = File(filePath);
                  if (!file.existsSync()) {
                    print('Файл не найден: $filePath, file => ${file}');
                    uint8List.add(Uint8List(0));
                  } else {
                    final fileBytes = await file.readAsBytes();
                    uint8List.add(fileBytes);
                    print('Файл успешно отправлен по пути: $fileBytes');
                  }
                  idPresentList.add(key);
                });
              }

              await imageName(uint8List, idPresentList);

              await Future.delayed(const Duration(milliseconds: 1500));

              Map<String, dynamic> json() => {
                    'obj': 'imageRequest',
                    'idPresentList': idPresentList,
                    'uint8List': uint8List,
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
              if (jsonData['idPresent'] != null) {
                final list = await sql.getSlideData(
                  jsonData['idPresent'],
                );
                Map<String, dynamic> json() => {
                      'obj': 'SlideData',
                      'list': list,
                    };
                return json();
              }
              break;
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
              final email = jsonData['email'].toString();
              final pass = jsonData['pass'];
              final result = await sql.register(email, pass);
              if (result == 'success') {
                return {
                  'obj': 'registration',
                  'valid': 'success',
                };
              } else {
                return {
                  'obj': 'registration',
                  'valid': 'error',
                };
              }
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
              return json();
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
                final room = Room.getOrCreateRoom(idRoom)
                  ..removeUser(idUserInRoom);
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

                  room.users.first.send({
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
