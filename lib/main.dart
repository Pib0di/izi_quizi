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
import 'package:izi_quizi/Widgets/PresentationCard.dart';
// import 'package:mysql1/mysql1.dart';
// import 'Screen/ViewPresentation.dart';
import 'FactoryСlasses/SideSlides.dart';
import 'Screen/Edit/PresentationEdit.dart';
import 'Screen/SingleView/ViewPresentation.dart';
import 'Widgets/Join.dart';
import 'jsonParse.dart';
import 'FactoryСlasses/AppData.dart';
import 'slide.dart';
import 'server.dart';
import 'dart:async';
import 'dart:io';


// - - - - - - - - - - - - - SOCKET - - - - - - - - - -

import 'dart:async' show Timer;
import 'dart:convert';

// - - - - - - - - - - - - - SOCKET - - - - - - - - - - DELETE


import 'dart:async';

import 'package:file_picker/file_picker.dart';


// - - - - - - - - - - - - - SOCKET - - - - - - - - - - DELETE
SocketConnection _socketConnection = SocketConnection();
Request request = Request(_socketConnection);
ParseMessege parseMessege = ParseMessege();
bool widgetListIsReload = false;

// - - - - - - - - - - - - - - - - - - - - - - - - - - -
String idUser = '1';
String email = '';
String presentName = '';
String deletePresent = '';
List<dynamic?> listStr = ['hi'];
Map<String, String> userPresent = {};

AppData appData = AppData();

// - PROVIDER - - - - - - - - - - - - - - - - - - - - - - - - - -
/// не нужон
final counterProvider = StateProvider((ref) => 0);

/// номер текущего слайда
final buttonID = StateProvider((ref) => 0);
final slideNumState = StateProvider((ref) => 0);

/// количество созданных слайдов
final counterSlide = StateProvider((ref) => 0);

/// NumAddItem - номер добавляемого элемента
/// 0 - Заголовок;
/// 1 - Основной текст;
final numAddItem = StateProvider((ref) => 0);

/// номер выбранного элемента в слайде
final ItemId = StateProvider((ref) => 0);

/// номер элемента в слайде для удаления
const Key key = Key("");
final delItemId = StateProvider<Key>(
      (ref) => key,
);

/// локальный путь до фотографии
final File file = File("");
final fileProvider = StateProvider<File>(
      (ref) => file,
);

/// StateProvider<bool> authorization success
final isAuthorized2 = StateNotifierProvider((ref) {
  return Counter();
});

class Counter extends StateNotifier<int> {
  Counter(): super(0);

  void increment() => state++;
}

final container = ProviderContainer();

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
  });
  // _socketConnection.sendMessage('data');

  runApp(
    const ProviderScope(
      child: MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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
class MyStateful extends ConsumerStatefulWidget {
  const MyStateful({super.key});

  @override
  MyStatefulState createState() => MyStatefulState();
}

class MyStatefulState extends ConsumerState<MyStateful> {
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



class MyStatefulWidget extends ConsumerStatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  MyStatefulWidgetState createState() => MyStatefulWidgetState();
}

class MyStatefulWidgetState extends ConsumerState<MyStatefulWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  get isAuthorizedd => null;

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
  final myController = TextEditingController();
  @override
  void setStates()
  {
    setState(() {
      request.listWidget(idUser);
      if (widgetListIsReload){
        widgetListIsReload = false;
      }
      else{
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    appData.widgetRef(ref);
    bool _isAuth = ref.watch(appData.authStateProvider());

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
                SizedBox(
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
                          request.createPresent(idUser, myController.text);
                          presentName = myController.text;
                          // final Future<void> _listStr =  sql.CreatePresent(myController.text);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PresentationEdit.create(myController.text)),
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
                    children: const [
                      Icon(Icons.home),
                      SizedBox(width:5),
                      Text("Дом"),
                    ],
                  ),
                ),
                if (_isAuth)(
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.av_timer),
                          SizedBox(width:5),
                          Text("Мероприятия"),
                        ],
                      ),
                    )),
                if (_isAuth)
                  (Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.people),
                        SizedBox(width:5),
                        Text("Комнаты"),
                      ],
                    ),
                  ))
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
                "Создать",
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
                "Просмотр",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewPresentation()),
                );
              },
            ),
          ),
          popapMenu(context),
        ],
      ),

      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          FutureBuilder<List<String>>(
              builder: (BuildContext Context, AsyncSnapshot<List<String>> snapshot) {
                List<Widget> childrenn = <Widget>[];
                for(int i = 0; i < appData.getUserPresentName().length; ++i)
                {
                  childrenn.add(PresentCard(
                      idPresent:  int.parse(appData.getUserPresentName().keys.elementAt(i)).toInt(),
                      presentName: appData.getUserPresentName().values.elementAt(i),
                  ));
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
          // Join(),
          FutureBuilder<String>(
            builder: (BuildContext Context, AsyncSnapshot<String> snapshot) {
              List<Widget> children;
                if (_isAuth) {
                  return const TabBarEvents();
                }
              return Center(
                // heightFactor: MediaQuery.of(context).size.height+500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:const [ TabBarEvents()],
                ),
              );
            },
          ),
          FutureBuilder<String>(
            future: isAuthorizedd,
            builder: (BuildContext Context, AsyncSnapshot<String> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                if (_isAuth) {
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
                if (_isAuth) {
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
  FutureBuilder<List<String>>(
    builder: (BuildContext Context, AsyncSnapshot<List<String>> snapshot) {
      List<String> children;
      if (snapshot.hasData) {
        print("Snapshot = ${snapshot.data}");
        if (snapshot.data == "Register") {
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
          children: const [

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
          children: const [
            Icon(Icons.sunny,),
            Text("Слайды")
          ],
        ),
        Column(
          children: const [
            Icon(Icons.sunny,),
            Text("Текст")
          ],
        ),
        Column(
          children: const [
            Icon(Icons.sunny,),
            Text("Медиа")
          ],
        ),
        Column(
          children: const [
            Icon(Icons.sunny,),
            Text("Слайды")
          ],
        ),
      ],
    );
  }
}




Widget popapMenu(BuildContext context)
{
  bool _isAuth = appData.authStateController().state;

  if (_isAuth)
  {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      onSelected: (String item){
        if (item == "exit"){
          appData.authStateController().state = false;
        }
      },
      itemBuilder: (context) => const <PopupMenuEntry<String>>[
        PopupMenuDivider(),
        PopupMenuItem<String>(
          value: "pref",
          child: Text("Настройки"),
        ),
        PopupMenuItem<String>(
          value: "exit",
          child: Text("Выход",),
        ),
      ],
    );
  }
  return PopupMenuButton<String>(
    padding: EdgeInsets.zero,
    onSelected: (String item) => {
      if (item == "auth"){

      },
      showDialog(
        context: context,
        builder: (BuildContext context) => const AlertDialog(
          backgroundColor: Colors.transparent,
          content: Join(),
        )
      ),
    },
    itemBuilder: (context) => const <PopupMenuEntry<String>>[
      PopupMenuDivider(),
      PopupMenuItem<String>(
        value: "settings",
        child: Text("Настройки"),
      ),
      PopupMenuItem<String>(
        value: "auth",
        child: Text("Авторизоваться",),
      ),
    ],
  );
}


// Widget Join(){
//   return const Join();
// }



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
        children: const [
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
        __area,
      ],
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
            return SizedBox(
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