import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/local/multiple_view_data.dart';
import 'package:izi_quizi/data/repository/server/server_data.dart';
import 'package:izi_quizi/presentation/home_page/home_page_screen.dart';

Request request = Request();
AppDataState appData = AppDataState();
MultipleViewData multipleViewData = MultipleViewData();

// - PROVIDER - - - - - - - - - - - - - - - - - - - - - - - - - -
/// локальный путь до фотографии
final File file = File('');
final fileProvider = StateProvider<File>(
  (ref) => file,
);

void main() async {
  await AppDataState().checkMobileMode();

  SocketConnection.getConnection().stream.listen(ParseMessageImpl().parse);

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
