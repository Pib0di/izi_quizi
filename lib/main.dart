// import 'package:flutter/material.dart';


// void main() {
//
//
//   WebSocket.connect('ws://localhost:8000').then((WebSocket ws) {
//     // our websocket server runs on ws://localhost:8000
//     if (ws?.readyState == WebSocket.open) {
//       // as soon as websocket is connected and ready for use, we can start talking to other end
//       ws.add(json.encode({
//         'data': 'from client at ${DateTime.now().toString()}',
//       })); // this is the JSON data format to be transmitted
//       ws.listen( // gives a StreamSubscription
//             (data) {
//           print('\t\t -- ${Map<String, String>.from(json.decode(data))}'); // listen for incoming data and show when it arrives
//           Timer(Duration(seconds: 1), () {
//             if (ws.readyState == WebSocket.open) // checking whether connection is open or not, is required before writing anything on socket
//               ws.add(json.encode({
//                 'data': 'from client at ${DateTime.now().toString()}',
//               }));
//           });
//         },
//         onDone: () => print('[+]Done :)'),
//         onError: (err) => print('[!]Error -- ${err.toString()}'),
//         cancelOnError: true,
//       );
//     } else
//       print('[!]Connection Denied');
//     // in case, if serer is not running now
//   }, onError: (err) => print('[!]Error -- ${err.toString()}'));
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     // var ws = WebSocket('ws://127.0.0.1:1337/ws');
//     // ws.send('Hello from Dart!');
//     // ws.onMessage.listen((MessageEvent e) {
//     //   print('Received message: ${e.data}');
//     // });
//     const title = 'WebSocket Demo';
//     return const MaterialApp(
//       title: title,
//       home: MyHomePage(
//         title: title,
//       ),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({
//     super.key,
//     required this.title,
//   });
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   final TextEditingController _controller = TextEditingController();
//   final _channel = WebSocketChannel.connect(
//     Uri.parse('ws://localhost:8000'),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Form(
//               child: TextFormField(
//                 controller: _controller,
//                 decoration: const InputDecoration(labelText: 'Send a message'),
//               ),
//             ),
//             const SizedBox(height: 24),
//             StreamBuilder(
//               stream: _channel.stream,
//               builder: (context, snapshot) {
//                 return Text(snapshot.hasData ? '${snapshot.data}' : '');
//               },
//             )
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _sendMessage,
//         tooltip: 'Send message',
//         child: const Icon(Icons.send),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
//
//   void _sendMessage() {
//     if (_controller.text.isNotEmpty) {
//       _channel.sink.add(_controller.text);
//     }
//   }
//
//   @override
//   void dispose() {
//
//     super.dispose();
//   }
// }


// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// Future<Album> createAlbum(String title) async {
//   final response = await http.post(
//     Uri.parse('https://jsonplaceholder.typicode.com/albums'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       'title': title,
//     }),
//   );
//
//   if (response.statusCode == 201) {
//     // If the server did return a 201 CREATED response,
//     // then parse the JSON.
//     return Album.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 201 CREATED response,
//     // then throw an exception.
//     throw Exception('Failed to create album.');
//   }
// }
//
// class Album {
//   final int id;
//   final String title;
//
//   const Album({required this.id, required this.title});
//
//   factory Album.fromJson(Map<String, dynamic> json) {
//     return Album(
//       id: json['id'],
//       title: json['title'],
//     );
//   }
// }
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() {
//     return _MyAppState();
//   }
// }
//
// class _MyAppState extends State<MyApp> {
//   final TextEditingController _controller = TextEditingController();
//   Future<Album>? _futureAlbum;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Create Data Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Create Data Example'),
//         ),
//         body: Container(
//           alignment: Alignment.center,
//           padding: const EdgeInsets.all(8.0),
//           child: (_futureAlbum == null) ? buildColumn() : buildFutureBuilder(),
//         ),
//       ),
//     );
//   }
//
//   Column buildColumn() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         TextField(
//           controller: _controller,
//           decoration: const InputDecoration(hintText: 'Enter Title'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             setState(() {
//               _futureAlbum = createAlbum(_controller.text);
//             });
//           },
//           child: const Text('Create Data'),
//         ),
//       ],
//     );
//   }
//
//   FutureBuilder<Album> buildFutureBuilder() {
//     return FutureBuilder<Album>(
//       future: _futureAlbum,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return Text(snapshot.data!.title);
//         } else if (snapshot.hasError) {
//           return Text('${snapshot.error}');
//         }
//
//         return const CircularProgressIndicator();
//       },
//     );
//   }
// }

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:mysql1/mysql1.dart';
import 'slide.dart';
import 'package:provider/provider.dart';
import 'server.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:html' as html;

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

// - - - - - - - - - - - - - SOCKET - - - - - - - - - -
import 'package:web_socket_channel/web_socket_channel.dart';

import 'dart:io' show WebSocket;
import 'dart:convert' show json;
import 'dart:async' show Timer;
import 'dart:convert';

// - - - - - - - - - - - - - SOCKET - - - - - - - - - - DELETE
import 'dart:io' show HttpServer, HttpRequest, WebSocket, WebSocketTransformer;
import 'dart:convert' show json;
import 'dart:async' show Timer;


import 'dart:async';
import 'dart:io';
import 'package:mysql_client/mysql_client.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import 'package:file_picker/file_picker.dart';


// - - - - - - - - - - - - - SOCKET - - - - - - - - - - DELETE
SocketConnection _socketConnection = SocketConnection();
Request request = Request(_socketConnection);
ParseMessege parseMessege = ParseMessege();
bool widgetListIsReload = false;

// - - - - - - - - - - - - - - - - - - - - - - - - - - -
bool isAuth = false;
String email = '';
String deletePresent = '';
List<dynamic?> listStr = ['hi'];


// - PROVIDER - - - - - - - - - - - - - - - - - - - - - - - - - -
/// не нужон
final counterProvider = StateProvider((ref) => 0);

/// номер текущего слайда
final buttonID = StateProvider((ref) => 0);

/// количество созданных слайдов
final counterSlide = StateProvider((ref) => 0);

/// NumAddItem - номер добавляемого элемента
/// 0 - Заголовок;
/// 1 - Основной текст;
final numAddItem = StateProvider((ref) => 0);

/// номер выбранного элемента в слайде
final ItemId = StateProvider((ref) => 0);

/// номер элемента в слайде для удаления
final Key key = const Key("");
final delItemId = StateProvider<Key>(
  // We return the default sort type, here name.
      (ref) => key,
);

/// локальный путь до фотографии
final File file = File("");
final fileProvider = StateProvider<File>(
      (ref) => file,
);
// final delItemId = StateProvider((ref) => 0);



// void main() {
//   final input = html.FileUploadInputElement();
//   input.onChange.listen((event) {
//     final file = input.files!.first;
//     print("${file.relativePath}");
//     print("${file.name}");
//     print("${file.size}");
//     final reader = html.FileReader();
//     reader.readAsDataUrl(file);
//     reader.onLoadEnd.listen((event) {
//       final dataUrl = reader.result;
//       final img = html.ImageElement(src: dataUrl as String);
//       html.document.body?.append(img);
//     });
//   });
//
//   html.document.body?.append(input);
// }

void main() {
  // WebSocket.connect('ws://localhost:8000').then((WebSocket ws) {
  //   // our websocket server runs on ws://localhost:8000
  //   if (ws?.readyState == WebSocket.open) {
  //     ws.add('Hello server'); // this is the JSON data format to be transmitted
  //     ws.listen( // gives a StreamSubscription
  //           (data) {
  //             print(data);
  //             Timer(Duration(seconds: 2), () {
  //               if (ws.readyState == WebSocket.open) // checking whether connection is open or not, is required before writing anything on socket
  //                 ws.add("Hello server");
  //             });
  //             Timer(Duration(seconds: 2), () {
  //               ws.close();
  //             });
  //       },
  //       onDone: () => print('[+]Done :)'),
  //       onError: (err) => print('[!]Error -- ${err.toString()}'),
  //       cancelOnError: true,
  //     );
  //   } else
  //     print('[!]Connection Denied');
  // }, onError: (err) => print('[!]Error -- ${err.toString()}'));

  _socketConnection.getConnection().stream.listen((event) {
    print("event => $event");
    parseMessege.parse(event);
    print (isAuth);
  });
  // _socketConnection.sendMessage('data');

  runApp(
    ProviderScope(
      child: MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  SQL sql = SQL();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IziQuizi',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.green,
      ),
      home: const Scaffold(
        body: MyStatefulWidget(),
      )
    );
  }
}
class MyStateful extends StatefulWidget {
  const MyStateful({super.key});

  @override
  State<MyStateful> createState() => _MyStatefulState();
}

class _MyStatefulState extends State<MyStateful> {
  Color _color = Colors.white10;
  Offset _offset = Offset.zero;
  double width = 300, height = 300;
  double angle = 0;
  String txt = '';
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle:-0,
      // transform: Matrix4.identity()
      // ..setEntry(3, 2, 0.001) // perspective
      // ..rotateX(0.01 * _offset.dy) // changed
      // ..rotateY(-0.01 * _offset.dx), // changed
      alignment: FractionalOffset.center,
      child: Container(
        color: _color,
        // height: height < 100 ? 100 : height,
        // width: width < 100 ? 100 : width,
        // height: double.maxFinite,
        // width: double.maxFinite,

        height: 500,
        width: 500,

        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
            onPanUpdate: (details) => setState(() => {
              _offset += details.delta,
              txt = _offset.toString(),
              width = _offset.dx,
              height = _offset.dy,
              angle = (_offset.dx)/2*0.01,
              print(angle),
              print(_offset),
            }),
            onTap: () {
              setState(() {
                _offset = Offset.zero;
                _color == Colors.yellow
                    ? _color = Colors.white
                    : _color = Colors.yellow;
              });
            },
            child: Transform(
              transform: Matrix4.identity()
              ..setTranslationRaw(_offset.dx, _offset.dy, 0),
              // ..scale(0.8),
              // ..rotateZ(0.01 * _offset.dx),
              alignment: FractionalOffset.center,
              child: Container(
                width: 100,
                height: 100,
                constraints: const BoxConstraints(
                  minWidth: 70,
                  minHeight: 70,
                  maxWidth: 150,
                  maxHeight: 150,
                ),
                color: Colors.black12,
                child: Text(txt),
              ),
            ),
        ),
      ),
    );
  }
}


class ProgectName extends StatelessWidget {
  ProgectName(TextEditingController? controll) : myController = controll;
  TextEditingController? myController;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      child: TextFormField(
        controller: myController,
        restorationId: 'life_story_field',
        textInputAction: TextInputAction.next,
        // focusNode: _lifeStory,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Проективная геометрия 2-3 неделя",
          // helperText: "название вашего iziQuizi",
          labelText: "Имя проекта",
        ),
        maxLines: 1,
      ),
    );
  }
}



class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  static SQL sql = SQL();
  final Future<int> isConnected = sql.connection();
  final Future<String> isAuthorized = sql.authentication("12", "1234");

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }



  PopupMenuItem<String> _buildMenuItem(String text) {
    return PopupMenuItem<String>(
      child: Text('$text'),
    );
  }
  Future<List<String>> _listStr = sql.ListWidget();
  final myController = TextEditingController();
  @override
  void setStates()
  {
    setState(() {
      request.listWidget();
      // listStr.forEach((element) {print("element listStr => $element");});
      // _listStr = sql.ListWidget();
      if (widgetListIsReload){
        widgetListIsReload = false;
        // _listStr = listStr;
      }
      else{
      }
      // isAuth = true;
      print("$isAuth");
    });
  }

  Timer? _timer;
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
            setStates();
      },
    );
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void setStateDel()
  {
  }

  @override
  Widget build(BuildContext context) {
    void _showSimpleDialog() {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              backgroundColor: const Color(0xE5F4FFF0),
              contentPadding: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 12.0),
              titlePadding: const EdgeInsets.fromLTRB(14.0, 24.0, 14.0, 10.0),
              title: const Text('Создать викторину'),
              children: <Widget>[
                ProgectName(myController),
                Container(
                  height: 60.0,
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade300,
                          padding: const EdgeInsets.all(16.0),
                          textStyle: const TextStyle(fontSize: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          print("cancel");
                          Navigator.pop(context, ClipRRect);
                        },
                        child: const Text('Отмена'),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade300,
                          padding: const EdgeInsets.all(16.0),
                          textStyle: const TextStyle(fontSize: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          print("myController.text = ${myController.text}");
                          request.createPresent(email, myController.text);
                          // final Future<void> _listStr =  sql.CreatePresent(myController.text);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SecondRoute1(myController.text)),
                          );
                          setStates();
                        },
                        child: const Text('Создать'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        toolbarHeight: 50,
        leadingWidth: 120,
        leading: const Center(
          child: Text(
            'IziQuizi',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
        ),

        // title: const Text('TabBar Widget'),
        actions: [
          Container(
            margin:  const EdgeInsets.only(left: 150),
            child: TabBar(
              labelColor: Colors.white60,
              indicatorColor: Colors.green[800],
              isScrollable: true,
              controller: _tabController,
              tabs: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.home),
                      const SizedBox(width:5),
                      const Text("Дом"),
                    ],
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.av_timer),
                      const SizedBox(width:5),
                      const Text("Мероприятия"),
                    ],
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.people),
                      const SizedBox(width:5),
                      const Text("Комнаты"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Center(
            child: OutlinedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade300,
                padding: const EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: (
                  const BorderSide(
                    color: Colors.transparent,
                 )
                ),
              ),
              icon: const Icon(Icons.add, size: 18, color: Colors.white,),
              label: const Text(
                'Создать',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                _showSimpleDialog();
                setStates();
              },
            ),
          ),
          Builder(
              builder: (BuildContext context) {
                if (isAuth) {
                  return popapMenu(true, context);
                }
                else{
                  return popapMenu(false, context);
                }
              }
          ),
          FutureBuilder <String>(
            // future: isConnected,
            future: isAuthorized,
            builder: (BuildContext Context, AsyncSnapshot<String> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                print("isAUTH = $isAuth");
                if (isAuth) {
                  return popapMenu(true, context);
                }
                else{
                  return popapMenu(true, context);
                }
              } else if (snapshot.hasError) {
                return popapMenu(true, context);
              } else {
                children = const <Widget>[
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              );
            },
          ),
        ],
      ),

      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          FutureBuilder<List<String>>(
              future: _listStr,
              builder: (BuildContext Context, AsyncSnapshot<List<String>> snapshot) {
                List<Widget> childrenn = <Widget>[];
                for(int i = 0; i < listStr.length; ++i)
                {
                  childrenn.add(txtBox(listStr.elementAt(i).toString()));
                }
                if (snapshot.hasData) {
                  // print("SnapshothasData = ${snapshot.data}");
                  // for(int i = 0; i < listStr.length; ++i)
                  // {
                  //   print("$i = ${listStr.elementAt(i).toString()}");
                  //   childrenn.add(txtBox(listStr.elementAt(i).toString(), setStateDel()));
                  // }
                  // for(int i = 0; i < snapshot.data!.length; ++i)
                  // {
                  //   // print("$i = ${snapshot.data!.elementAt(i)}");
                  //   childrenn.add(txtBox(snapshot.data!.elementAt(i), setStateDel()));
                  // }
                  // childrenn = <Widget>[
                  //   Text("${snapshot.data}"),
                  // ];

                  if (snapshot.data == "Register") {
                    isAuth = true;
                  }
                } else if (snapshot.hasError) {
                  print("SnapshothasError = ${snapshot.data}");
                } else {
                  // print("Snapshot = ${snapshot.data}");
                  childrenn = const <Widget>[
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Awaiting result...'),
                    ),
                  ];
                }
                return ListView(
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
                  children:[
                    JoinThePresentation(),
                    const SizedBox(height: 90,),
                    Wrap(
                      runSpacing: 10.0,
                      spacing: 10,
                      alignment: WrapAlignment.start,
                      children: childrenn
                    ),
                  ],
                );
              }
          ),
          FutureBuilder<String>(
            future: isAuthorized,
            builder: (BuildContext Context, AsyncSnapshot<String> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                if (isAuth) {
                  return const TabBarEvents();
                }
                else{
                  return const Join();
                }
              } else if (snapshot.hasError) {
                  if (isAuth) {
                    return const TabBarEvents();
                  }
                  else{
                    return const Join();
                  }
              } else {
                children = const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  ),
                ];
              }
              return Center(
                // heightFactor: MediaQuery.of(context).size.height+500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              );
            },
          ),
          FutureBuilder<String>(
            future: isAuthorized,
            builder: (BuildContext Context, AsyncSnapshot<String> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                if (isAuth) {
                  // return Join();
                  children = <Widget>[
                    const Center(
                      child: Text("It's sunny here"),
                    ),
                    const AlertDialog
                      (
                      content: Text("Hi"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Result: ${snapshot.data}'),
                    ),
                  ];
                }
                else{
                  return const Join();
                }
              } else if (snapshot.hasError) {
                if (isAuth) {
                  // return Join();
                  children = <Widget>[
                    const Center(
                      child: Text("It's sunny here"),
                    ),
                    const AlertDialog
                      (
                      content: Text("Hi"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Result: ${snapshot.data}'),
                    ),
                  ];
                }
                else{
                  return const Join();
                }
              } else {
                children = const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  ),
                ];
              }
              return Center(
                // heightFactor: MediaQuery.of(context).size.height+500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget txtBox(String txt)
{
  return Stack(
    children: [
      Positioned(
        child: Container(
          width: 190,
          height: 150,
          decoration: BoxDecoration(
            color: const Color(0xff7c94b6),
            image: const DecorationImage(
              image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: RawMaterialButton(
            padding: const EdgeInsets.only(bottom: 10),
            shape: const RoundedRectangleBorder(),
            onPressed: (){
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xE5DFFFD6),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    "$txt",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        right: 0,
        child: Container(
          margin: const EdgeInsets.all(5),
          width: 30,
          height: 30,
          child: RawMaterialButton(
            fillColor: Colors.redAccent,
            shape: const CircleBorder(),
            elevation: 0.0,
            onPressed: () {
              print("email => $email, txt => $txt");
              request.deletePresent(email, txt);
            },
            child: const Icon(Icons.delete, size: 20,),
          ),
        ),
      ),
    ],
  );
}

String Presentations()
{
  SQL sql = SQL();
  final Future<List<String>> _listStr = sql.ListWidget();
  print("lskdjfa;sidljfasidj");
  FutureBuilder<List<String>>(
    future: _listStr,
    builder: (BuildContext Context, AsyncSnapshot<List<String>> snapshot) {
      List<String> children;
      if (snapshot.hasData) {
        print("Snapshot = ${snapshot.data}");
        if (snapshot.data == "Register") {
          isAuth = true;
        }
        children = <String>[
        ];
      } else if (snapshot.hasError) {
        print("Snapshot = ${snapshot.data}");
        children = <String>[
        ];
      } else {
        print("Snapshot = ${snapshot.data}");
        children = const <String>[
        ];
      }
      return Container(
        padding: const EdgeInsets.all(10),
        child: Wrap(
          spacing: 10,
          children: [

          ],
        ),
      );
    }
  );
  return "s'dfksdf";
}

class MyHomePage2 extends StatefulWidget {
  MyHomePage2({Key? key}) : super(key: key); // changed

  @override
  _MyHomePageState2 createState() => _MyHomePageState2();
}

class _MyHomePageState2 extends State<MyHomePage2> {
  int _counter = 0;
  Offset _offset = Offset.zero; // changed

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform(  // Transform widget
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // perspective
          ..rotateX(0.01 * _offset.dy) // changed
          ..rotateY(-0.01 * _offset.dx), // changed
        alignment: FractionalOffset.center,
        child: GestureDetector( // new
          onPanUpdate: (details) => setState(() => _offset += details.delta),
          onDoubleTap: () => setState(() => _offset = Offset.zero),
          child: _defaultApp(context),
        )
    );
  }

  _defaultApp(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Matrix 3D'), // changed
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              // style: Theme.of(context).textTheme.display1,
            ),
            MyHomePage2(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

}

class _TextMenuButton extends StatelessWidget {
  const _TextMenuButton(BuildContext? context, {Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return Column(
      children: [
        const SizedBox(height: 10,),
        ElevatedButton(
          onPressed: () {
          },
          child: const Text("Заглоовок"),
        ),
        const SizedBox(height: 10,),
        ElevatedButton(
          onPressed: () {},
          child: const Text("Основной текст"),
        ),
        const SizedBox(height: 10,),
        ElevatedButton(
          onPressed: () {},
          child: const Text("Список"),
        ),
      ],
    );
  }
}



class SecondRoute1 extends StatelessWidget {
  SecondRoute1(String name) : nameUp = name;
  String nameUp;

  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void _showSimpleDialog() {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Переименовать викторину'),
              children: <Widget>[
                ProgectName(myController),
                Container(
                  height: 60.0,
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color(0xFF89EC6A),
                                      Color(0xFF96e853),
                                      Color(0xFF32CD32),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(16.0),
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                print("cancel");
                                Navigator.pop(context, ClipRRect);
                              },
                              child: const Text('Отмена'),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color(0xFF0D47A1),
                                      Color(0xFF1976D2),
                                      Color(0xFF42A5F5),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(16.0),
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                // SQL sql = SQL();
                                // sql.presentRename(nameUp, myController.text);
                                print("email => $email,nameUp => $nameUp, newName => ${myController.text.toString()},");
                                request.renamePresent(email, nameUp, myController.text.toString());

                                nameUp = myController.text;
                                Navigator.pop(context, ClipRRect);
                                // print("myController.text = ${myController.text}");
                                // final Future<void> _listStr =  sql.CreatePresent(myController.text);
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => SecondRoute1(myController.text)),
                                // );
                                // setStates();
                              },
                              child: const Text('Переименовать'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ],
            );
          }
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('$nameUp'),
        actions: [
          Row(
            children: [
              const Text(
                "Переименовать",
                style: TextStyle(
                  color: Colors.white60,
                  fontWeight: FontWeight.bold, fontSize: 18,),
              ),
              RawMaterialButton(
                enableFeedback: false,
                fillColor: Colors.lightGreen,
                shape: const CircleBorder(),
                onPressed: () {
                  // print("s;ldkfj;");
                  // SQL sql = SQL();
                  // sql.presentRename(name,'hehe');
                  // request.renamePresent(email, nameUpdate, newName);
                  _showSimpleDialog();
                },
                child: const Icon(
                  Icons.refresh, size: 25,
                  color: Colors.white60
                ),
              ),
              const Text(
                "Сохранить",
                style: TextStyle(
                  color: Colors.white60,
                  fontWeight: FontWeight.bold, fontSize: 18,),
              ),
              RawMaterialButton(
                enableFeedback: false,
                fillColor: Colors.lightGreen,
                shape: const CircleBorder(),
                onPressed: () {
                  print("s;ldkfj;");

                },
                child: const Icon(
                    Icons.save, size: 25,
                    color: Colors.white60
                ),
              ),
            ],
          )
        ],
      ),
      body: const NavRailDemo(),
    );
  }
}

class secondRoute extends StatefulWidget {

  @override
  State<secondRoute> createState() => _secondRouteState('');
}

class _secondRouteState extends State<secondRoute> {
  _secondRouteState(String name) : name = name;
  String name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$name'),
        actions: [
          Row(
            children: [
              const Text(
                "Переименовать",
                style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18,),
              ),
              RawMaterialButton(
                enableFeedback: false,
                fillColor: Colors.lightGreen,
                shape: new CircleBorder(),
                onPressed: () {
                  SQL sql = SQL();
                },
                child: const Icon(Icons.refresh, size: 25,),
              ),
            ],
          )
        ],
      ),
      body: const NavRailDemo(),
    );
  }
}

class ToggleButtonsSample extends StatefulWidget {
  const ToggleButtonsSample({super.key});
  @override
  State<ToggleButtonsSample> createState() => _ToggleButtonsSampleState();
}

class _ToggleButtonsSampleState extends State<ToggleButtonsSample> {
  final List<bool> _selectedWeather = <bool>[true, false, false, false];

  @override
  Widget build(BuildContext context) {
    // final ThemeData theme = Theme.of(context);
    const List<Widget> icons = <Widget>[
      Icon(Icons.sunny),
      Icon(Icons.cloud),
      Icon(Icons.ac_unit),Icon(Icons.ac_unit),
    ];
    return ToggleButtons(
      direction: Axis.vertical,
      onPressed: (int index) {
        setState(() {
          // The button that is tapped is set to true, and the others to false.
          for (int i = 0; i < _selectedWeather.length; i++) {
            _selectedWeather[i] = i == index;
          }
        });
      },
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      // selectedBorderColor: Colors.grey[200],
      selectedColor: Colors.white,
      fillColor: Colors.white10,
      color: Colors.grey[400],
      isSelected: _selectedWeather,
      children: [
        Column(
          children: [
            const Icon(Icons.sunny,),
            const Text("Слайды")
          ],
        ),
        Column(
          children: [
            const Icon(Icons.sunny,),
            const Text("Текст")
          ],
        ),
        Column(
          children: [
            const Icon(Icons.sunny,),
            const Text("Медиа")
          ],
        ),
        Column(
          children: [
            const Icon(Icons.sunny,),
            const Text("Слайды")
          ],
        ),
      ],
    );
  }
}

Widget popapMenu(bool isAuthorized, BuildContext context)
{
  print("ISCONN = ${isAuthorized}");
  if (isAuthorized)
  {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      onSelected: (String item){
      },
      itemBuilder: (context) => const <PopupMenuEntry<String>>[
        PopupMenuDivider(),
        PopupMenuItem<String>(
          value: "pref",
          child: Text(
              "Настройки"
          ),
        ),
        PopupMenuItem<String>(
          value: "exit",
          child: Text(
            "Выход",
          ),
        ),
      ],
    );
  }
  return PopupMenuButton<String>(
    padding: EdgeInsets.zero,
    onSelected: (String item) => {
      showDialog(
        context: context,
        builder: (BuildContext context) => const AlertDialog(
          backgroundColor: Colors.transparent,
          content: Join(),
        )
      ),
      print("$item"),
    },
    itemBuilder: (context) => const <PopupMenuEntry<String>>[
      PopupMenuDivider(),
      PopupMenuItem<String>(
        value: "ууа",
        child: Text(
            "Настройки"
        ),
      ),
      PopupMenuItem<String>(
        value: "auth",
        child: Text(
          "Авторизоваться",
        ),
      ),
    ],
  );
}


Widget join(){
  return const Join();
}

class Join extends StatefulWidget {
  const Join({Key? key}) : super(key: key);

  @override
  State<Join> createState() => _JoinState();
}

class _JoinState extends State<Join> {
  final myControllerEmail = TextEditingController();
  final myControllerPass = TextEditingController();
  SQL sql = SQL();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerEmail.dispose();
    myControllerPass.dispose();
    super.dispose();
  }
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 20,),
      width: 600,
      height: 200,
      child:  Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,

        // spacing: 0,
        children: [
          // MyCustomForm(),
          Container(
            width: 800,
            height: 270,
            padding: const EdgeInsets.all(20),
            // color: Colors.black,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              border: Border.all(
                width: 4,
                color: Colors.grey,
              ),
            ),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: myControllerEmail,
                        restorationId: 'life_story_field',
                        textInputAction: TextInputAction.next,
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Пожалуйста введите почту';
                          }
                          return null;
                        },
                        // focusNode: _lifeStory,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "andrey@example.com",
                          // helperText: "название вашего iziQuizi",
                          labelText: "Email",
                        ),
                        maxLines: 1,
                      ),

                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                // PasswordForm(),
                PasswordField(
                  myControllerPass: myControllerPass,
                  restorationId: 'password_field',
                  textInputAction: TextInputAction.next,
                  // focusNode: _password,
                  // fieldKey: _passwordFieldKey,
                  // helperText: localizations.demoTextFieldNoMoreThan,
                  // labelText: localizations.demoTextFieldPassword,
                  onFieldSubmitted: (value) {
                    setState(() {
                      // person.password = value;
                      // _retypePassword.requestFocus();
                    });
                  },
                ),
                const SizedBox(height: 10,),
                Align(
                  alignment: Alignment.centerRight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Row(
                      children: <Widget>[
                        const Spacer(),
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color(0xFF0D47A1),
                                  Color(0xFF1976D2),
                                  Color(0xFF42A5F5),
                                ],
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16.0),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate())
                            {
                              print("Validateeee");
                            };
                            final Future<String> _calculation = sql.Register(myControllerEmail.text.toString(), myControllerPass.text.toString());
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog
                                  (
                                    content: FutureBuilder<String>(
                                      future: _calculation,
                                      builder: (BuildContext Context, AsyncSnapshot<String> snapshot) {
                                        List<Widget> children;
                                        if (snapshot.hasData) {
                                          // setState(() { isAuth = true; });

                                          // isAuth = true;
                                          // print("isAuth = $isAuth");
                                          if (snapshot.data == "Register")
                                          {
                                            isAuth = true;
                                          }

                                          children = <Widget>[
                                            const Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.green,
                                              size: 60,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 16),
                                              child: Text('Result: ${snapshot.data}'),
                                            ),
                                          ];
                                        } else if (snapshot.hasError) {
                                          children = <Widget>[
                                            const Icon(
                                              Icons.error_outline,
                                              color: Colors.red,
                                              size: 60,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 16),
                                              child: Text('Error: ${snapshot.error}'),
                                            ),
                                          ];
                                        } else {
                                          children = const <Widget>[
                                            SizedBox(
                                              width: 60,
                                              height: 60,
                                              child: CircularProgressIndicator(),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 16),
                                              child: Text('Awaiting result...'),
                                            ),
                                          ];
                                        }
                                        return Center(
                                          // heightFactor: MediaQuery.of(context).size.height+500,
                                          child: Column(

                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: children,
                                          ),
                                        );
                                      },
                                    )
                                );
                              },
                            );

                          },
                          child: const Text('Зарегистрироваться'),
                        ),
                        const SizedBox(width: 10,),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16.0),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {

                            if (_formKey.currentState!.validate())
                            {
                              print("Validate");
                            };
                            // SqlQuery();
                            // final Future<String> _calculation = sql.MySql(myControllerEmail.text.toString(), myControllerPass.text.toString());
                            email = myControllerEmail.text.toString();

                            request.authentication(email, myControllerPass.text.toString());
                            // final Future<String> _calculation = sql.authentication(email, myControllerPass.text.toString());

                            // SQL().authentication(myControllerEmail.text.toString(), myControllerPass.text.toString());
                            // String mess = await MySql(myControllerEmail.text.toString(), myControllerPass.text.toString());
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog
                                  (
                                  content: FutureBuilder<String>(
                                    // future: _calculation,
                                    builder: (BuildContext Context, AsyncSnapshot<String> snapshot) {
                                      List<Widget> children;
                                      if (snapshot.hasData) {
                                        // setState(() { isAuth = true; });

                                        // isAuth = true;
                                        // print("isAuth = $isAuth");
                                        if (snapshot.data != "authErr")
                                        {
                                          isAuth = true;
                                        }

                                        children = <Widget>[
                                          const Icon(
                                            Icons.check_circle_outline,
                                            color: Colors.green,
                                            size: 60,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 16),
                                            child: Text('Result: ${snapshot.data}'),
                                          ),
                                        ];
                                      } else if (snapshot.hasError) {
                                        children = <Widget>[
                                          const Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                            size: 60,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 16),
                                            child: Text('Error: ${snapshot.error}'),
                                          ),
                                        ];
                                      } else {
                                        children = const <Widget>[
                                          SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: CircularProgressIndicator(),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 16),
                                            child: Text('Awaiting result...'),
                                          ),
                                        ];
                                      }
                                      return Center(
                                        // heightFactor: MediaQuery.of(context).size.height+500,
                                        child: Column(

                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: children,
                                        ),
                                      );
                                    },
                                  )
                                  // // QuerySql(),
                                );
                              },
                            );
                          },
                          child: const Text('Войти'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}


class PasswordForm extends StatefulWidget {
  // const PasswordForm({
  //   super.key,
  //   this.myControllerPass,
  // });
  const PasswordForm({Key? key}) : super(key: key);
  // TextEditingController myControllerPass;
  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  // final RestorableBool _obscureText = RestorableBool(true);
  @override
  Widget build(BuildContext context) {
    bool _obscureText = false;
    return TextFormField(
      // controller: myControllerPass,
      restorationId: 'password_text_field',
      textInputAction: TextInputAction.next,
      // obscureText: _obscureText.value,
      obscureText: _obscureText,
      maxLength: 16,
      // onSaved: widget.onSaved,
      // validator: widget.validator,
      // onFieldSubmitted: widget.onFieldSubmitted,

      // obscureText: true,
      // focusNode: _lifeStory,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        filled: true,
        // hintText: "1234",
        // helperText: "название вашего iziQuizi",
        labelText: "Password",
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              // _obscureText.value = !_obscureText.value;
              print(_obscureText);
              _obscureText = !_obscureText;
            });
          },
          hoverColor: Colors.transparent,
          icon: Icon(
            // Icons.visibility,sdf
            // _obscureText.value ? Icons.visibility : Icons.visibility_off,
            _obscureText ? Icons.visibility : Icons.visibility_off,

            // semanticLabel: _obscureText.value
            //     ? GalleryLocalizations.of(context)!
            //     .demoTextFieldShowPasswordLabel
            //     : GalleryLocalizations.of(context)!
            //     .demoTextFieldHidePasswordLabel,
          ),
        ),
      ),
      maxLines: 1,
    );
  }
}



class TabBarEvents extends StatefulWidget {
  const TabBarEvents({Key? key}) : super(key: key);

  @override
  State<TabBarEvents> createState() => _TabBarEventsState();
}

class _TabBarEventsState extends State<TabBarEvents>
    with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return
      Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              unselectedLabelColor: Colors.teal,
              labelColor: Colors.lightBlue,
              indicatorColor: Colors.teal,
              controller: _tabController,
              tabs: const <Widget>[
                Tab(text: 'Текущие'),
                Tab(text: 'Завершенные'),
                Tab(text: 'Созданные'),
              ],
            ),
          ),
          // SizedBox(width: 400,),
          Container(
            color: Colors.grey[200],
            // padding: const EdgeInsets.only(left: 20),
            height: MediaQuery.of(context).size.height-104,
            // height: 400,
            width: double.maxFinite,
            child: TabBarView(
              controller: _tabController,
              children: [
                current(context),
                currentList(context),
                created(context),
              ]
            ),
          ),
        ],
      );
  }
}

ListView currentList(BuildContext context)
{
  return ListView(
    children: [
      Container(
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1),
        height: 1000,
        color: Colors.teal,
      ),

    ],
  );
}

Container current(BuildContext context)
{
  return Container(
    margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1),
    height: 1000,
    color: Colors.teal,
    child: ListView(
      children: [
        Container(
          height: 1000,
        )
      ],
    ),
  );
}

Container created(BuildContext context)
{
  return Container(
    margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1),
    // height: 1000,
    // color: Colors.teal,
    child: ListView(
      padding: const EdgeInsets.all(10),
      children: [
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff7c94b6),
                image: const DecorationImage(
                  image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                  fit: BoxFit.cover,
                ),
                // border: Border.all(
                //   width: 2,
                // ),
                borderRadius: BorderRadius.circular(15),
              ),
              // color: Colors.teal[300],
              height: 200,
              width: 200,
            ),
            Container(
              color: Colors.teal[300],
              height: 400,
              width: 400,
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff7c94b6),
                image: const DecorationImage(
                  image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                  fit: BoxFit.cover,
                ),
                // border: Border.all(
                //   width: 2,
                // ),
                borderRadius: BorderRadius.circular(15),
              ),
              // color: Colors.teal[300],
              height: 200,
              width: 200,
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff7c94b6),
                image: const DecorationImage(
                  image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                  fit: BoxFit.cover,
                ),
                // border: Border.all(
                //   width: 2,
                // ),
                borderRadius: BorderRadius.circular(15),
              ),
              // color: Colors.teal[300],
              height: 200,
              width: 200,
            ),
            Container(
              color: Colors.teal[300],
              height: 400,
              width: 400,
            ),
            Container(
              color: Colors.teal[300],
              height: 400,
              width: 400,
            ),
            Container(
              color: Colors.teal[300],
              height: 400,
              width: 400,
            ),
          ],
        ),
      ],
    ),
  );
}


Widget m = Row(
  children: const [
    Icon(Icons.home),
    Text("Дом"),
  ],
);

Widget section = Container(
  width: 320,
  height: 240,
  color: Colors.grey[300],
  child: Center(
    child: Container(
      // red box
      width: 240,
      // max-width is 240
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[400],
      ),
      child: const Text(
          'Lorem ipsum',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          )
      ),
    ),
  ),
);

class ParentWidget extends StatefulWidget {
  const ParentWidget({Key? key}) : super(key: key);

  @override
  State<ParentWidget> createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  bool _active = false;

  void _handleTapBoxChanged(bool newValue) {
    setState((){
      _active = newValue;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TapBoxC(
        active:_active,
        onChanged: _handleTapBoxChanged,
      ),
    );
  }
}

class TapBoxC extends StatefulWidget {
  const TapBoxC({
    super.key,
    this.active = false,
    required this.onChanged,
  });

  final bool active;
  final ValueChanged<bool> onChanged;

  @override
  State<TapBoxC> createState() => _TapBoxCState();
}

class _TapBoxCState extends State<TapBoxC> {
  bool _highlight = false;

  void _handleTapDown(TapDownDetails details){
    setState(() {
      _highlight = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTap() {
    widget.onChanged(!widget.active);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTap: _handleTap,
        onTapCancel: _handleTapCancel,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
              color: widget.active ? Colors.lightGreenAccent : Colors.grey,
              border: _highlight
                  ? Border.all(
                color: Colors.teal[700]!,
                width: 10.0,
              )
                  : null
          ),
          child: Center(
            child: Text(widget.active ? "Active" : "Inactive",
              style: const TextStyle(
                fontSize: 32.0,
                color: Colors.white,
              ),
            ),
          ),
        )
    );
  }
}










class PasswordField extends StatefulWidget {
  const PasswordField({
    Key? key,
    this.restorationId,
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.focusNode,
    this.textInputAction,
    this.myControllerPass,
  }) : super(key: key);

  final String? restorationId;
  final Key? fieldKey;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextEditingController? myControllerPass;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> with RestorationMixin {
  final RestorableBool _obscureText = RestorableBool(true);

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_obscureText, 'obscure_text');
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.myControllerPass,
      key: widget.fieldKey,
      restorationId: 'password_text_field',
      obscureText: _obscureText.value,
      maxLength: 18,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureText.value = !_obscureText.value;
            });
          },
          hoverColor: Colors.transparent,
          icon: Icon(
            _obscureText.value ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TextFormField(
          //   // The validator receives the text that the user has entered.
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter some ';
          //     }
          //     return null;
          //   },
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 16.0),
          //   child: ElevatedButton(
          //     onPressed: () {
          //       // Validate returns true if the form is valid, or false otherwise.
          //       if (_formKey.currentState!.validate()) {
          //         // // If the form is valid, display a snackbar. In the real world,
          //         // // you'd often call a server or save the information in a database.
          //         // ScaffoldMessenger.of(context).showSnackBar(
          //         //   const SnackBar(content: Text('Processing Data')),
          //         // );
          //       }
          //     },
          //     child: const Text('Submit'),
          //   ),
          // ),
        ],
      ),
    );
  }
}

typedef void IntCallback(int id);

class NavRailDemo extends ConsumerStatefulWidget {
  const NavRailDemo({Key? key}) : super(key: key);

  @override
  _NavRailDemoState createState() => _NavRailDemoState();
}


LISTSLIDE _listSlide = LISTSLIDE();

class _NavRailDemoState extends ConsumerState<NavRailDemo> with RestorationMixin {
  final RestorableInt _selectedIndex = RestorableInt(0);
  final RestorableInt _selectidIndex2 = RestorableInt(0);

  @override
  String get restorationId => 'nav_rail_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedIndex, 'selected_index');
  }

  @override
  void dispose() {
    _selectedIndex.dispose();
    super.dispose();
  }

  Future<void> _pickFile(StateController<int> __fileProvidere) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: "Выберите изображение или gif",
      type: FileType.image,
      // allowedExtensions: ['jpg','gif','jpeg'],
    );

    if (result != null) {
      PlatformFile file = result.files.single;

      print(file.path);
      File _file = File(file.path!);
      __fileProvidere.state = -4;
      print("${__fileProvidere.state}");
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    // StateController<File> __fileProvidere = ref.watch(fileProvider.notifier);
    StateController<int> __numAddItem = ref.watch(numAddItem.notifier);

    // final localization = GalleryLocalizations.of(context)!;
    // final destinationFirst = localization.demoNavigationRailFirst;
    // final destinationSecond = localization.demoNavigationRailSecond;
    // final destinationThird = localization.demoNavigationRailThird;
    final textMenu = <Widget>[
      ElevatedButtonFactory.numAddItem(
        numAddObj: 1,
        onPressed: (){
        },
        child: Row(children: [const Text('Заголовок',)], mainAxisAlignment: MainAxisAlignment.center,),
      ),
      ElevatedButtonFactory.numAddItem(
        numAddObj: 2,
        onPressed: (){

        },
        child: const Text('Основной текст'),
      ),
      ElevatedButtonFactory.numAddItem(
        numAddObj: 3,
        onPressed: (){

        },
        child: const Text('Список'),
      ),
    ];
    final mediaMenu = <Widget>[
      ElevatedButtonFactory.numAddItem(
        numAddObj: -4,
        onPressed: ()=> {
          showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Вставьте изображение или gif'),
            content: const Text('AlertDialog description'),
            actions: <Widget>[
              TextButton(
                onPressed: () => {
                  Navigator.pop(context, 'Cancel'),
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => {
                  __numAddItem.state = -4,
                  // FutureBuilder<void>(
                  //   future: _pickFile(__fileProvidere), // a previously-obtained Future<String> or null
                  //   builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  //     List<Widget> children;
                  //     if (snapshot.hasData) {
                  //       children = <Widget>[
                  //
                  //       ];
                  //     } else if (snapshot.hasError) {
                  //       children = <Widget>[
                  //         const Icon(
                  //           Icons.error_outline,
                  //           color: Colors.red,
                  //           size: 60,
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.only(top: 16),
                  //           child: Text('Error: ${snapshot.error}'),
                  //         ),
                  //       ];
                  //     } else {
                  //       children = const <Widget>[
                  //         SizedBox(
                  //           width: 60,
                  //           height: 60,
                  //           child: CircularProgressIndicator(),
                  //         ),
                  //         Padding(
                  //           padding: EdgeInsets.only(top: 16),
                  //           child: Text('Awaiting result...'),
                  //         ),
                  //       ];
                  //     }
                  //     return Center(
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: children,
                  //       ),
                  //     );
                  //   },
                  // ),
                  // _pickFile(__numAddItem),
                  Navigator.pop(context, 'OK')
                },
                child: const Text('OK'),
              ),
            ],
          ),
        ),
        },
        child: const Text('Изображения'),
      ),
      ElevatedButtonFactory.numAddItem(
        numAddObj: 5,
        onPressed: (){

        },
        child: const Text('Видео'),
      ),
      ElevatedButtonFactory.numAddItem(
        numAddObj: 6,
        onPressed: (){

        },
        child: const Text('Звук'),
      ),
    ];
    final figureMenu = <Widget>[
      ElevatedButtonFactory.numAddItem(
        numAddObj: 7,
        onPressed: (){

        },
        child: const Text('Фигуры'),
      ),
      ElevatedButtonFactory.numAddItem(
        numAddObj: 8,
        onPressed: (){

        },
        child: const Text('Указатели'),
      ),
    ];
    final tableMenu = <Widget>[
      ElevatedButtonFactory.numAddItem(
        numAddObj: 9,
        onPressed: (){

        },
        child: const Text('Строки'),
      ),
      ElevatedButtonFactory.numAddItem(
        numAddObj: 10,
        onPressed: (){

        },
        child: const Text('Столбцы'),
      ),
    ];
    final selectWidget = [
      textMenu,
      mediaMenu,
      figureMenu,
      tableMenu,
    ];
    // final selectWidget = <Widget>[
    //   Text("hill"),
    //   Text("hill1"),
    //   Text("hill2"),
    //   Text("hill3"),
    //   _TextMenuButton(context),
    //   // _MediaMenButton(),
    //   _TextMenuButton(context),
    //   _TextMenuButton(context),
    //   _TextMenuButton(context),
    // ];
    double scale = 0.5;
    Offset _offset = Offset.zero;

    int index = 0;
    final selectMenu = <Widget>[
      const MyStateful(),
      // _MediaMenuButton(),
      _TextMenuButton(context),
    ];

    @override
    void reload(double SetScale)
    {
      setState(() {
        index = 1;
      });
      print(index);
    }

    PresentationCreationArea PresentArea = PresentationCreationArea.hi(0);
    Widget mediaButton(int indx){
      return MediaMenuButton(indx);
    }

    ListSlide listSlide = ListSlide();
    return Scaffold(
      body: Container(
        color: Colors.green[50],
        child: Row(
          children: <Widget>[
            NavigationRail(
              backgroundColor: Colors.green[300],
              indicatorColor: Colors.green[600],
              // leading: FloatingActionButton(
              //   onPressed: () {},
              //   child: const Icon(Icons.add),
              // ),
              selectedIndex: _selectedIndex.value,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex.value = index;
                });
                print("INDEX = $index");
              },
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(
                    Icons.favorite_border,
                  ),
                  selectedIcon: Icon(
                    Icons.favorite,
                  ),
                  label: Text(
                    "Слайды",
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.favorite_border,
                  ),
                  selectedIcon: Icon(
                    Icons.favorite,
                  ),
                  label: Text(
                    "Текст",
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.bookmark_border,
                  ),
                  selectedIcon: Icon(
                    Icons.book,
                  ),
                  label: Text(
                    "Медиа",
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.star_border,
                  ),
                  selectedIcon: Icon(
                    Icons.star,
                  ),
                  label: Text(
                    "Фигуры",
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.favorite_border,
                  ),
                  selectedIcon: Icon(
                    Icons.favorite,
                  ),
                  label: Text(
                    "Таблицы",
                  ),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1, color: Colors.grey),
            Container(
              clipBehavior: Clip.none,
              width: 160,
              color: Colors.green[200],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _selectedIndex.value != 0
                    ? Column(children: selectWidget[_selectedIndex.value == 0 ? 0 : --_selectedIndex.value],)
                    : _listSlide.slide(),
              ),
            ),
            const Expanded(
              child: ParentWidget4(),
            ),
          ],
        ),
      ),
    );
  }
}

class ListSlide extends ConsumerStatefulWidget {
  ListSlide({Key? key}) : super(key: key);

  @override
  _ListSlideState createState() => _ListSlideState();
}

Present present = Present();
class _ListSlideState extends ConsumerState<ListSlide> {
  List<Widget> slide = [];
  bool i = true;

  void del(){
    slide.clear();
    i = !i;
    slide += present.getSlide();
    present.setSlide(slide);
    print("slide.length=> ${slide.length}");
  }

  @override
  Widget build(BuildContext context) {
    StateController<int> _counterSlide = ref.watch(counterSlide.notifier);
    final _DelItemId = ref.watch(delItemId);

    if(_DelItemId != null){

    }
    present.delItem(_DelItemId);
    del();

    return Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(),
              clipBehavior: Clip.hardEdge,
              padding: const EdgeInsets.only(top: 3),
              child: ListView(
                clipBehavior: Clip.none,
                children: i == true ? present.getSlide() : slide,
                // children: _counterSlideUpd == 1 || true ? present.getSlide() : present.getSlide(),
              ),
            ),
          ),
          const SizedBox(height: 7,),
          ElevatedButtonFactory(
            onPressed: (){
              // present.addSlide(
              //   Container(
              //     margin: EdgeInsets.symmetric(horizontal: 4),
              //     child: Column(
              //       children: [
              //         NavigationSlideMenuButton.buttonID(ButtonID: _counterSlide.state),
              //         const SizedBox(height: 7,),
              //       ],
              //     ),
              //   ),
              // );
              // ++_counterSlide.state;
              // print("ElevatedButtonFactory=>${_counterSlide.state}");
              slide.clear();
              setState(() {
                i = !i;
                slide += present.getSlide();
                Key key = UniqueKey();
                // slide = present.getSlide();
                slide.add(
                    Container(
                      key: key,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        children: [
                          NavigationSlideMenuButton.buttonID(ButtonID: _counterSlide.state, key: key,),
                          const SizedBox(height: 7,),
                        ],
                      ),
                    ));
                present.setSlide(slide);
                ++_counterSlide.state;
                print("ElevatedButtonFactory=>${_counterSlide.state}");
              });
            },
            child: const Text('Добавить'),
          ),
        ]
    );
  }
}

class LISTSLIDE {
  ListSlide list = ListSlide();
  Widget slide(){
    return list;
  }
}

class Present {

  int _numSlide = 1;
  List<Widget> listSlide = [];

  addSlide(Widget slide){
    ++_numSlide;
    listSlide.add(slide);
  }

  List<Widget> getSlide(){
    return listSlide;
  }

  void setSlide(List<Widget> list){
    listSlide.clear();
    listSlide += list;
  }
  void delItem(Key delItemId){
    // print("listItems.length => ${listItems.length}");
    // print("delItemId => ${delItemId}");

    // for (int i = 0; i < listItems.length; ++i){
    //   print("listItems[$i].key => ${listItems[i].key}");
    //   print("listItems.elementAt($i) => ${listItems.elementAt(i)}");
    // }

    print ("delItemId=> ${delItemId}");
    listSlide.retainWhere((item) => item.key != delItemId);

    // print("listItems.removeAt(${delItemId}) => ${listItems.removeAt(delItemId)}");
  }
}

class ElevatedButtonFactory extends ConsumerWidget {
  ElevatedButtonFactory ({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  // ElevatedButtonFactory.buttonID({
  //   Key? key,
  //   required this.buttonId,
  //   required this.onPressed,
  //   required this.child,
  // }) : super(key: key);

  ElevatedButtonFactory.numAddItem ({
    Key? key,
    required this.numAddObj,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  int buttonId = -1;
  int numAddObj = -1;
  void Function()? onPressed;
  Widget child = const Text('null');




  @override
  Widget build(BuildContext context, WidgetRef ref) {
    StateController<int> _numAddItem = ref.watch(numAddItem.notifier);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: ElevatedButton(
        style: ButtonStyle(
          alignment: Alignment.center,
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 5)),
        ),
        onPressed: (buttonId < 0 && numAddObj < 0)
            ? onPressed
            : (){
                _numAddItem.state = -1;
                _numAddItem.state = numAddObj;
                print("numAddObj=> ${numAddObj}, ${buttonId}");
              },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[child],),
      ),
    );
  }
}

class ParentWidget4 extends StatefulWidget {
  const ParentWidget4({super.key});

  @override
  State<ParentWidget4> createState() => _ParentWidgetState4();
}

class _ParentWidgetState4 extends State<ParentWidget4> {
  int _active = 5;

  void _handleTapboxChanged(int newValue) {
    setState(() {
      print(newValue);
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TapboxB(
        active: _active,
        onChanged: _handleTapboxChanged,
      ),
    );
  }
}

//------------------------- TapboxB ----------------------------------

class TapboxB extends ConsumerWidget {
  TapboxB({
    super.key,
    this.active = 10,
    required this.onChanged,
  });

  int active;
  final ValueChanged<int> onChanged;

  void _handleTap() {
    onChanged(active);
  }
  // PresentationCreationArea _area = PresentationCreationArea.hi(0);

  PresentationCreationArea __area = PresentationCreationArea();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // _area.Area(),
        // __area,
        __area,
      ],
    );
  }
}

class Column_ {
  col(){

  }
}

class MediaMenuButton extends StatefulWidget {
  MediaMenuButton(int num) : num = num;
  int num;

  @override
  State<MediaMenuButton> createState() => _MediaMenuButtonState(num);
}

class _MediaMenuButtonState extends State<MediaMenuButton> {
  _MediaMenuButtonState(int num) : num = num;
  int num;
  final PresentationCreationArea _area = PresentationCreationArea.hi(0);
  @override
  Widget build(BuildContext context) {
    print("NUM = $num");
    return Container(
      width: 200,
      color: Colors.black54,
      child: Container(
        child:  Wrap(
          direction: Axis.vertical,
          spacing: 10.0,
          runSpacing: 10.0,
          children: <Widget>[
          Column(
            children: [
              const SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _area.addWidget(0);
                  });
                },
                child: const Text("Добавить изображение"),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () {

                },
                child: const Text("Добавить видео"),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () {

                },
                child: const Text("Добавить аудио"),
              ),
            ],
          ),

            // Container(
            //   width: 200,
            //   color: Colors.black54,
            //   child: Container(
            //     child: selectWidget[_selectedIndex.value],
            //   ),
            // ),
          Wrap(
            children: [
              Container(
                width: 100,
                height: 100,
                color: Colors.yellow,
              ),
              _area.Area(),
            ],
          ),
          // PresentArea.sideMenu(0),
          // PresentArea.Area(),
          ]
        ),
      ),
    );
  }
}



Column _Column(List<Widget> wg){
  return Column(
    children: wg,
  );
}

Row _Row(List<Widget> wg){
  return Row(
    children: wg,
  );
}

class JoinThePresentation extends StatelessWidget {
  JoinThePresentation({Key? key}) : super(key: key);

  final List<Widget> _list = <Widget>[
    Expanded(
      child: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Введите код присоединения',
        ),
      ),
    ),
    const SizedBox(width: 15, height: 15,),
    OutlinedButton.icon(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 23.0, horizontal:10),
        ),
        backgroundColor: MaterialStateProperty.all(
          Colors.green.shade300,
        ),
        side: MaterialStateProperty.all(const BorderSide(
          color: Colors.transparent,
        ),),
        shape: MaterialStateProperty.all( RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),),
      ),
      icon: const Icon(Icons.add, size: 18, color: Colors.white,),
      label: const Text(
        'Присоедениться',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () {
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      // color: Colors.black,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: LayoutBuilder(
        builder:
        (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < 470){
            return Container(
              height: 120,
             child: _Column(_list),
            );
          } else {
            return _Row(_list);
          }
        }
      ),
    );
  }
}