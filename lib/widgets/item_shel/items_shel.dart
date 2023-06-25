// ignore_for_file: directives_ordering, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/widgets/button_delete.dart';
import 'package:izi_quizi/widgets/item_shel/item_shel_state.dart';

/// the number of the selected element in the slidez

class ItemsShel extends ConsumerStatefulWidget {
  ItemsShel.id(Key key, this.itemCount) : super(key: key) {
    type = 'text';
  }

  ItemsShel.imageWidget(Key key, this.widgetInit) : super(key: key) {
    type = 'imageWidget';
  }

  ItemsShel.imageWidgetJson({
    super.key,
    this.url = '',
    this.width = 300,
    this.height = 200,
    this.left = 800,
    this.top = 400,
  }) {
    type = 'image';
  }

  ItemsShel.textWidgetJson({
    super.key,
    this.text = '',
    this.width = 300,
    this.height = 200,
    this.left = 800,
    this.top = 400,
  }) {
    type = 'text';
  }

  String type = 'standard';

  ItemsShelDataText itemsShelDataText = ItemsShelDataText();
  ItemsShelDataText? getItemsShelDataText() {
    itemsShelDataText
      ..type = type
      ..offsetX = left
      ..offsetY = top
      ..width = width
      ..height = height
      ..text = controller.value.text;
    if (type == 'text') {
      return itemsShelDataText;
    }
    return null;
  }

  ItemsShelDataImage itemsShelDataImage = ItemsShelDataImage();
  ItemsShelDataImage? getItemsShelDataImage() {
    itemsShelDataImage
      ..type = type
      ..offsetX = left
      ..offsetY = top
      ..width = width
      ..height = height
      ..url = url;
    // todo url implementation
    // itemsShelDataImage.url = _controller.value.text;
    if (type == 'image') {
      return itemsShelDataImage;
    }
    return null;
  }

  final TextEditingController controller = TextEditingController();
  int itemCount = 0;
  String text = '';
  String url = '';
  double width = 300, height = 200;
  Offset offsetPos = Offset.zero;
  Widget? widgetInit;
  double left = 800, top = 400;

  @override
  ItemsShelState createState() => ItemsShelState();
}

class ItemsShelState extends ConsumerState<ItemsShel> {
  Offset offset = Offset.zero;
  double angle = 0;

  int get itemCount => widget.itemCount;

  BoxBorder? border;
  BoxBorder? setBorder = Border.all(
    strokeAlign: BorderSide.strokeAlignOutside,
    color: const Color(0xDDB236BD),
    width: 4,
  );
  bool hover = false;
  bool select = false;

  @override
  void initState() {
    widget.controller.text = widget.text;
    super.initState();
  }

  late ButtonDelete buttonDelete;

  @override
  Widget build(BuildContext context) {
    final itemId = ref.watch(itemNum.notifier);
    ref
      ..watch(itemShelProvider)
      ..watch(itemNum);

    if (itemId.state == itemCount) {
      select = true;
    } else {
      select = false;
    }
    buttonDelete = ButtonDelete.deleteItemId(
      context.widget.key!,
      key: UniqueKey(),
    );

    Widget rightBottomTrigger() {
      return Positioned(
        top: (widget.height + 0) < 20 ? 20 : widget.height + 0,
        left: (widget.width + 0) < 20 ? 20 : widget.width + 0,
        child: GestureDetector(
          onPanUpdate: (details) => setState(
            () => {
              hover = true,
              border = setBorder,
              widget.offsetPos = details.delta,
              if (widget.width + widget.offsetPos.dx >= 20)
                {
                  widget.width += widget.offsetPos.dx,
                }
              else
                {widget.width = 20},
              if (widget.height + widget.offsetPos.dy >= 20)
                {
                  widget.height += widget.offsetPos.dy,
                }
              else
                {widget.height = 20},
            },
          ),
          child: Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: const Color(0xFF66D286),
              // color: const Color(0xE5DFFFD6),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      );
    }

    Widget leftTopTrigger() {
      return Positioned(
        top: 0,
        left: 0,
        child: GestureDetector(
          onPanUpdate: (details) => setState(
            () => {
              hover = true,
              border = setBorder,
              widget.offsetPos = details.delta,
              widget.width -= widget.offsetPos.dx,
              widget.height -= widget.offsetPos.dy,
              if (widget.width + widget.offsetPos.dx > 20)
                {
                  widget.left += widget.offsetPos.dx,
                },
              if (widget.height + widget.offsetPos.dy > 20)
                {
                  widget.top += widget.offsetPos.dy,
                },
            },
          ),
          child: Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: const Color(0xFF66D286),
              // color: const Color(0xE5DFFFD6),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      );
    }
    //todo rotation widget
    // Widget rotateTrigger() {
    //   return Positioned(
    //     top: 25,
    //     left: widget.width / 2,
    //     child: GestureDetector(
    //       onPanUpdate: (details) => setState(
    //         () => {
    //           angle += details.delta.dx * 0.01,
    //         },
    //       ),
    //       child: Container(
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(3),
    //         ),
    //         child: const Icon(Icons.rotate_right, color: Color(0xFF66D286)),
    //       ),
    //     ),
    //   );
    // }

    return RepaintBoundary(
      child: GestureDetector(
        onPanUpdate: (details) => setState(
          () => {
            offset = details.delta,
            widget.top += offset.dy,
            widget.left += offset.dx,
          },
        ),
        onTap: () {
          itemId.state = itemCount;
        },
        child: Transform.rotate(
          angle: angle,
          alignment: Alignment.topLeft,
          child: Stack(
            children: [
              Positioned(
                top: widget.top,
                left: widget.left,
                child: MouseRegion(
                  onExit: (e) {
                    setState(
                      () => {
                        border = null,
                        hover = false,
                      },
                    );
                  },
                  onEnter: (e) {
                    setState(
                          () => {
                        border = setBorder,
                        hover = true,
                      },
                    );
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            // image: NetworkImage(widget.url),
                            image: CachedNetworkImageProvider(widget.url),
                            fit: BoxFit.cover,
                          ),
                          border:
                              itemId.state == itemCount ? setBorder : border,
                        ),
                        height: widget.height < 20 ? 20 : (widget.height).abs(),
                        width: widget.width < 20 ? 20 : (widget.width).abs(),
                        child: Padding(
                          padding: widget.widgetInit != null
                              ? const EdgeInsets.all(0)
                              : const EdgeInsets.all(10.0),
                          child: widget.type == 'image'
                              ? const Text('')
                              : Consumer(
                                  builder: (context, ref, _) {
                                    // if (widget.widgetInit != null) {
                                    if (widget.widgetInit != null) {
                                      return widget.widgetInit!;
                                    } else {
                                      return OverflowBox(
                                        child: ScrollConfiguration(
                                          behavior:
                                              ScrollConfiguration.of(context)
                                                  .copyWith(scrollbars: false),
                                          child: TextField(
                                            scrollPhysics:
                                                const NeverScrollableScrollPhysics(),
                                            textDirection: TextDirection.ltr,
                                            controller: widget.controller,
                                            clipBehavior: Clip.none,
                                            expands: false,
                                            maxLines: double.maxFinite.toInt(),
                                            scrollPadding:
                                                const EdgeInsets.all(0.0),
                                            // keyboardType: TextInputType.multiline,
                                            style: const TextStyle(
                                              fontSize: 50,
                                            ),
                                            decoration: const InputDecoration(
                                              hintText: 'Заголовок',
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                        ),
                      ),
                      if (hover || select) (leftTopTrigger()),
                      if (hover || select) (rightBottomTrigger()),
                      // if (hover || select) (rotateTrigger()),
                      if (select) (buttonDelete),
                      const SizedBox(
                        height: 50,
                        width: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class LeftTopTrigger extends ConsumerWidget {
//   const LeftTopTrigger({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final itemsShelController = ref.read(itemShelProvider.notifier);
//     return Positioned(
//       top: 0,
//       left: 0,
//       child: GestureDetector(
//         onPanUpdate: (details) {
//           itemsShelController
//             ..hover = true
//             ..border = itemsShelController.setBorder
//             ..offsetPos = details.delta
//             ..width -= itemsShelController.offsetPos.dx
//             ..height -= itemsShelController.offsetPos.dy;
//           if (itemsShelController.width + itemsShelController.offsetPos.dx >
//               20) {
//             itemsShelController.left += itemsShelController.offsetPos.dx;
//           }
//           if (itemsShelController.height + itemsShelController.offsetPos.dy >
//               20) {
//             itemsShelController.top += itemsShelController.offsetPos.dy;
//           }
//           itemsShelController.updateUi();
//         },
//         child: Container(
//           height: 10,
//           width: 10,
//           decoration: BoxDecoration(
//             color: const Color(0xFF66D286),
//             // color: const Color(0xE5DFFFD6),
//             borderRadius: BorderRadius.circular(3),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class RotateTrigger extends ConsumerWidget {
//   const RotateTrigger({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final itemsShelController = ref.read(itemShelProvider.notifier);
//     return Positioned(
//       top: 25,
//       left: itemsShelController.width / 2,
//       child: GestureDetector(
//         onPanUpdate: (details) {
//           itemsShelController
//             ..angle += details.delta.dx * 0.01
//             ..updateUi();
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(3),
//           ),
//           child: const Icon(Icons.rotate_right, color: Color(0xFF66D286)),
//         ),
//       ),
//     );
//   }
// }
//
// class RightBottomTrigger extends ConsumerWidget {
//   const RightBottomTrigger({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final itemsShelController = ref.read(itemShelProvider.notifier);
//     final height = itemsShelController.height;
//     final width = itemsShelController.width;
//     return Positioned(
//       top: (height) < 20 ? 20 : height,
//       left: (width) < 20 ? 20 : width,
//       child: GestureDetector(
//         onPanUpdate: (details) {
//           itemsShelController
//             ..hover = true
//             ..border = itemsShelController.setBorder
//             ..offsetPos = details.delta;
//
//           if (width + itemsShelController.offsetPos.dx >= 20) {
//             itemsShelController.width += itemsShelController.offsetPos.dx;
//           } else {
//             itemsShelController.width = 20;
//           }
//
//           if (height + itemsShelController.offsetPos.dy >= 20) {
//             itemsShelController.height += itemsShelController.offsetPos.dy;
//           } else {
//             itemsShelController.height = 20;
//           }
//           itemsShelController.updateUi();
//         },
//         child: Container(
//           height: 10,
//           width: 10,
//           decoration: BoxDecoration(
//             color: const Color(0xFF66D286),
//             // color: const Color(0xE5DFFFD6),
//             borderRadius: BorderRadius.circular(3),
//           ),
//         ),
//       ),
//     );
//   }
// }
