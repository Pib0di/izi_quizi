
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/jsonParse.dart';

import '../../FactoryСlasses/SideSlides.dart';
import '../../main.dart';

class PresentationEdit extends StatelessWidget {
  PresentationEdit.create(String name, {super.key}) : nameUp = name;
  PresentationEdit.edit(String name, {super.key}) : nameUp = name;
  late final String nameUp;

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
                ProgectName(myController),
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
                                print("email => $email,nameUp => $nameUp, newName => ${myController.text.toString()},");
                                request.renamePresent(email, nameUp, myController.text.toString());

                                nameUp = myController.text;
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
          }
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(nameUp),
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
                  showSimpleDialog();
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
                  var jsonSlide = SlideJson().slideJson();
                  print(jsonEncode(jsonSlide.toJson()));

                  request.setSlideData(idUser, presentName, jsonEncode(jsonSlide.toJson()));
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


class NavRailDemo extends ConsumerStatefulWidget {
  const NavRailDemo({Key? key}) : super(key: key);

  @override
  _NavRailDemoState createState() => _NavRailDemoState();
}

class _NavRailDemoState extends ConsumerState<NavRailDemo> with RestorationMixin {
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

  Future<void> _pickFile(StateController<int> __fileProvidere) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: "Выберите изображение или gif",
      type: FileType.image,
      // allowedExtensions: ['jpg','gif','jpeg'],
    );

    if (result != null) {
      PlatformFile file = result.files.single;

      print(file.path);
      File file_ = File(file.path!);
      __fileProvidere.state = -4;
      print("${__fileProvidere.state}");
    } else {
      // User canceled the picker
    }
  }
  late ListSlide listSlide;
  @override
  Widget build(BuildContext context) {
    // StateController<File> __fileProvidere = ref.watch(fileProvider.notifier);
    StateController<int> __numAddItem = ref.watch(numAddItem.notifier);
    final countSlideUpd = ref.watch(counterSlide);


    // final localization = GalleryLocalizations.of(context)!;
    // final destinationFirst = localization.demoNavigationRailFirst;
    // final destinationSecond = localization.demoNavigationRailSecond;
    // final destinationThird = localization.demoNavigationRailThird;
    final textMenu = <Widget>[
      ElevatedButtonFactory.numAddItem(
        numAddObj: 1,
        onPressed: (){
        },
        child: Row(children: const [Text('Заголовок',)], mainAxisAlignment: MainAxisAlignment.center,),
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
    double scale = 0.5;
    Offset _offset = Offset.zero;

    listSlide = ListSlide();


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
                    : listSlide,
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

