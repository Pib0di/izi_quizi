import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'domain/multipe_view/multiple_view_data.dart';
import 'presentation/screen/home_page_screen.dart';
import 'data/repository/local/app_data.dart';
import 'data/repository/server/impl/server_data_impl.dart';
import 'dart:io';

RequestImpl request = RequestImpl();
bool widgetListIsReload = false;

AppData appData = AppData();
MultipleViewData multipleViewData = MultipleViewData();

// - PROVIDER - - - - - - - - - - - - - - - - - - - - - - - - - -
/// номер текущего слайда
final buttonID = StateProvider((ref) => 0);

/// количество созданных слайдов
final counterSlide = StateProvider((ref) => 0);

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

// final container = ProviderContainer();

void main() {
  ParseMessageImpl parseMessageImpl = ParseMessageImpl();
  SocketConnection.getConnection().stream.listen((event) {
    print("event => $event");
    parseMessageImpl.parse(event);
  });

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
        body: MyStatefulWidget(),
      ),
    );
  }
}
