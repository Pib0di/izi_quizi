import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/local/multiple_view_data.dart';
import 'package:izi_quizi/data/repository/server/server_data.dart';
import 'package:izi_quizi/presentation/home_page/home_page_screen.dart';

AppDataState appData = AppDataState();
MultipleViewData multipleViewData = MultipleViewData();

// - PROVIDER - - - - - - - - - - - - - - - - - - - - - - - - - -
/// локальный путь до фотографии
// final File file = File('');
// final fileProvider = StateProvider<File>(
//   (ref) => file,
// );

void main() async {
  webSocketProvider;
  // SocketConnection.getConnection().stream.listen(ParseMessage().parse);

  runApp(
    const ProviderScope(child: MyApp()),
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
        body: HomePage(),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   late AudioPlayer player;
//   late AudioPlayer player2;
//
//   @override
//   void initState() {
//     super.initState();
//     player = AudioPlayer();
//     player2 = AudioPlayer();
//   }
//
//   @override
//   void dispose() {
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: () async {
//                   await player.setAsset('assets/audio/moo.mp3');
//                   // final url =
//                   //     'https://www.applesaucekids.com/sound%20effects/moo.mp3';
//                   // await player.setUrl(url);
//                   player.play();
//                 },
//                 child: Text('Cow'),
//               ),
//               SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: () async {
//                   await player2.setAsset('assets/audio/moo.mp3');
//                   // final url =
//                   //     'https://www.applesaucekids.com/sound%20effects/horse_whinney_2.mp3';
//                   // await player2.setUrl(url);
//                   player2.play();
//                   player.dispose();
//                   player2.dispose();
//                 },
//                 child: Text('Horse'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
