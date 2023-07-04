import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/presentation/home_page/home_page_screen.dart';
import 'package:izi_quizi/utils/theme.dart';

AppDataState appData = AppDataState();

// - PROVIDER - - - - - - - - - - - - - - - - - - - - - - - - - -
/// локальный путь до фотографии
// final File file = File('');
// final fileProvider = StateProvider<File>(
//   (ref) => file,
// );

void main() async {
  // Timer? timer;
  // timer = Timer.periodic(const Duration(seconds: 1), (_) {
  //   final socket = SocketConnection.channel;
  //   if (socket.closeCode == null) {
  //     print('WebSocket подключен');
  //   } else {
  //     print('WebSocket закрыт с кодом: ${socket.closeCode}');
  //     final socket2 = SocketConnection.channel;
  //   }
  // });
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
      theme: basicTheme(),
      // theme: ThemeData(
      //   useMaterial3: true,
      //   primarySwatch: Colors.green,
      // ),
      home: const Scaffold(
        body: HomePage(),
      ),
    );
  }
}
