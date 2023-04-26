import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/domain/creating_editing_presentation/create_editing.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/common/presentation_creation_area.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/common/side_slides.dart';
import 'package:izi_quizi/widgets/buttonFactory.dart';

class CreatingEditingArea extends ConsumerStatefulWidget {
  const CreatingEditingArea({super.key});

  @override
  CreatingEditingAreaState createState() => CreatingEditingAreaState();
}

class CreatingEditingAreaState extends ConsumerState<CreatingEditingArea>
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

  late ListSlide listSlide;

  @override
  Widget build(BuildContext context) {
    CreateEditingCase().getRef(ref);
    ref.watch(counterSlide);

    // ref.watch(createEditing.notifier).context = context;

    listSlide = const ListSlide();

    final selectWidget = [
      textMenu,
      mediaMenu(context),
      figureMenu,
      tableMenu,
    ];

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
              destinations: navigationRailDestination,
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
            const PresentationCreationArea()
          ],
        ),
      ),
    );
  }
}

List<NavigationRailDestination> navigationRailDestination = const [
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
];

List<Widget> mediaMenu(BuildContext context) {
  return <Widget>[
    ElevatedButtonFactory.numAddItem(
      onPressed: () => {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => const AlertDialog(
            title: Text('Вставьте изображение или gif'),
            content: Text('AlertDialog description'),
            actions: <Widget>[
              ConsumerTextButton.showDialog(
                closeAfterClicking: true,
                child: Text('Cancel'),
              ),
              ConsumerTextButton.showDialog(
                closeAfterClicking: true,
                addedItem: 'image',
                id: -4,
                // child: Text('OK'),
                child: Text('OK'),
              ),
            ],
          ),
        )
      },
      child: const Text('Изображения'),
    ),
    ElevatedButtonFactory.numAddItem(
      onPressed: () => CreateEditingCase().addItem('video'),
      child: const Text('Видео'),
    ),
    ElevatedButtonFactory.numAddItem(
      onPressed: () => CreateEditingCase().addItem('sound'),
      child: const Text('Звук'),
    ),
  ];
}

final textMenu = buttons(
  {'heading': 'Заголовок', 'mainText': 'Основной текст', 'list': 'Список'},
);
final figureMenu = buttons(
  {'shape': 'Фигуры', 'pointers': 'Указатели'},
);

final tableMenu = buttons(
  {'row': 'Строки', 'column': 'Столбцы'},
);

List<Widget> buttons(Map<String, String> mapParam) {
  final list = <Widget>[];
  mapParam.forEach((key, value) {
    list.add(
      ElevatedButtonFactory.numAddItem(
        onPressed: () => CreateEditingCase().addItem(key),
        child: Text(value),
      ),
    );
  });
  return list;
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
