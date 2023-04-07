import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Widgets/WidgetsCollection.dart';
import '../main.dart';
import '../slide.dart';
import '../FactoryСlasses/SlideData.dart';

class ItemsShel extends ConsumerStatefulWidget {
  ItemsShel({
    Key? key,
    required ItemsShelDataText itemsShelDataText,
    required ItemsShelDataImage itemsShelDataImage,
  }) : super(key: key){
   var l = 0;
  }


  // TextBox({Key? key}) : super(key: key);
  ItemsShel.id(Key key, this.itemId) : super(key: key){
    type = "text";
  }
  // TextBox.image(Key key, this.imageFile) : super(key: key);
  ItemsShel.imageWidget(Key key, this.widgetInit) : super(key: key){
    type = "image";
  }
  ItemsShel.imageWidgetJson({
    Key? key,
    this.url = '',
    this.width = 300,
    this.height = 100,
    this.left = 200,
    this.top = 200,
  }) : super(key: key){
    type = "image";
  }
  ItemsShel.textWidgetJson({
    Key? key,
    this.text = '',
    this.width = 300,
    this.height = 100,
    this.left = 200,
    this.top = 200,
  }) : super(key: key){
    type = "text";
  }
  String type = "standard";

  ItemsShelDataText itemsShelDataText = ItemsShelDataText();
  ItemsShelDataText? getItemsShelDataText (){
    itemsShelDataText.type = type;
    itemsShelDataText.offsetX = left;
    itemsShelDataText.offsetY = top;

    itemsShelDataText.width = width;
    itemsShelDataText.height = height;

    itemsShelDataText.text = controller.value.text;
    if (type == "text") {
      return itemsShelDataText;
    }
    return null;
  }

  ItemsShelDataImage itemsShelDataImage = ItemsShelDataImage();
  ItemsShelDataImage? getItemsShelDataImage (){
    itemsShelDataImage.type = type;
    itemsShelDataImage.offsetX = left;
    itemsShelDataImage.offsetY = top;

    itemsShelDataImage.width = width;
    itemsShelDataImage.height = height;

    // itemsShelDataImage.url = _controller.value.text;
    if (type == "image") {
      return itemsShelDataImage;
    }
    return null;
  }


  final TextEditingController controller = TextEditingController();
  // final TextEditingController? controller;
  int itemId = 0;
  String text = '';
  String url = '';
  double width = 300, height = 100;
  Offset _offsetPos = Offset.zero;
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

  int slideId = 0;
  Color _color = Colors.black45;
  Offset _offset = Offset.zero;
  double angle = 0;
  int f1 = 0, f2 = 0;
  bool flag= true;
  bool flag1= true;

  int get itemId => widget.itemId;


  Widget rightBottomTriger(){
    return Positioned(
      top: (widget.height + 0) < 20 ? 20 : widget.height + 0,
      left: (widget.width + 0) < 20 ? 20 : widget.width + 0,
      child: GestureDetector(
        onPanUpdate: (details) => setState(() => {
          hover = true,
          border = setBorder,
          widget._offsetPos = details.delta,
          if (widget.width+widget._offsetPos.dx >= 20){
            widget.width += widget._offsetPos.dx,
          } else{
            widget.width = 20
          },
          if (widget.height+widget._offsetPos.dy >= 20){
            widget.height += widget._offsetPos.dy,
          }
          else{
            widget.height =20
          },
          // width +=  _offsetPos.dx,
          // height += _offsetPos.dy,
          // top += _offsetPos.dy,
          // left += _offsetPos.dx,
        }),
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
  Widget leftTopTriger(){
    return Positioned(
      top: 0,
      left: 0,
      child: GestureDetector(
        onPanUpdate: (details) => setState(() => {
          hover = true,
          border = setBorder,
          widget._offsetPos = details.delta,
          widget.width -= widget._offsetPos.dx,
          widget.height -= widget._offsetPos.dy,

          if (widget.width+widget._offsetPos.dx > 20 && flag){
            // print("left"),
            widget.left += widget._offsetPos.dx,
          },

          if (widget.height+widget._offsetPos.dy > 20 && flag1){
            print(""),
            widget.top += widget._offsetPos.dy,
          },
        }),
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
  Widget rotateTriger(){
    return Positioned(
      top: 25,
      left: widget.width/2,
      child: GestureDetector(
        onPanUpdate: (details) => setState(() => {
          // print("rotateTriger"),
          angle += details.delta.dx*0.01,
        }),
        child: Container(
          // height: 10,
          // width: 10,
          decoration: BoxDecoration(
            // color: const Color(0xFF66D286),
            // color: const Color(0xE5DFFFD6),
            borderRadius: BorderRadius.circular(3),
          ),
          child: const Icon(Icons.rotate_right, color: const Color(0xFF66D286)),
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
    StateController<int> _buttonID = ref.watch(buttonID.notifier);
    StateController<int> _ItemId = ref.watch(ItemId.notifier);
    final _ItemSelect = ref.watch(ItemId);
    final _ItemSelect1 = ref.watch(fileProvider);

    // print("imageFile1111 => ${imageFile}");

    select = _ItemId.state == itemId ? true : false;

    // ButtonDelete buttonDelete = ButtonDelete.deleteItemId(_ItemId.state);
    ButtonDelete buttonDelete = ButtonDelete.deleteItemId(context.widget.key!);
    return RepaintBoundary(
      child: GestureDetector(
        onPanUpdate: (details) => setState(() => {
          _offset += details.delta,
          // angle = (_offset.dx) / 2 * 0.01,
          widget.top = 200+_offset.dy,
          widget.left = 200+_offset.dx,
        }),
        onTap: () {
          // select = true;
          // border = setBorder;
          _ItemId.state = itemId;
          setState(() {
            _color == Colors.yellow
                ? _color = Colors.white
                : _color = Colors.yellow;
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
                    onExit: (e){
                      setState (()=>{
                        border = null,
                        hover = false,
                        // print("ID this textBox => ${itemId}"),
                      });
                    },
                    onEnter: (e){
                      setState (()=>{
                        border = setBorder,
                        hover = true,
                      });
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children:[
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
                            border: _ItemId.state == itemId ? setBorder : border,

                          ),
                          height: widget.height < 20 ? 20 : (widget.height).abs(),
                          width: widget.width < 20 ? 20 : (widget.width).abs(),
                          child: Padding(
                            padding: widget.widgetInit != null ?  const EdgeInsets.all(0) : const EdgeInsets.all(10.0),
                            child: Consumer(
                              builder: (context, ref, _) {
                                // print("STACK2");
                                int count = ref.watch(counterProvider);
                                if (widget.widgetInit != null){
                                  return widget.widgetInit!;
                                }
                                else {
                                  return OverflowBox(
                                    child: ScrollConfiguration(
                                      behavior: ScrollConfiguration.of(context)
                                          .copyWith(scrollbars: false),
                                      child: TextField(
                                        scrollPhysics: const NeverScrollableScrollPhysics(),
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
                                          hintText: "Заголовок",
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
                        if (hover || select)(leftTopTriger()),
                        if (hover || select)(rightBottomTriger()),
                        if (hover || select)(rotateTriger()),
                        if (select) (buttonDelete),
                        const SizedBox(height: 50, width: 50,),
                      ],
                    ),
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}
