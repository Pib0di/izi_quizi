import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/data/repository/local/slide_items.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/create_editing_state.dart';
import 'package:izi_quizi/widgets/button_delete.dart';
import 'package:izi_quizi/widgets/selection_slide/selection_slide.dart';
import 'package:screenshot/screenshot.dart';

class SlidesPreview extends ConsumerWidget {
  const SlidesPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(slidesPreviewProvider);

    final slidesPreviewController = ref.read(slidesPreviewProvider.notifier);
    final slideDataController = ref.read(slideDataProvider.notifier);

    final delId = ref.watch(delItemKey);
    slidesPreviewController.delItem(delId);

    return Column(
      children: [
        if (slidesPreviewController.slideSelection) const SlideMenu(),
        if (!slidesPreviewController.slideSelection)
          Expanded(
            child: ListView.builder(
              itemCount: slidesPreviewController.getLengthSideList(),
              itemBuilder: (BuildContext context, int index) {
                return slidesPreviewController.getSlide()[index];
              },
            ),
          ),
        const SizedBox(
          height: 7,
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                slidesPreviewController
                  ..slideSelection = !slidesPreviewController.slideSelection
                  ..updateUi();
              },
              child: const Icon(
                Icons.menu,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                  alignment: Alignment.center,
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 5),
                  ),
                ),
                onPressed: () {
                  slidesPreviewController.addItem();
                  slideDataController.addListSlide(SlideItems());

                  slidesPreviewController.updateUi();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[Text('Добавить')],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class SidebarItem extends ConsumerWidget {
  SidebarItem.buttonID({required this.buttonId, required this.keyDelete})
      : super(key: key);

  void setButtonId(int id) {
    buttonId = id;
  }

  void setImagePreview(Uint8List? capturedImage) {
    imageFile = capturedImage!;
  }

  final Key keyDelete;
  Uint8List imageFile = Uint8List(0);
  int buttonId = -10;

  double width = 0;
  double widthBorder = 0;

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
      ..watch(slidesPreviewProvider)
      ..watch(currentSlideNumber);

    final counter = ref.read(currentSlideNumber.notifier);
    final slidesPreviewController = ref.read(slidesPreviewProvider.notifier);

    final buttonDelete = ButtonDelete.deleteItemId(keyDelete, key: UniqueKey());

    width = counter.state == buttonId ? 3 : 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          MouseRegion(
            onEnter: (e) {
              slidesPreviewController.updateUi();
            },
            onExit: (e) {
              slidesPreviewController.updateUi();
            },
            child: Stack(
              children: [
                IntrinsicHeight(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      height: 100,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xff18540d),
                          strokeAlign: BorderSide.strokeAlignOutside,
                          width:
                              counter.state == buttonId ? width : widthBorder,
                        ),
                        // color: const Color(0xff84b67c),
                        color: Colors.transparent,
                        // image: DecorationImage(
                        //   image: MemoryImage(imageFile),
                        //   fit: BoxFit.cover,
                        // ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          if (imageFile.length > 10)
                            FadeInImage(
                              placeholder:
                                  const AssetImage('image/loading.png'),
                              image: MemoryImage(imageFile),
                              fit: BoxFit.contain,
                              fadeInDuration: const Duration(milliseconds: 300),
                              fadeOutDuration:
                                  const Duration(milliseconds: 300),
                            ),
                          ElevatedButton(
                            onHover: (val) {
                              slidesPreviewController.updateImage();
                              if (val) {
                                widthBorder = 3;
                              } else {
                                widthBorder = 0;
                              }
                              slidesPreviewController.updateUi();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(),
                              shadowColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.only(bottom: 10),
                            ),
                            onPressed: () {
                              counter.state = buttonId;
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xE5DFFFD6),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                    '$buttonId',
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                if (counter.state == buttonId) buttonDelete,
              ],
            ),
          ),
          const SizedBox(
            height: 7,
          )
        ],
      ),
    );
  }
}

class SlideMenu extends ConsumerWidget {
  const SlideMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    slideMenuItems = getSlideMenuItems(ref);

    return Expanded(
      child: ListView(
        children: [
          const Text('Тип слайда'),
          const SizedBox(
            height: 10,
          ),
          IntrinsicHeight(
            child: Wrap(
              children: [
                ExpandedButtonFactory(
                  onPressed: () {
                    !ref.read(slidesPreviewProvider.notifier).slideSelection;
                  },
                  icon: Icons.menu,
                  tooltip: 'Выбор правильного ответа',
                  text: 'Выбор',
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text('Тип вопроса'),
          const SizedBox(
            height: 10,
          ),
          IntrinsicHeight(
            child: Column(
              children: slideMenuList(),
              // children: [
              //   Row(
              //     children: [
              //       const SizedBox(
              //         width: 8,
              //       ),
              //       ExpandedButtonFactory(
              //         onPressed: () {
              //           !ref
              //               .read(slidesPreviewProvider.notifier)
              //               .slideSelection;
              //         },
              //         icon: Icons.menu,
              //         tooltip: 'Выбор правильного ответа',
              //         text: 'Выбор',
              //       ),
              //     ],
              //   ),
              // ],
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> slideMenuList() {
  final list = <Widget>[];
  var length = slideMenuItems.length;
  if (slideMenuItems.length % 2 != 0) {
    --length;
  }
  for (var i = 0; i < length; i += 2) {
    list.add(
      Column(
        children: [
          Row(
            children: [
              slideMenuItems[i],
              const SizedBox(
                width: 4,
              ),
              slideMenuItems[i + 1],
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );

    if (i + 2 >= length && slideMenuItems.length % 2 != 0) {
      list.add(
        Column(
          children: [
            Row(
              children: [
                slideMenuItems[i + 2],
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
      break;
    }
  }

  return list;
}

List<ExpandedButtonFactory> slideMenuItems = [];

List<ExpandedButtonFactory> getSlideMenuItems(WidgetRef ref) {
  final slidesPreviewController = ref.read(slidesPreviewProvider.notifier);
  final slideDataController = ref.read(slideDataProvider.notifier);

  return slideMenuItems = [
    ExpandedButtonFactory(
      onPressed: () {
        slidesPreviewController.addItem();
        slideDataController.addListSlideWidget(const SelectionSlide());
      },
      icon: Icons.check_box_outlined,
      tooltip: 'Выбор правильного ответа',
      text: 'Выбор',
    ),
    ExpandedButtonFactory(
      onPressed: () {},
      icon: Icons.rectangle_outlined,
      tooltip: 'Заполнить бланк',
      text: 'Заполнить',
    ),
    ExpandedButtonFactory(
      onPressed: () {},
      icon: Icons.featured_play_list_outlined,
      tooltip: 'Свободный ответ',
      text: 'Свободный',
    ),
    ExpandedButtonFactory(
      onPressed: () {},
      icon: Icons.auto_graph_outlined,
      tooltip: '',
      text: 'Опрос',
    ),
    ExpandedButtonFactory(
      onPressed: () {},
      icon: Icons.create_outlined,
      tooltip: '',
      text: 'Рисовать',
    ),
    ExpandedButtonFactory(
      onPressed: () {},
      icon: Icons.play_circle_outline_outlined,
      tooltip: '',
      text: 'Видеоответ',
    ),
    ExpandedButtonFactory(
      onPressed: () {},
      icon: Icons.audiotrack_outlined,
      tooltip: 'Записать аудио',
      text: 'Аудиоответ',
    ),
    ExpandedButtonFactory(
      onPressed: () {},
      icon: Icons.front_hand_outlined,
      tooltip: '',
      text: 'Перетащить',
    ),
  ];
}

class ExpandedButtonFactory extends ConsumerWidget {
  const ExpandedButtonFactory({
    required this.onPressed,
    required this.icon,
    required this.tooltip,
    required this.text,
    super.key,
  });

  final void Function()? onPressed;
  final IconData? icon;
  final String? tooltip;
  final String? text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Tooltip(
        message: tooltip,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Column(
            children: [
              Icon(icon),
              if (text != null) Text(text!),
            ],
          ),
        ),
      ),
    );
  }
}
