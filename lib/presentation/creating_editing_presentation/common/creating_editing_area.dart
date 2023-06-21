import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/domain/create_editing_case.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/common/presentation_creation_tab.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/common/sidebar.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/create_editing_state.dart';
import 'package:izi_quizi/utils/theme.dart';
import 'package:izi_quizi/widgets/buttonFactory.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
              destinations:
              getNavRailDestination(slidesPreviewController.selectedIndex),
            ),
            // const VerticalDivider(),
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
              padding: const EdgeInsets.all(8.0),
              child: slidesPreviewController.selectedIndex != 0
                  ? Column(
                      children: selectWidget[
                          slidesPreviewController.selectedIndex == 0
                              ? 0
                              : slidesPreviewController.selectedIndex - 1],
                    )
                  : const SlidesPreview(),
            ),
            const VerticalDivider(),
            const PresentationCreationArea()
          ],
        ),
      ),
    );
  }
}

Color colorIcon = colorScheme.onPrimary;
// Color colorIcon = Color(0xE570FF00);
Color colorSelectedIcon = const Color(0xE500FFE1);
Color colorText = colorIcon;

List<NavigationRailDestination> getNavRailDestination(int selectedIndex) {
  return [
    NavigationRailDestination(
      icon: Icon(
        MdiIcons.presentation,
        color: colorIcon,
      ),
      selectedIcon: Icon(
        MdiIcons.presentation,
        color: colorSelectedIcon,
      ),
      label: Text(
        'Слайды',
        style: TextStyle(
          color: selectedIndex == 0 ? colorSelectedIcon : colorIcon,
        ),
      ),
    ),
    NavigationRailDestination(
      icon: Icon(
        Icons.text_fields,
        color: colorIcon,
      ),
      selectedIcon: Icon(
        Icons.text_fields_outlined,
        color: colorSelectedIcon,
      ),
      label: Text(
        'Текст',
        style: TextStyle(
          color: selectedIndex == 1 ? colorSelectedIcon : colorIcon,
        ),
      ),
    ),
    NavigationRailDestination(
      icon: Icon(
        Icons.perm_media,
        color: colorIcon,
      ),
      selectedIcon: Icon(
        Icons.perm_media_outlined,
        color: colorSelectedIcon,
      ),
      label: Text(
        'Медиа',
        style: TextStyle(
          color: selectedIndex == 2 ? colorSelectedIcon : colorIcon,
        ),
      ),
    ),
    NavigationRailDestination(
      icon: Icon(
        Icons.interests,
        color: colorIcon,
      ),
      selectedIcon: Icon(
        Icons.interests_outlined,
        color: colorSelectedIcon,
      ),
      label: Text(
        'Фигуры',
        style: TextStyle(
          color: selectedIndex == 3 ? colorSelectedIcon : colorIcon,
        ),
      ),
    ),
    NavigationRailDestination(
      icon: Icon(
        Icons.view_comfortable_sharp,
        color: colorIcon,
      ),
      selectedIcon: Icon(
        Icons.view_comfortable_outlined,
        color: colorSelectedIcon,
      ),
      label: Text(
        'Таблицы',
        style: TextStyle(
          color: selectedIndex == 4 ? colorSelectedIcon : colorIcon,
        ),
      ),
    ),
  ];
}

List<Widget> mediaMenu(BuildContext context,
    CreateEditingCase createEditingController,
) {
  return <Widget>[
    ElevatedButtonFactory.numAddItem(
      onPressed: () => {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Вставьте изображение или gif'),
            content: IntrinsicHeight(
              child: Column(
                children: [
                  Form(
                    child: TextFormField(
                      onChanged: (value) {
                        // createEditingController.updateUi();
                      },
                      controller: createEditingController.urlTextController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'https://animal/cat.jpg',
                        labelText: 'URL',
                      ),
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        // image: NetworkImage(createEditingController.urlTextController.text ?? ''),
                        // image: CachedNetworkImageProvider(url ?? ''),
                        image: CachedNetworkImageProvider(
                            createEditingController.urlTextController.text ??
                                ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ConsumerTextButton.showDialog(
                closeAfterClicking: true,
                child: const Text('отмена'),
              ),
              ConsumerTextButton.showDialog(
                closeAfterClicking: false,
                addedItem: 'image',
                child: const Text('проводник'),
              ),
              if (true)
                ConsumerTextButton.showDialog(
                  closeAfterClicking: false,
                  addedItem: 'image',
                  id: -4,
                  child: const Text('вставить'),
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
      child: const Text('Заголовок',
          style: TextStyle(
            fontSize: 20,
          )),
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
