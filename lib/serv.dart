import 'dart:io' show HttpServer, HttpRequest, WebSocket, WebSocketTransformer;
import 'dart:convert' show json;
import 'dart:convert';
import 'dart:async' show Timer;


import 'dart:async';
import 'dart:io';
import 'package:mysql_client/mysql_client.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import 'package:mysql1/mysql1.dart';
// import 'package:shared_preferences/shared_preferences.dart';

SQL sql = SQL();

void main() {
  HttpServer.bind('localhost', 8000).then((HttpServer server) {
    print('[+]WebSocket listening at -- ws://localhost:8000/');
    server.listen((HttpRequest request) {
      WebSocketTransformer.upgrade(request).then((WebSocket ws) {
        ws.listen(
              (data) async {
                // print('request => ${request?.connectionInfo?.remoteAddress}');
                print(data);
                // print("Connection from: ${data?.remoteAddress?.address}:${data.remotePort}");
                // Map<String, dynamic> answer = redirection(data);
                var answer = await redirection(data);
                if (ws.readyState == WebSocket.open)
                {
                  // var s = jsonEncode(json(answer));
                  ws.add(jsonEncode(answer));
                }
              },
          onDone: () => print('[+]Done :)'),
          onError: (err) => print('[!]Error -- ${err.toString()}'),
          cancelOnError: true,
        );
      }, onError: (err) => print('[!]Error -- ${err.toString()}'));
    }, onError: (err) => print('[!]Error -- ${err.toString()}'));
  }, onError: (err) => print('[!]Error -- ${err.toString()}'));
}

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

    try {
      var result;
      if(conn.connected){
        result = await conn.execute(
          "SELECT present.present, present.items FROM iziquiziusers.present, iziquiziusers.`1-m` where present.present = `1-m`.present;",
        );
        await result.rowsStream.listen((row) {
          list.add(row.colAt(0));
          // print("${row.colAt(0)}");
        });
      }
      await Future.delayed(Duration(milliseconds: 500));
    } on Exception catch (e) {
      print(e);
      print(Exception);
      // return "e.toString()";
    }
    conn.close();
    return list;
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
      try{
        var result = await conn.execute("SELECT password FROM iziquiziusers.users WHERE email = :email;",
            {"email": email}
        );
        conn.close();
        print(!result.isNotEmpty);
        if (!result.isNotEmpty){
          print("password in BD => ${result.rows.first.colAt(0)}");
          print("password in reqy => $pass");

          if (pass.toString() == result.rows.first.colAt(0).toString()) {
            return "authorized";
          }
          else {
            return "authErr";
          }
        }
        else{
          return "QueryError";
        }
      }
      catch(err){
        print("Возникло исключение $err");
        return err.toString();
      }
    }
    print("Connected 404");
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
    // final prefs = await SharedPreferences.getInstance(); // *********SharedPreferences


    final claimSet = JwtClaim(
        issuer: 'Me',
        subject: '${email + ' ' + pass}',
        issuedAt: DateTime.now(),
        maxAge: const Duration(hours: 12)
    );

    String secret = "${pass}";
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
      // final String? JWT = prefs.getString('JWT');   // *********SharedPreferences
      // print("JWT =  $JWT");  // *********SharedPreferences

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
        await conn.execute("INSERT INTO `iziquiziusers`.`present` (`present`) VALUES (:name);",
            {
              "name": "$namePresent"
            }
        );
        await conn.execute("INSERT INTO `iziquiziusers`.`1-m` (`email`, `present`) VALUES (:email, :present);",
            {
              "email":"$email",
              "present": "$namePresent"
            }
        );
        return 'success';
      } on Exception catch (e) {
        print("Exception => $Exception, e => $e");
        return("CreateError => $e");
      }
      finally{
        conn.close();
      }
    }
    else {
      return("Create present connect error");
      print("Connected 404");
    }
  }
  Future<void> deletePresent (String? nameDeletePresent, String? email) async {
    final conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      password: password,
      databaseName: db,
    );
    await conn.connect();
    if (conn.connected) {
      // print("Delete $nameDeletePresent");

      try {
        // var result = await conn.execute("DELETE FROM `iziquiziusers`.`1-m` WHERE (`email` = :email) and (`present` = :nameDeletePresent);",
        //     {
        //       "email": "$email",
        //       "nameDeletePresent": "$nameDeletePresent"
        //     }
        // );
        await conn.execute("DELETE FROM `iziquiziusers`.`present` WHERE (`present` = :nameDeletePresent);",
            {"nameDeletePresent": "$nameDeletePresent"}
        );
      } catch (e) {
        print("exception delete => $e");
      }

      conn.close();
    }
    else {
      print("Connected 404");
    }
  }
  Future<String> presentRename (String? nameUpdate, String? newName, String? email) async {
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
        var result = await conn.execute("UPDATE `iziquiziusers`.`present` SET `present` = :newName WHERE (`present` = :nameUpdate);",
            {
              "newName": "$newName",
              "nameUpdate": "$nameUpdate",
            }
        );
        return 'success';
      } catch (e) {
        print("Exception rename => $e");
        return(e.toString());
      }
      finally{
        conn.close();
      }
    }
    else {
      return 'ConnErr';
    }
  }
}

Future<Map<String, dynamic>> redirection(data) async
{
  var _json = Map<String, dynamic>.from(json.decode(data));

  switch (_json['request_to'])
  {
    // Database queries
    case 'bd':{
      switch (_json['action'])
      {
        case 'create':{
          print("namePresent => ${_json['namePresent']}, email => ${_json['email']}");
          var res = await sql.CreatePresent(_json['namePresent'], _json['email']);
          print("REUSLT => ${res}");
          if ( res.toString() == 'success'){
            return {
              'obj': 'create',
              'success': "true",
            };
          }
          else{
            return {
              'obj': 'create',
              'success': "false",
            };
          };
        }
        case 'rename':{
          print("nameUpdate => ${_json['nameUpdate']}, email => ${_json['email']}, newName => ${_json['newName']}");
          sql.presentRename(_json['nameUpdate'], _json['newName'], _json['email']);
          break;
        }
        case 'delete':{
          print("nameDeletePresent => ${_json['nameDeletePresent']}, email => ${_json['email']}");
          sql.deletePresent(_json['nameDeletePresent'], _json['email']);
          break;
        }
        case 'presentList':{
          var list = await sql.ListWidget();
          Map<String, dynamic> json() => {
            'obj': 'listWidget',
            'list': list,
          };
          print("JSON() => ${json()}");
          return json();
          break;
        }
        default:{
          print('JSON parse error (bd)');
        }
      }
      break;
    }
    // User queries
    case 'user':
    {
      switch (_json['action'])
      {
        case 'auth':{
          print("Auth: email => ${_json['email']}, pass => ${_json['pass']}");
          String auth = await sql.authentication(_json['email'], _json['pass']);
          print("auth => $auth");
          if (auth == "authorized"){
            Map<String, dynamic> json() => {
              'obj': 'auth',
              'valid': "true",
            };
            var jsonRequest = jsonEncode(json());
            return json();
          }
          else{
            return {
              'obj': 'auth',
              'valid': "false",
            };
          }
        }
        case 'register':{
          print("nameDeletePresent => ${_json['nameDeletePresent']}, email => ${_json['email']}");
          sql.deletePresent(_json['nameDeletePresent'], _json['email']);
          break;
        }
        default:{
          print('JSON parse error (user)');
        }
      }
      break;
    }
    default:{

    }
  }

  return {
    'obj': 'err',
  };
}
