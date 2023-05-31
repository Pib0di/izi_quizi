import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/domain/create_editing_case.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/common/presentation_creation_tab.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/common/sidebar.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/create_editing_state.dart';
import 'package:izi_quizi/utils/theme.dart';
import 'package:izi_quizi/widgets/buttonFactory.dart';

class CreatingEditingArea extends ConsumerStatefulWidget {
  const CreatingEditingArea({super.key});

  @override
  CreatingEditingAreaState createState() => CreatingEditingAreaState();
}

class CreatingEditingAreaState extends ConsumerState<CreatingEditingArea> {
  late CreateEditingCase createEditingController;
  late SideSlidesPreview slidesPreviewController;
  late List<List<Widget>> selectWidget;

  @override
  void initState() {
    createEditingController = ref.read(createEditingCaseProvider.notifier);
    slidesPreviewController = ref.read(slidesPreviewProvider.notifier);

    selectWidget = [
      textMenu(createEditingController),
      mediaMenu(context, createEditingController),
      figureMenu(createEditingController),
      tableMenu(createEditingController),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(slidesPreviewProvider);
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.secondaryContainer,
        // color: Colors.green[50],
        child: Row(
          children: <Widget>[
            NavigationRail(
              backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
              // indicatorColor: Colors.green[600],
              selectedIndex: slidesPreviewController.selectedIndex,
              onDestinationSelected: (index) {
                slidesPreviewController
                  ..selectedIndex = index
                  ..updateUi();
              },
              labelType: NavigationRailLabelType.all,
              destinations: navigationRailDestination,
            ),
            const VerticalDivider(),
            // VerticalDivider(
            //   thickness: 1,
            //   width: 1,
            //   color: Theme.of(context).colorScheme.outline,
            // ),
            Container(
              // color: Theme.of(context).colorScheme.secondaryContainer,
              color: Theme.of(context).colorScheme.secondaryContainer,
              clipBehavior: Clip.none,
              width: 190,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: slidesPreviewController.selectedIndex != 0
                    ? Column(
                        children: selectWidget[
                            slidesPreviewController.selectedIndex == 0
                                ? 0
                                : --slidesPreviewController.selectedIndex],
                      )
                    : const SlidesPreview(),
              ),
            ),
            const VerticalDivider(),
            const PresentationCreationArea()
          ],
        ),
      ),
    );
  }
}

List<NavigationRailDestination> navigationRailDestination = [
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
      color: colorScheme.onError,
    ),
    selectedIcon: Icon(
      Icons.favorite,
      color: colorScheme.onError,
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

List<Widget> mediaMenu(
    BuildContext context, CreateEditingCase createEditingController) {
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
                child: Text('отмена'),
              ),
              ConsumerTextButton.showDialog(
                closeAfterClicking: false,
                addedItem: 'image',
                id: -4,
                child: Text('загрузить'),
              ),
            ],
          ),
        )
      },
      child: const Text('Изображения'),
    ),
    ElevatedButtonFactory.numAddItem(
      onPressed: () => createEditingController.addItem('video'),
      child: const Text('Видео'),
    ),
    ElevatedButtonFactory.numAddItem(
      onPressed: () => createEditingController.addItem('sound'),
      child: const Text('Звук'),
    ),
  ];
}

List<Widget> textMenu(CreateEditingCase createEditingController) {
  return <Widget>[
    ElevatedButtonFactory.numAddItem(
      onPressed: () => createEditingController.addItem('heading'),
      child: const Text('Заголовок'),
    ),
    ElevatedButtonFactory.numAddItem(
      onPressed: () => createEditingController.addItem('mainText'),
      child: const Text('Основной текст'),
    ),
    ElevatedButtonFactory.numAddItem(
      onPressed: () => createEditingController.addItem('list'),
      child: const Text('Список'),
    ),
  ];
}

List<Widget> figureMenu(CreateEditingCase createEditingController) {
  return <Widget>[
    ElevatedButtonFactory.numAddItem(
      onPressed: () => createEditingController.addItem('shape'),
      child: const Text('Фигуры'),
    ),
    ElevatedButtonFactory.numAddItem(
      onPressed: () => createEditingController.addItem('pointers'),
      child: const Text('Указатели'),
    ),
  ];
}

List<Widget> tableMenu(CreateEditingCase createEditingController) {
  return <Widget>[
    ElevatedButtonFactory.numAddItem(
      onPressed: () => createEditingController.addItem('row'),
      child: const Text('Строки'),
    ),
    ElevatedButtonFactory.numAddItem(
      onPressed: () => createEditingController.addItem('column'),
      child: const Text('Столбцы'),
    ),
  ];
}

// todo maybe change the logic
// final textMenu = buttons(
//   {'heading': 'Заголовок', 'mainText': 'Основной текст', 'list': 'Список'},
// );
// final figureMenu = buttons(
//   {'shape': 'Фигуры', 'pointers': 'Указатели'},
// );
//
// final tableMenu = buttons(
//   {'row': 'Строки', 'column': 'Столбцы'},
// );
//
// List<Widget> buttons(Map<String, String> mapParam) {
//   final list = <Widget>[];
//   mapParam.forEach((key, value) {
//     list.add(
//       ElevatedButtonFactory.numAddItem(
//         onPressed: () => CreateEditingCase().addItem(key),
//         child: Text(value),
//       ),
//     );
//   });
//   return list;
// }

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
//     // File file_ = File(file.path!);
//     fileProvidere.state = -4;
//   } else {
//     // User canceled the picker
//   }
// }
