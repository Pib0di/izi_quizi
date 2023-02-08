import 'dart:async';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// - - - - - - - - - - - - - SOCKET - - - - - - - - - -
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:io' show WebSocket;
import 'dart:async' show Timer;
import 'dart:convert' show json;
import 'dart:convert';
import 'package:universal_html/html.dart';
import 'main.dart';


class SQL
{
  late String host = 'localhost',
      user = 'root',
      password = '1234',
      db = 'iziquiziusers';
  int port = 3306;

  Future<List<String>> ListWidget() async {
    final conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      password: password,
      databaseName: db,
    );
    await conn.connect();

    List<String> list = ['hi'];

    if (conn.connected)
    {
      var result = await conn.execute("SELECT present.present, present.items FROM iziquiziusers.present, iziquiziusers.`1-m` where present.present = `1-m`.present;",
      );
      conn.close();

      result.rowsStream.listen((row) {
        // print("row.colAt(0).toString()} = ${row.colAt(0).toString()}");
        list.add(row.colAt(0).toString());
      });
      print("List = $list");
    }

    return list;
  }

  Future<String> authentication(String email, String pass) async{

    final conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      password: password,
      databaseName: db,
    );
    await conn.connect();

    if (conn.connected) {
      print("conn = ${conn.connected}");
      var result = await conn.execute("SELECT password FROM iziquiziusers.users WHERE email = :email;",
          {"email": email}
      );
      conn.close();
      // result.rowsStream.listen((row) {
      //   print(row.colAt(0).toString());
      // });
      print("${result.rows.first.colAt(0)}");

      if (pass == result.rows.first.colAt(0)) {
        // return "${result.rows.first.colAt(0)}";
      return "authorized";
      }
      else{
        return "authErr";
      }
    }

    print("Connected 404");
    conn.close();
    return "ErrConnected";
  }

  Future<int> connection () async {
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
    }
    else {
      print("Connected 404");
      return 404;
    }
  }

  Future<String> Register(String email, String pass) async {

    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();


    final claimSet = JwtClaim(
        issuer: 'Me',
        subject: '${email + ' ' + pass}',
        issuedAt: DateTime.now(),
        maxAge: const Duration(hours: 12)
    );

    String secret = "${pass}";
    String token = issueJwtHS256(claimSet, secret);
    print(token);
    await prefs.setString('JWT', token);

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



    final bool emailValid =
    RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
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

    String mess;

    final conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      password: password,
      databaseName: db,
    );
    await conn.connect();

    if (conn.connected)
    {
      final String? JWT = prefs.getString('JWT');
      print("JWT =  $JWT");
      if(emailValid && passwordValid)
      {
        print("password ($pass) and email ($email) is valid");
        mess = "Пароль или почта введены не верно";

        var res = await conn.execute("INSERT INTO `iziquiziusers`.`users` (`email`, `password`) "
            "VALUES (:email, :password);",
            {
              "email": "$email",
              "password": "$pass",
            }
        );
        conn.close();
        return "Register";
      }
      else
      {
        return "RegisterError";
      }
    }
    else
    {
      return "ConnectErr";
    }
  }

  Future<void> CreatePresent(String namePresen) async{
    String name = namePresen;

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

      var result = await conn.execute("INSERT INTO `iziquiziusers`.`present` (`present`) VALUES (:name);",
          {"name": "$namePresen"}
      );
      var results = await conn.execute("INSERT INTO `iziquiziusers`.`1-m` (`email`, `present`) VALUES ('2001andru@mail.ru', :present);",
          {"present": "$namePresen"}
      );

      conn.close();
    }
    else {
      print("Connected 404");
    }
  }

  Future<void> deletePresent (String? nameDeletePresent) async {
    final conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      password: password,
      databaseName: db,
    );
    await conn.connect();
    if (conn.connected) {
      print("Delete $nameDeletePresent");

      var result = await conn.execute("DELETE FROM `iziquiziusers`.`1-m` WHERE (`email` = '2001andru@mail.ru') and (`present` = :nameDeletePresent);",
          {"nameDeletePresent": "$nameDeletePresent"}
      );
      var results = await conn.execute("DELETE FROM `iziquiziusers`.`present` WHERE (`present` = :nameDeletePresent);",
          {"nameDeletePresent": "$nameDeletePresent"}
      );

      conn.close();
    }
    else {
      print("Connected 404");
    }
  }

  Future<void> presentRename (String? nameUpdate, String? newName) async {
    final conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      password: password,
      databaseName: db,
    );
    await conn.connect();
    if (conn.connected) {
      print("Update $nameUpdate = $newName");

      var result = await conn.execute("UPDATE `iziquiziusers`.`present` SET `present` = :newName WHERE (`present` = :nameUpdate);",
          {"newName": "$newName",
            "nameUpdate": "$nameUpdate",
          }
      );
      conn.close();
    }
    else {
      print("Connected 404");
    }
  }

}


class SocketConnection
{
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

class User{
  User._();
  User(this.email);

  String email = '';
}

class Request {
  Request(this._connection);

  SocketConnection _connection;

  //- - - - - - - - - - - - - - - - - - - - BD - - - - - - - - - - - - - - - - -
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
  void createPresent(String email, String namePresent) {
    Map<String, dynamic> json() => {
      'request_to': 'bd',
      'action': "create",
      'email': email,
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

  Future<void> listWidget() async {
    Map<String, dynamic> json() => {
      'request_to': 'bd',
      'action': "presentList",
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
    // var jsonRequest = jsonEncode(json());
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

  parse(dynamic _json) async {
    var data = Map<String, dynamic>.from(json.decode(_json));
    print("data => $data");
    switch(data['obj']) {
      case 'auth': {
        switch(data['valid']) {
          case 'true': {
            isAuth = true;
            break;
          }
          default:{
            print("Authorization failed");
          }
        }
        break;
      }
      case 'registration': {
        switch(data['valid']) {
          case 'true': {
            bool verification = true; // ????
            break;
          }
          default:{
            print("Registration failed");
          }
        }
        break;
      }
      case 'listWidget': {
        if (!data['list']!.isEmpty){
          // listStr = await data["list"].entries.map( (entry) => (entry.value)).toList();
          listStr = await data["list"];
          print("LISTSTR => ${listStr}");
          widgetListIsReload = true;
        }
        break;
      }
      case 'create': {
        if (data['success'] == 'true'){
          print("present create => ${data['success']}");
          bool _presentCreate = true; // ????
        }
        break;
      }
      default: {
        print('JSON parse error (Не найдено предусмотренное значение)');
      }
    }
  }
}