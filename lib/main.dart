import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/server/server_data_impl.dart';
import 'package:izi_quizi/domain/multipe_view/multiple_view_data.dart';
import 'package:izi_quizi/presentation/home_page/home_page_screen.dart';

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
const Key key = Key('');
final delItemId = StateProvider<Key>(
  (ref) => key,
);

/// локальный путь до фотографии
final File file = File('');
final fileProvider = StateProvider<File>(
  (ref) => file,
);

// final container = ProviderContainer();

void main() async {
  await appData.checkMobileBrowser();

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
        body: MyStatefulWidget(),
      ),
    );
  }
}
