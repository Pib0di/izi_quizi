import 'dart:io' show HttpServer, HttpRequest, WebSocket, WebSocketTransformer;
import 'dart:convert' show json;
import 'dart:convert';
// import 'package:mysql1/mysql1.dart';

import 'dart:async';
import 'dart:io';
import 'package:mysql_client/mysql_client.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

// import 'package:shared_preferences/shared_preferences.dart';
// void handleWebSocket(Socket socket) {
//   WebSocket webSocket;
//   try {
//     webSocket = WebSocket.fromUpgradedSocket(socket, serverSide: true);
//
//     final roomId = Uri.parse(webSocket.request.uri.toString()).pathSegments.last;
//     final room = Room.getOrCreateRoom(roomId);
//     room.addWebSocket(webSocket);
//   } catch (e) {
//     print('Error: $e');
//     if (webSocket != null && webSocket.closeCode == null) {
//       webSocket.close();
//     }
//   }
// }
SQL sql = SQL();
Future<void> main() async {
  final server = await HttpServer.bind('localhost', 8000);
  print('Listening on ${server.address}:${server.port}');

  await for (var request in server) {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      handleWebSocket(request);
    } else {
      request.response.statusCode = HttpStatus.badRequest;
      request.response.reasonPhrase = 'WebSocket connections only';
      request.response.close();
    }
  }



  // HttpServer.bind('localhost', 8000).then((HttpServer server) {
  //   print('[+]WebSocket listening at -- ws://localhost:8000/');
  //   server.listen((HttpRequest request) {
  //     WebSocketTransformer.upgrade(request).then((WebSocket ws) {
  //       Map<String, WebSocket> connections = new Map<String, WebSocket>();
  //       connections.putIfAbsent("connectionName", () => ws);
  //       // print('roomId =>>>>> ${roomId}');
  //
  //       ws.listen(
  //         (data) async {
  //           print(data);
  //           var answer = await redirection(data);
  //           if (ws.readyState == WebSocket.open) {
  //             ws.add(jsonEncode(answer));
  //           }
  //         },
  //         onDone: () => print('[+]Done :)'),
  //         onError: (err) => print('[!]Error -- ${err.toString()}'),
  //         cancelOnError: true,
  //       );
  //     }, onError: (err) => print('[!]Error -- ${err.toString()}'));
  //   }, onError: (err) => print('[!]Error -- ${err.toString()}'));
  // }, onError: (err) => print('[!]Error -- ${err.toString()}'));
}

void handleWebSocket(HttpRequest request) {
  WebSocketTransformer.upgrade(request).then((webSocket) async {
    // final roomId = "Uri.parse(request.uri.toString()).pathSegments.last";
    // print('roomId => $roomId');
    // final room = Room.getOrCreateRoom(roomId);
    // final user = User(webSocket);
    // room.addUser(user);



    webSocket.listen((message) async {

      var answer = await redirection(message, webSocket);
      if (webSocket.readyState == WebSocket.open) {
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
    }, onDone: () {
      // room.removeUser(user);
    });
  });
}

class Room {
  final String id;
  final List<User> users = [];

  Room(this.id);

  Map<dynamic, String> getListUser(){
    Map<dynamic, String> listMap = <dynamic, String>{};

    for (var user in users) {
      listMap[user.id] = user.userName;
    }
    return listMap;
  }

  void addUser(User user) {
    users.add(user);
    user.send({'obj': 'joinRoom', 'payload': {'roomId': id}});
    broadcastMessage(user, '${user.id} has joined the room');
  }

  void removeUser(User user) {
    users.remove(user);
    broadcastMessage(user, '${user.id} has left the room');
  }

  void broadcastMessage(User sender, String message) {
    for (var user in users) {
      if (user != sender) {
        user.send({'type': 'messageReceived', 'payload': {'senderId': sender.id, 'message': message}});
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
  User.name(this.webSocket, this.userName, this.idUser) : id = webSocket.hashCode.toRadixString(16)
  {
    print("User id => $id, idUser => $idUser, userName => $userName");
  }
  User(this.webSocket, this.idUser) : id = webSocket.hashCode.toRadixString(16)
  {
    print("User created id => $id, idUser => $idUser");
  }



  void send(dynamic data) {
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
  // Future<Map<String, String>> ListWidgetMySQL1(String userId) async {
  //   final conn = await MySqlConnection.connect(ConnectionSettings(
  //       host: host,
  //       port: port,
  //       user: user,
  //       db: db,
  //       password: password));
  //
  //   Map<String, String> userPresent = <String, String>{};
  //
  //   try {
  //     var result = await conn.query(
  //         'SELECT presentName, idPresent FROM present where userId = 1');
  //     print(result.length);
  //
  //     for (var row in result) {
  //       print("sldfk");
  //       userPresent['${row[0]}'] = row[1];
  //       print(userPresent);
  //     }
  //
  //   } on Exception catch (e) {
  //     print(e);
  //     print(Exception);
  //     // return "e.toString()";
  //   }
  //   await conn.close();
  //   print("sdfk");
  //   return userPresent;
  // }

  Future<Map<dynamic, String>> listWidget(String userId) async {
    final conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      password: password,
      databaseName: db,
    );
    await conn.connect();
    Map<dynamic, String> userPresent = <dynamic, String>{};

    try {
      var result;
      if (conn.connected) {
        result = await conn.execute(
            "SELECT present.presentName, present.idPresent FROM iziqizi.present where present.userId = :userId;",
            {"userId": userId}
        );
        await result.rowsStream.listen((row) {
          userPresent['${row.colAt(1)}'] = row.colAt(0);
        });
      }
      await Future.delayed(const Duration(milliseconds: 1500));
    } on Exception catch (e) {
      print(e);
      print(Exception);
      // return "e.toString()";
    }
    conn.close();
    // userPresent.forEach((k, v) => list.add(PresentNameMap(k, v)));
    // list = userPresent.values.toList();
    print("list => $userPresent");

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
        var result = await conn.execute(
            "SELECT idUser, password FROM iziqizi.user WHERE email = :email;",
            {"email": email});
        conn.close();
        print(!result.isNotEmpty);
        if (!result.isNotEmpty) {
          print("password in BD => ${result.rows.first.colAt(1)}");
          print("password in reqy => $pass");
          print("idUser in BD => ${result.rows.first.colAt(0)}");

          if (pass.toString() == result.rows.first.colAt(1).toString()) {
            return "authorized ${result.rows.first.colAt(0)}";
          } else {
            return "authErr";
          }
        } else {
          return "QueryError";
        }
      } catch (err) {
        print("Возникло исключение $err");
        return err.toString();
      }
    }
    print("Connected 404");
    return "ErrConnected";
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
      print("Connected 0");

      // var result = await conn.execute("CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER "
      //     "VIEW `view` AS "
      //     "SELECT DISTINCT `users`.`email` AS `userPresent`, `present`.`present` AS `Present` "
      //     "FROM ((`present` JOIN `users`) JOIN `1-m`) "
      //     "WHERE (`users`.`email` = '2001andru@mail.ru')''"
      // );
      var result2 = await conn.execute("SELECT `Present` FROM `view`;");
      result2.rowsStream.listen((event) {
        print(event.colAt(0).toString());
      });
      print("reult2 ==== $result2");
      conn.close();
      return 0;
    } else {
      print("Connected 404");
      return 404;
    }
  }

  Future<String> Register(String email, String pass) async {
    // Obtain shared preferences.
    // final prefs = await SharedPreferences.getInstance(); // *********SharedPreferences

    final claimSet = JwtClaim(
        issuer: 'Me',
        subject: email + ' ' + pass,
        issuedAt: DateTime.now(),
        maxAge: const Duration(hours: 12));

    String secret = pass;
    String token = issueJwtHS256(claimSet, secret);
    print(token);
    // await prefs.setString('JWT', token); // *********SharedPreferences

    final v;
    try {
      final JwtClaim decClaimSet = verifyJwtHS256Signature(token, secret);
      print(decClaimSet);

      decClaimSet.validate(issuer: 'Me');

      if (claimSet.jwtId != null) {
        print("claimSet.jwtId = ${claimSet.jwtId}");
      }
      if (claimSet.containsKey('sub')) {
        v = claimSet['sub'];
        if (v is String) {
        } else {}
        final parts = v.split(' ');
        print("Mail: ${parts[0]}");
        print("Pass: ${parts[1]}");
      }
    } on JwtException {
      print("ERROOR");
    }

    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(email);

    bool isPasswordValid(String password) {
      if (password.length < 8) return false;
      if (!password.contains(RegExp(r"[a-z]"))) return false;
      if (!password.contains(RegExp(r"[A-Z]"))) return false;
      if (!password.contains(RegExp(r"[0-9]"))) return false;
      if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
      return true;
    }

    final bool passwordValid = isPasswordValid(pass);


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
        print("password ($pass) and email ($email) is valid");

        var res = await conn.execute(
            "INSERT INTO `iziquiziusers`.`users` (`email`, `password`) "
            "VALUES (:email, :password);",
            {
              "email": email,
              "password": pass,
            });
        conn.close();
        return "Register";
      } else {
        return "RegisterError";
      }
    } else {
      return "ConnectErr";
    }
  }

  Future<String> CreatePresent(String? namePresent, String? email) async {
    final conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      password: password,
      databaseName: db,
    );
    await conn.connect();
    if (conn.connected) {
      print("Connected 0");

      try {
        await conn.execute(
            "INSERT INTO `iziqizi`.`present` (`userId`, `presentName`) VALUES (:idUser, :name);",
            {"idUser": email, "name": "$namePresent"});
        await conn.execute(
            "SELECT idPresent FROM iziqizi.present where userId = (:idUser) ;",
            {"idUser": email, "name": "$namePresent"});
        // await conn.execute("INSERT INTO `iziqizi`.`1-m` (`email`, `present`) VALUES (:email, :present);",
        //     {
        //       "email":"$email",
        //       "present": "$namePresent"
        //     }
        // );
        return 'success';
      } on Exception catch (e) {
        print("Exception => $Exception, e => $e");
        return ("CreateError => $e");
      } finally {
        conn.close();
      }
    } else {
      return ("Create present connect error");
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
            "DELETE FROM `iziquiziusers`.`present` WHERE (`present` = :nameDeletePresent);",
            {"nameDeletePresent": "$nameDeletePresent"});
      } catch (e) {
        print("exception delete => $e");
      }

      conn.close();
    } else {
      print("Connected 404");
    }
  }

  Future<String> presentRename(
      String? nameUpdate, String? newName, String? email) async {
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
        print("Update $nameUpdate = $newName");
        var result = await conn.execute(
            "UPDATE `iziquiziusers`.`present` SET `present` = :newName WHERE (`present` = :nameUpdate);",
            {
              "newName": "$newName",
              "nameUpdate": "$nameUpdate",
            });
        return 'success';
      } catch (e) {
        print("Exception rename => $e");
        return (e.toString());
      } finally {
        conn.close();
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
    String json = '';
    if (conn.connected) {
      try {
        final result = await conn.execute(
            "SELECT present.slides_data FROM iziqizi.present where present.idPresent = :idPresent;",
            {
              "idPresent": idPresent,
            });
        // result.rowsStream.listen((row) {
        //   list.add(row.colAt(0)!);
        // });
        for (final row in result.rows) {
          print(row.assoc());
          json += row.colAt(0)!;
        }
        // json = result.rows.first.toString();
      } catch (e) {
        print("exception setSlideData => $e");
      } finally {
        conn.close();
      }
      await Future.delayed(const Duration(milliseconds: 500));
      return json;
    } else {
      return "Connected 404";
      print("Connected 404");
    }
  }

  Future<void> setSlideData(
      String idUser, String presentName, String jsonSlide) async {
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
            "UPDATE `iziqizi`.`present` SET `slides_data` = (:jsonSlide) WHERE (`userId` = :idUser) and (`presentName` = :presentName);",
            {
              "idUser": idUser,
              "presentName": presentName,
              "jsonSlide": jsonSlide,
            });
      } catch (e) {
        print("exception setSlideData => $e");
      } finally {
        conn.close();
      }
    } else {
      print("Connected 404");
    }
  }
}

Future<Map<String, dynamic>> redirection(data, WebSocket webSocket) async {
  var _json = Map<String, dynamic>.from(json.decode(data));

  switch (_json['request_to']) {
    // Database queries
    case 'bd':
      {
        switch (_json['action']) {
          case 'create':
            {
              print("namePresent => ${_json['namePresent']}, email => ${_json['email']}");
              var res = await sql.CreatePresent(_json['namePresent'], _json['email']);
              print("REUSLT => $res");
              if (res.toString() == 'success') {
                return {
                  'obj': 'create',
                  'success': "true",
                };
              } else {
                return {
                  'obj': 'create',
                  'success': "false",
                };
              }
            }
          case 'rename':
            {
              print("nameUpdate => ${_json['nameUpdate']}, email => ${_json['email']}, newName => ${_json['newName']}");
              sql.presentRename(_json['nameUpdate'], _json['newName'], _json['email']);
              break;
            }
          case 'delete':
            {
              print("nameDeletePresent => ${_json['nameDeletePresent']}, email => ${_json['email']}");
              sql.deletePresent(_json['nameDeletePresent'], _json['email']);
              break;
            }
          case 'presentList':
            {
              var list = await sql.listWidget(_json['idUser']);
              Map<String, dynamic> json() => {
                    'obj': 'listWidget',
                    'list': list,
                  };
              print("JSON() => ${json()}");
              return json();
            }
          case 'setSlideData':
            {
              sql.setSlideData(_json['idUser'], _json['presentName'], _json['slideData']);
              break;
            }
          case 'getSlideData':
            {
              var list = await sql.getSlideData(_json['idPresent'], _json['presentName']);
              Map<String, dynamic> json() => {
                'obj': 'SlideData',
                'list': list,
              };
              print("getSlideData => ${json()}");
              return json();
            }
          default:
            {
              print('JSON parse error (bd)');
            }
        }
        break;
      }
    // User queries
    case 'user':
    {
      switch (_json['action']) {
        case 'auth':
          {
            print(
                "Auth: email => ${_json['email']}, pass => ${_json['pass']}");
            String auth =
            await sql.authentication(_json['email'], _json['pass']);
            print("auth => $auth");
            List<String> lst = auth.split(' ');
            print("auth => $lst");
            if (lst[0] == "authorized") {
              Map<String, dynamic> json() => {
                'obj': 'auth',
                'valid': "true",
                'idUser': lst[1],
              };
              return json();
            } else {
              return {
                'obj': 'auth',
                'valid': "false",
              };
            }
          }
        case 'register':
          {
            print("nameDeletePresent => ${_json['nameDeletePresent']}, email => ${_json['email']}");
            sql.deletePresent(_json['nameDeletePresent'], _json['email']);
            break;
          }
        default:
          {
            print('JSON parse error (user)');
          }
      }
      break;
    }
    case 'MultipleView':
      {
        switch (_json['action']) {
          case 'createRoom':{
            final String userId = _json['idUser'];
            final presentName = _json['presentName'];
            final String roomId = userId;


            final room = Room.getOrCreateRoom(roomId);
            final user = User(webSocket, userId);
            room.addUser(user);
            print('roomId => $roomId, user.idUser => ${user.idUser}');


            Map<String, dynamic> json() => {
              'obj': 'MultipleView',
              'roomId': roomId,
              'presentName': presentName,
            };
            break;
          }
          case 'joinRoom':{
            // print("joinRoom");
            final String userName = _json['userName'];
            final String roomId = _json['roomId'];

            final room = Room.getOrCreateRoom(roomId);
            final user = User.name(webSocket, userName, webSocket.hashCode.toRadixString(16));
            room.addUser(user);

            var list = room.getListUser();
            Map<String, dynamic> json() => {
              'obj': 'listUser',
              'list': list,
            };
            return json();
          }
          default:
          {
            print('JSON parse error (MultipleView)');
          }
        }
        break;
      }
    default:{}
  }
  return {
    'obj': 'err',
  };
}
