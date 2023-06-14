import 'dart:convert';
import 'dart:io';

class Report {
  Report(this.numSlide, this.typeSlide, this.data);

  int? numSlide;
  String? typeSlide;
  String? data;
}

class Room {
  final String id;
  final List<User> users = [];

  Room(this.id);

  User? getUser(String id) {
    for (var element in users) {
      if (element.id == id) {
        return element;
      }
    }
    return null;
  }

  Map<String, String> getListUser() {
    final listMap = <String, String>{};

    for (var user in users) {
      listMap[user.id] = user.userName;
    }
    return listMap;
  }

  void addUser(User user) {
    users.add(user);
    user.send({
      'obj': 'joinRoom',
      'result': 'successful',
      'idUser': user.webSocket.hashCode.toRadixString(16).toString(),
    });
    broadcastMessage(user, 'joinRoom');
  }

  void dispose() {
    for (var user in users) {
      user.send({
        'obj': 'disposeRoom',
      });
    }
    if (users.isNotEmpty) {
      users.clear();
    }
    if (rooms.containsKey(id)) {
      rooms.remove(id);
      // rooms[id]!.dispose();
    }
  }

  void removeUser(String idUser) {
    if (users.isNotEmpty && users.first.id == idUser) {
      dispose();
    } else {
      for (var user in users) {
        if (user.id == idUser) {
          user.send({
            'obj': 'removeUser',
          });
          users.removeWhere((element) => element.id == idUser);
          break;
        }
      }
      final listUser = getListUser();
      sendUserList(listUser);
    }
  }

  void broadcastMessage(User sender, message) {
    for (var user in users) {
      if (user != sender) {
        user.send({
          'obj': 'messageReceived',
          'senderId': sender.id,
          'message': message,
          // 'listUser': message,
        });
      }
    }
  }

  void sendUserList(listUser) {
    for (var user in users) {
      user.send({
        'obj': 'getUser',
        'listUser': listUser,
      });
    }
  }

  static final Map<String, Room> rooms = {};

  static Room getOrCreateRoom(String id) {
    return rooms.putIfAbsent(id, () => Room(id));
  }
}

class User {
  List<Report> report = [];
  final String id;
  final WebSocket webSocket;
  final String idUser;
  String userName = 'undefined user';

  User.name(this.webSocket, this.userName, this.idUser)
      : id = webSocket.hashCode.toRadixString(16);

  User(this.webSocket, this.idUser) : id = webSocket.hashCode.toRadixString(16);

  void send(data) {
    print('send => $data');
    webSocket.add(jsonEncode(data));
  }
}
