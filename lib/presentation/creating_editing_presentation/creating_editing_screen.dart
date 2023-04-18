import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/common_functionality/jsonParse.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/local/side_slides.dart';
import 'package:izi_quizi/data/repository/local/widgets/slide.dart';
import 'package:izi_quizi/data/repository/local/widgets/widgets_collection.dart';
import 'package:izi_quizi/domain/creating_editing_presentation/create_editing_impl.dart';
import 'package:izi_quizi/main.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/create_editing_state.dart';
import 'package:screenshot/screenshot.dart';

CreateEditingImpl createEditingImpl = CreateEditingImpl();

class PresentationEdit extends StatelessWidget {
  PresentationEdit.create(String name, {super.key}) : currentNamePresent = name;

  PresentationEdit.edit(String name, {super.key}) : currentNamePresent = name;
  late final String currentNamePresent;

  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void showSimpleDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Переименовать викторину'),
            children: <Widget>[
              ProjectName(myController),
              SizedBox(
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
                              createEditingImpl.renameQuiz(
                                AppData.email,
                                AppData.presentName,
                                myController.text,
                              );
                              currentNamePresent = myController.text;
                              Navigator.pop(context, ClipRRect);
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
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(currentNamePresent),
        actions: [
          Row(
            children: [
              const Text(
                'Переименовать',
                style: TextStyle(
                  color: Colors.white60,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              RawMaterialButton(
                enableFeedback: false,
                fillColor: Colors.lightGreen,
                shape: const CircleBorder(),
                onPressed: showSimpleDialog,
                child:
                    const Icon(Icons.refresh, size: 25, color: Colors.white60),
              ),
              const Text(
                'Сохранить',
                style: TextStyle(
                  color: Colors.white60,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              RawMaterialButton(
                enableFeedback: false,
                fillColor: Colors.lightGreen,
                shape: const CircleBorder(),
                onPressed: () {
                  final jsonSlide = SlideJson().slideJson();
                  createEditingImpl.saveQuiz(
                    AppData.idUser,
                    AppData.presentName,
                    jsonEncode(jsonSlide.toJson()),
                  );
                },
                child: const Icon(Icons.save, size: 25, color: Colors.white60),
              ),
            ],
          )
        ],
      ),
      body: const NavRailDemo(),
    );
  }
}

class NavRailDemo extends ConsumerStatefulWidget {
  const NavRailDemo({super.key});

  @override
  NavRailDemoState createState() => NavRailDemoState();
}

class NavRailDemoState extends ConsumerState<NavRailDemo>
    with RestorationMixin {
  final RestorableInt _selectedIndex = RestorableInt(0);

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

  // todo implement image selection on pc
  // Future<void> _pickFile(StateController<int> fileProvidere) async {
  //   final result = await FilePicker.platform.pickFiles(
  //     dialogTitle: 'Выберите изображение или gif',
  //     type: FileType.image,
  //     // allowedExtensions: ['jpg','gif','jpeg'],
  //   );
  //
  //   if (result != null) {
  //     final file = result.files.single;
  //
  //     // File file_ = File(file.path!);
  //     fileProvidere.state = -4;
  //   } else {
  //     // User canceled the picker
  //   }
  // }

  late ListSlide listSlide;

  @override
  Widget build(BuildContext context) {
    createEditingImpl.getRef(ref);

    // StateController<File> __fileProvidere = ref.watch(fileProvider.notifier);
    // StateController<int> __numAddItem = ref.watch(numAddItem.notifier);

    final slideCounter = ref.watch(numAddItem.notifier);

    ref.watch(counterSlide);

    final textMenu = <Widget>[
      ElevatedButtonFactory.numAddItem(
        onPressed: () => createEditingImpl.addItem('heading'),
        child: const Text('Заголовок'),
      ),
      ElevatedButtonFactory.numAddItem(
        onPressed: () => createEditingImpl.addItem('mainText'),
        child: const Text('Основной текст'),
      ),
      ElevatedButtonFactory.numAddItem(
        onPressed: () => createEditingImpl.addItem('list'),
        child: const Text('Список'),
      ),
    ];
    final mediaMenu = <Widget>[
      ElevatedButtonFactory.numAddItem(
        onPressed: () => {
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
                    createEditingImpl.addItem('image'),
                    slideCounter.set(-4),
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
        onPressed: () => createEditingImpl.addItem('video'),
        child: const Text('Видео'),
      ),
      ElevatedButtonFactory.numAddItem(
        onPressed: () => createEditingImpl.addItem('sound'),
        child: const Text('Звук'),
      ),
    ];
    final figureMenu = <Widget>[
      ElevatedButtonFactory.numAddItem(
        onPressed: () => createEditingImpl.addItem('shape'),
        child: const Text('Фигуры'),
      ),
      ElevatedButtonFactory.numAddItem(
        onPressed: () => createEditingImpl.addItem('pointers'),
        child: const Text('Указатели'),
      ),
    ];
    final tableMenu = <Widget>[
      ElevatedButtonFactory.numAddItem(
        onPressed: () => createEditingImpl.addItem('row'),
        child: const Text('Строки'),
      ),
      ElevatedButtonFactory.numAddItem(
        onPressed: () => createEditingImpl.addItem('column'),
        child: const Text('Столбцы'),
      ),
    ];
    final selectWidget = [
      textMenu,
      mediaMenu,
      figureMenu,
      tableMenu,
    ];

    listSlide = const ListSlide();

    return Scaffold(
      body: Container(
        color: Colors.green[50],
        child: Row(
          children: <Widget>[
            NavigationRail(
              backgroundColor: Colors.green[300],
              indicatorColor: Colors.green[600],
              selectedIndex: _selectedIndex.value,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex.value = index;
                });
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
                    'Слайды',
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
                    'Текст',
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
                    'Медиа',
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
                    'Фигуры',
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
                    'Таблицы',
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
                    ? Column(
                        children: selectWidget[_selectedIndex.value == 0
                            ? 0
                            : --_selectedIndex.value],
                      )
                    : listSlide,
              ),
            ),
            Expanded(
              child: Screenshot(
                controller: sideSlides.screenshotController,
                child: const Expanded(
                  child: PresentationViewport(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PresentationViewport extends StatefulWidget {
  const PresentationViewport({super.key});

  @override
  State<PresentationViewport> createState() => PresentationViewportState();
}

class PresentationViewportState extends State<PresentationViewport> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          PresentationCreationArea(),
        ],
      ),
    );
  }
}

class ElevatedButtonFactory extends StatelessWidget {
  const ElevatedButtonFactory.numAddItem({
    required this.onPressed,
    required this.child,
    super.key,
  });

  final void Function()? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: ElevatedButton(
        style: ButtonStyle(
          alignment: Alignment.center,
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 5),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[child],
        ),
      ),
    );
  }
}
