import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/data/repository/local/widgets/widgets_collection.dart';
import 'package:izi_quizi/main.dart';

/// the number of the selected element in the slidez
final itemNum = StateProvider((ref) => 0);

class ItemsShel extends ConsumerStatefulWidget {
  ItemsShel.id(Key key, this.itemCount) : super(key: key) {
    type = 'text';
  }

  // TextBox.image(Key key, this.imageFile) : super(key: key);
  ItemsShel.imageWidget(Key key, this.widgetInit) : super(key: key) {
    type = 'image';
  }

  ItemsShel.imageWidgetJson({
    super.key,
    this.url = '',
    this.width = 300,
    this.height = 100,
    this.left = 200,
    this.top = 200,
  }) {
    type = 'image';
  }

  ItemsShel.textWidgetJson({
    super.key,
    this.text = '',
    this.width = 300,
    this.height = 100,
    this.left = 200,
    this.top = 200,
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
      ..height = height;
    // todo url implementation
    // itemsShelDataImage.url = _controller.value.text;
    if (type == 'image') {
      return itemsShelDataImage;
    }
    return null;
  }

  final TextEditingController controller = TextEditingController();

  // final TextEditingController? controller;
  int itemCount = 0;
  String text = '';
  String url = '';
  double width = 300, height = 100;
  Offset offsetPos = Offset.zero;
  Widget? widgetInit;
  double left = 200, top = 200;

  // File imageFile = File('path');
  @override
  // _TextBoxState createState() => _TextBoxState(id, imageFile, widget);
  ItemsShelState createState() => ItemsShelState();
}

class ItemsShelState extends ConsumerState<ItemsShel> {
  // TextEditingController get _controller => widget._controller;

  // Widget? widgetInit;
  // File imageFile;
  // File file = File("C:/Users/2001a/Pictures/Camera Roll/WIN_20220928_14_19_10_Pro.jpg");

  Color color = Colors.black45;
  Offset offset = Offset.zero;
  double angle = 0;

  int get itemCount => widget.itemCount;

  Widget rightBottomTriger() {
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
            // width +=  _offsetPos.dx,
            // height += _offsetPos.dy,
            // top += _offsetPos.dy,
            // left += _offsetPos.dx,
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

  Widget leftTopTriger() {
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
                // print("left"),
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

  Widget rotateTriger() {
    return Positioned(
      top: 25,
      left: widget.width / 2,
      child: GestureDetector(
        onPanUpdate: (details) => setState(
          () => {
            // print("rotateTriger"),
            angle += details.delta.dx * 0.01,
          },
        ),
        child: Container(
          // height: 10,
          // width: 10,
          decoration: BoxDecoration(
            // color: const Color(0xFF66D286),
            // color: const Color(0xE5DFFFD6),
            borderRadius: BorderRadius.circular(3),
          ),
          child: const Icon(Icons.rotate_right, color: Color(0xFF66D286)),
        ),
      ),
    );
  }

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
    super.initState();
    widget.controller.text = widget.text;
    // _controller = TextEditingController();
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemId = ref.watch(itemNum.notifier);
    ref
      ..watch(itemNum)
      ..watch(fileProvider);

    select = itemId.state == itemCount ? true : false;

    final buttonDelete = ButtonDelete.deleteItemId(context.widget.key!);
    return RepaintBoundary(
      child: GestureDetector(
        onPanUpdate: (details) => setState(
          () => {
            offset += details.delta,
            // angle = (_offset.dx) / 2 * 0.01,
            widget.top = 200 + offset.dy,
            widget.left = 200 + offset.dx,
          },
        ),
        onTap: () {
          // select = true;
          // border = setBorder;
          itemId.state = itemCount;
          setState(() {
            color == Colors.yellow
                ? color = Colors.white
                : color = Colors.yellow;
          });
        },
        child: Transform.rotate(
          angle: angle,
          alignment: Alignment.topLeft,
          child: Stack(
            children: [
              Positioned(
                top: widget.top,
                left: widget.left,
                child:
                    // Transform(
                    //   transform:Matrix4.identity()
                    //     ..setTranslationRaw(_offset.dx, _offset.dy, 0),
                    //   // ..scale(0.8),
                    //   // ..rotateZ(0.01 * _offset.dx),
                    //   alignment: FractionalOffset.center,
                    MouseRegion(
                  onExit: (e) {
                    setState(
                      () => {
                        border = null,
                        hover = false,
                        // print("ID this textBox => ${itemId}"),
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
                          // image: DecorationImage(
                          //   // image: Image.file(File('dfg')),
                          //   image: Image.file(imageFile).image,
                          //   // image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                          //   fit: BoxFit.cover,
                          // ),
                          // borderRadius: BorderRadius.circular(15),
                          border:
                              itemId.state == itemCount ? setBorder : border,
                        ),
                        height: widget.height < 20 ? 20 : (widget.height).abs(),
                        width: widget.width < 20 ? 20 : (widget.width).abs(),
                        child: Padding(
                          padding: widget.widgetInit != null
                              ? const EdgeInsets.all(0)
                              : const EdgeInsets.all(10.0),
                          child: Consumer(
                            builder: (context, ref, _) {
                              // print("STACK2");
                              if (widget.widgetInit != null) {
                                return widget.widgetInit!;
                              } else {
                                return OverflowBox(
                                  child: ScrollConfiguration(
                                    behavior: ScrollConfiguration.of(context)
                                        .copyWith(scrollbars: false),
                                    child: TextField(
                                      scrollPhysics:
                                          const NeverScrollableScrollPhysics(),
                                      textDirection: TextDirection.ltr,
                                      controller: widget.controller,
                                      clipBehavior: Clip.none,
                                      expands: false,
                                      maxLines: double.maxFinite.toInt(),
                                      scrollPadding: const EdgeInsets.all(0.0),
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
                              // Text("Text => $txt, Count => $count.");
                            },
                          ),
                        ),
                      ),
                      if (hover || select) (leftTopTriger()),
                      if (hover || select) (rightBottomTriger()),
                      if (hover || select) (rotateTriger()),
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
