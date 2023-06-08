import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mysql_client/mysql_client.dart';

SQL sql = SQL();

Future<void> main() async {
  final server = await HttpServer.bind('localhost', 5000);
  // final server = await HttpServer.bind('185.251.89.216', 85);
  print('Listening on ${server.address}:${server.port}');

  await for (var request in server) {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      print('request.method => ${request.method}');
      // request.uri.path == '/stream';
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
    // final roomId = "Uri.parse(request.uri.toString()).pathSegments.last";
    // print('roomId => $roomId');
    // final room = Room.getOrCreateRoom(roomId);
    // final user = User(webSocket);
    // room.addUser(user);

    webSocket.listen(
      (message) async {
        final answer = await redirection(message, webSocket);

        if (webSocket.readyState == WebSocket.open) {
          print("add => ${jsonEncode(answer)}");
          webSocket.add(jsonEncode(answer));
        }
        // final data = jsonDecode(message);
        // if (data is Map && data.containsKey('type') && data.containsKey('payload')) {
        //   switch (data['type']) {
        //     case 'sendMessage':
        //       room.broadcastMessage(user, data['payload']);
        //       break;
        //     default:
        //       print('Unknown message type: ${data['type']}');
        //   }
        // } else {
        //   print('Invalid message format: $message');
        // }
      },
      onDone: () {
        // room.removeUser(user);
      },
    );
  });
}

class Room {
  final String id;
  final List<User> users = [];

  Room(this.id);

  Map<dynamic, String> getListUser() {
    final listMap = <dynamic, String>{};

    for (var user in users) {
      listMap[user.id] = user.userName;
    }
    return listMap;
  }

  void addUser(User user) {
    users.add(user);
    user.send({
      'obj': 'joinRoom',
      'payload': {'roomId': id}
    });
    broadcastMessage(user, '${user.id} has joined the room');
  }

  void removeUser(User user) {
    users.remove(user);
    broadcastMessage(user, '${user.id} has left the room');
  }

  void broadcastMessage(User sender, String message) {
    for (var user in users) {
      if (user != sender) {
        user.send({
          'type': 'messageReceived',
          'payload': {'senderId': sender.id, 'message': message}
        });
      }
    }
  }

  static final Map<String, Room> rooms = {};

  static Room getOrCreateRoom(String id) {
    return rooms.putIfAbsent(id, () => Room(id));
  }
}

class User {
  final String id;
  final WebSocket webSocket;
  final String idUser;
  String userName = 'undefined user';

  User.name(this.webSocket, this.userName, this.idUser)
      : id = webSocket.hashCode.toRadixString(16);

  User(this.webSocket, this.idUser) : id = webSocket.hashCode.toRadixString(16);

  void send(data) {
    webSocket.add(jsonEncode(data));
  }
}

class PresentNameMap {
  String presentName;
  String idPresent;

  PresentNameMap(this.presentName, this.idPresent);

  @override
  String toString() {
    return '{ $presentName, $idPresent }';
  }
}

class SQL {
  late String host = 'localhost',
      user = 'root',
      password = '1234',
      db = 'iziqizi';
  int port = 3306;

  // late String host = '185.251.89.216',
  //     user = 'root',
  //     password = '1234',
  //     db = 'iziqizi';
  // int port = 85;

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
        print("result.rows.first.colAt(0) => ${result.rows.first.colAt(0)}");

        if (result.isNotEmpty) {
          if (pass.toString() == result.rows.first.colAt(1).toString()) {
            print(
                "result.rows.first.colAt(0) => ${result.rows.first.colAt(0)}");
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
      // final String? JWT = prefs.getString('JWT');   // *********SharedPreferences
      // print("JWT =  $JWT");  // *********SharedPreferences

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
        // await conn.execute("INSERT INTO `iziqizi`.`1-m` (`email`, `present`) VALUES (:email, :present);",
        //     {
        //       "email":"$email",
        //       "present": "$namePresent"
        //     }
        // );
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

  Future<String> getSlideData(int idPresent, String presentName) async {
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
        // result.rowsStream.listen((row) {
        //   list.add(row.colAt(0)!);
        // });
        for (final row in result.rows) {
          json += row.colAt(0)!;
        }
        // json = result.rows.first.toString();
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
  print("request => $jsonData");
  switch (jsonData['request_to']) {
    // Database queries
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
                jsonData['presentName'],
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
    // User queries
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
    case 'MultipleView':
      {
        switch (jsonData['action']) {
          case 'createRoom':
            {
              final String userId = jsonData['idUser'];
              final roomId = userId;

              final room = Room.getOrCreateRoom(roomId);
              final user = User(webSocket, userId);
              room.addUser(user);

              //todo finish returning the value
              // final presentName = jsonData['presentName'];
              // Map<String, dynamic> json() => {
              //       'obj': 'MultipleView',
              //       'roomId': roomId,
              //       'presentName': presentName,
              //     };
              break;
            }
          case 'joinRoom':
            {
              final String userName = jsonData['userName'];
              final String roomId = jsonData['roomId'];

              final room = Room.getOrCreateRoom(roomId);
              final user = User.name(
                webSocket,
                userName,
                webSocket.hashCode.toRadixString(16),
              );
              room.addUser(user);

              final list = room.getListUser();
              Map<String, dynamic> json() => {
                    'obj': 'listUser',
                    'list': list,
                  };
              return json();
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
