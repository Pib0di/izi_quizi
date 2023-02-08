import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'main.dart';
import 'dart:io';
import 'dart:math';


class Item {
  Item._(this.widget, this._offset) {}

  Item(this.widget) {}

  Offset _offset = Offset.zero;
  Widget? widget;
}

class PresentationCreationArea extends ConsumerWidget{
  PresentationCreationArea({Key? key}) : super(key: key);
  PresentationCreationArea.hi(this.numWidget) {}

  // final canGoToPreviousPageProvider = Provider<StateProvider<int>((ref) {
  //   return ref.watch(buttonID) != 0;
  // });

  int numWidget = 0;

  List<Widget> listWidgets = [
    // Text("HELLO"),
  ];
  List<Slide> listSlide = [
    // Text("HELLO"),
  ];

  Future<void> _pickFile(int buttonId, StateController<int> _numAddItemState) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: "Выберите изображение или gif",
      type: FileType.image,
      // allowedExtensions: ['jpg','gif','jpeg'],
    );

    if (result != null) {
      PlatformFile file = result.files.single;

      print(file.path);
      // File _file = File(file.path!);
      File _file = File(file.path!);
      // __fileProvidere.state = _file;
      // print("${__fileProvidere.state}");
      Widget imageWidget = Container(
        // margin: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Image.file(_file).image,
            fit: BoxFit.cover,
          ),
        ),
      );

      // TextBox textBox = TextBox.image(UniqueKey(), _file);
      TextBox imageBox = TextBox.widget(UniqueKey(), imageWidget);

      listSlide[buttonId].addItem(imageBox);
    } else {
      // User canceled the picker
    }
    _numAddItemState.state = -100;

  }
  // void _pickFile(int buttonId) {
  //   File _file = File("file.path!");
  //   print("CEEEERFFF +? ${_file}");
  //   TextBox textBox = TextBox.image(UniqueKey(), _file);
  //   listSlide[buttonId].addItem(textBox);
  // }

  void addWidget(int idWidget) {
    // listWidgets.add(_selectWidget[idWidget]);
  }

  final _selectWidget = <Widget>[
    // Slide(),
    Container(
      width: 290,
      height: 290,
      color: Colors.yellow,
    ),
    // _MediaMenuButton(),
    // _MediaMenuButton(),
  ];
  Widget sideMenu(int numWidget) {
    // listWidgets.add(container);
    return Container(
      width: 200,
      color: Colors.black54,
      child: Container(
        child: _selectWidget[numWidget],
      ),
    );
  }

  Widget Area() {
    // listWidgets.add(container2);
    // listWidgets.add(MyStateful());
    return Expanded(
      child: AspectRatio(
        aspectRatio: 16/9,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // print('constraints.maxWidth => ${constraints.maxWidth}');
            return OverflowBox(
              maxWidth: double.infinity,
              maxHeight: double.infinity,
              child: Transform.scale(
                scale: constraints.maxWidth < 1920 ? constraints.maxWidth/1920 : 1920/constraints.maxWidth,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.grey[350],
                  width: constraints.maxWidth*(constraints.maxWidth < 1920 ? 1920/constraints.maxWidth : constraints.maxWidth/1920),
                  height: constraints.maxHeight*(constraints.maxWidth < 1920 ? 1920/constraints.maxWidth : constraints.maxWidth/1920),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [listWidgets[0]],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ConsumerAddItemsToSlide consumerAddItemsToSlide = ConsumerAddItemsToSlide.ListSlide(listWidgets);
    Slide slide = Slide();
    StateController<int> _buttonID = ref.watch(buttonID.notifier);
    final _counterSlide = ref.watch(counterSlide);


    final _numAddItem = ref.watch(numAddItem);
    StateController<int> _numAddItemState = ref.watch(numAddItem.notifier);


    final __fileProvider = ref.watch(fileProvider);

    //удаление элементов из слайда
    final _DelItemId = ref.watch(delItemId);



    if (listSlide.length < _counterSlide){
      listSlide.add(slide);
    }

    if (_numAddItem == 1){
      print ("_numAddItem=>${_numAddItem}");
      TextSlide textBox = TextSlide.Id(listSlide[_buttonID.state].lengthArr());
      listSlide[_buttonID.state].addItem(textBox.getTextSlide());
    }

    print ("_numAddItem=>${_numAddItem}");
    if (_numAddItem == -4){
      _pickFile(_buttonID.state, _numAddItemState);
    }


    print("_DelItemId=> ${_DelItemId}");
    listSlide[_buttonID.state].delItem(_DelItemId);

    // if (_DelItemId == 1){
    //   // listSlide.removeAt(_buttonID.state);
    // }



    // print("buttonID.state12=> ${_buttonID.state}");
    return Expanded(
      child: AspectRatio(
        aspectRatio: 16/9,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Consumer(
                builder: (context, ref, _) {
                  final count = ref.watch(buttonID);
                  print("count => ${count}");
                  // if (_numAddItem == 1){
                  //   print(" listWidgets.length => ${listWidgets.length}");
                  //   listSlide[0].addItem(Text("HIEFJ"));
                  //   // listWidgets[_buttonID.state];
                  // }
                  return OverflowBox(
                    maxWidth: double.infinity,
                    maxHeight: double.infinity,
                    child: Transform.scale(
                      scale: constraints.maxWidth < 1920 ? constraints
                          .maxWidth / 1920 : 1920 / constraints.maxWidth,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.grey[350],
                        width: constraints.maxWidth *
                            (constraints.maxWidth < 1920 ? 1920 /
                                constraints.maxWidth : constraints.maxWidth /
                                1920),
                        height: constraints.maxHeight *
                            (constraints.maxWidth < 1920 ? 1920 /
                                constraints.maxWidth : constraints.maxWidth /
                                1920),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // listWidgets[count],
                            IndexedStack(
                              sizing: StackFit.expand,
                              index: count,
                              children: <Widget>[
                                // for (Widget name in listWidgets) (name),
                                for (Slide name in listSlide) (name.getSlide()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              );
            }
        ),
      ),
    );
  }
}

class HomeView extends ConsumerStatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    // "ref" can be used in all life-cycles of a StatefulWidget.
    ref.read(counterProvider);
  }

  @override
  Widget build(BuildContext context) {
    // We can also use "ref" to listen to a provider inside the build method
    final counter = ref.watch(counterProvider);
    return Text('$counter');
  }
}

class Slide extends ConsumerWidget {
  Slide(){}

  List<Widget> listItems = [];
  // TextSlide textSlide = TextSlide();
  int lengthArr(){
    return listItems.length;
  }

  void addItem(Widget item){
    // addItem(textSlide.getTextSlide());

    listItems.add(item);
  }
  void delItem(Key delItemId){
    // print("listItems.length => ${listItems.length}");
    // print("delItemId => ${delItemId}");

    // for (int i = 0; i < listItems.length; ++i){
    //   print("listItems[$i].key => ${listItems[i].key}");
    //   print("listItems.elementAt($i) => ${listItems.elementAt(i)}");
    // }

    print ("delItemId=> ${delItemId}");
    listItems.retainWhere((item) => item.key != delItemId);

    // print("listItems.removeAt(${delItemId}) => ${listItems.removeAt(delItemId)}");
  }


  Stack getSlide(){
    return Stack(
      children: listItems,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print("_offset => $_offset, \n width => $width # $txt");
    // addItem(textSlide.getTextSlide());
    // addItem(textSlide.getTextSlide());

    return Stack(
      children: listItems,
    );
  }
}

class ButtonDelete extends ConsumerWidget {
  ButtonDelete({Key? key}) : super(key: key);
  ButtonDelete.deleteItemId(this.deleteItemId);
  Key deleteItemId = UniqueKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    StateController<int> _numAddItem = ref.watch(numAddItem.notifier);
    StateController<int> _ItemId = ref.watch(ItemId.notifier);
    StateController<Key> _DelItemId = ref.watch(delItemId.notifier);
    // StateController<int> _DelItemId = ref.watch(delItemId.notifier);
    return Positioned(
      right: 0,
      child: Container(
        margin: const EdgeInsets.all(5),
        width: 30,
        height: 30,
        child: RawMaterialButton(
          fillColor: Colors.redAccent,
          shape: const CircleBorder(),
          elevation: 0.0,
          onPressed: () {
            // _ItemId.state = deleteItemId;
            _DelItemId.state = deleteItemId;
            _numAddItem.state = -100;
            _numAddItem.state = -10;
          },
          child: const Icon(Icons.delete, size: 20,),
        ),
      ),
    );
  }
}


class NavigationSlideMenuButton extends ConsumerStatefulWidget {
  NavigationSlideMenuButton({Key? key}) : super(key: key);
  NavigationSlideMenuButton.buttonID({required this.ButtonID, required this.key}) : super(key: key);

  Key key = UniqueKey();
  int ButtonID = -10;
  @override
  _NavigationSlideMenuButton createState() => _NavigationSlideMenuButton.buttonID(ButtonID, key);
}
class _NavigationSlideMenuButton extends ConsumerState<NavigationSlideMenuButton> {
  _NavigationSlideMenuButton(){}
  _NavigationSlideMenuButton.buttonID(
    this.ButtonID,
    this.key,
  );

  Key key = UniqueKey();
  double width = 0;
  double widthBorder = 0;
  bool select = false;
  int ButtonID = -20;

  void kh(bool b){
    setState(() {
      if (b){
        widthBorder = 3;
      }
      else{
        widthBorder = 0;
      }
    });
  }

  Widget _hoverMenu = const Text("");
  // Widget hoverMenu3 = Positioned(
  //   right: 0,
  //   child: Container(
  //     margin: const EdgeInsets.all(5),
  //     width: 30,
  //     height: 30,
  //     child: RawMaterialButton(
  //       fillColor: Colors.redAccent,
  //       shape: const CircleBorder(),
  //       elevation: 0.0,
  //       onPressed: () {
  //
  //         final provider = Provider((ref) {
  //           // use ref to obtain other providers
  //           var repository = ref.watch(numAddItem);
  //           repository = -10;
  //         });
  //         provider;
  //         // final container = Provider(name: );
  //         // final repository = container.read(numAddItem);
  //         // repository.state = -10;
  //         // print("repository.state=> ${numAddItem.notifier}");
  //         // StateController<int> counter = ref.watch(buttonID.notifier);
  //         // print("email => $email, txt => $txt");
  //         // request.deletePresent(email, txt);
  //       },
  //       child: const Icon(Icons.delete, size: 20,),
  //     ),
  //   ),
  // );


  @override
  Widget build(BuildContext context) {
    // use ref to listen to a provider
    Widget hoverMenu2 = ButtonDelete.deleteItemId(key);
    void hoverMenu(bool b){
      setState(() {
        if (b){
          _hoverMenu = hoverMenu2;
        }
        else{
          _hoverMenu = const Text("");
        }
      });
    }

    StateController<int> counter = ref.watch(buttonID.notifier);
    int selectButtonID = ref.watch(buttonID);
    width = counter.state == ButtonID ? 3 : 0;

    return MouseRegion(
      onEnter: (e){
        hoverMenu(true);
      },
      onExit: (e){
        // counter.state == ButtonID ? hoverMenu(true) : hoverMenu(false);
        hoverMenu(false);
      },
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            height: 111,
            decoration: BoxDecoration(
              border: Border.all(
                strokeAlign: StrokeAlign.outside,
                width: counter.state == ButtonID ? width : widthBorder,
                // selectButtonID == ButtonID ? 3 : 0,
              ),
              color: const Color(0xff7c94b6),
              image: const DecorationImage(
                image: NetworkImage(
                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ElevatedButton(
              // onHover: ,
              onHover: (e){
                // print("as;ldkfja;sldkfja;lsdkfja;lsd");
                kh(e);
              },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(),
                shadowColor: Colors.transparent,
                // foregroundColor: MaterialStateProperty.all(Colors.transparent),
                // overlayColor: MaterialStateProperty.all(const Color.fromARGB(65, 63, 255, 85)),
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.only(bottom: 10),
              ),
              // shape: const RoundedRectangleBorder(),
              onPressed: () {
                counter.state = ButtonID;
                print("Button ID => ${counter.state}");
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
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
                      "$ButtonID",
                    ),
                  ),
                ],
              ),
            ),
          ),
          counter.state == ButtonID ? hoverMenu2 : _hoverMenu,
        ],
      ),
    );
  }
}

class TextSlide {
  TextSlide.Id(this.id);
  int id = 10;
  Widget getTextSlide(){
    TextBox textBox = TextBox.Id(UniqueKey(), id);
    return textBox;
  }
}

// text field in the slide
class TextBox extends ConsumerStatefulWidget {
  // TextBox({Key? key}) : super(key: key);
  TextBox.Id(Key key, this.id) : super(key: key);
  TextBox.image(Key key, this.imageFile) : super(key: key);
  TextBox.widget(Key key, this.widget) : super(key: key);

  Widget? widget;
  File imageFile = File('path');
  int id = 0;
  @override
  _TextBoxState createState() => _TextBoxState(id, imageFile, widget);
}
class _TextBoxState extends ConsumerState<TextBox> {
  _TextBoxState(
      this.itemId,
      this.imageFile,
      this.widgetInit
  ){}

  Widget? widgetInit;
  File imageFile;
  // File file = File("C:/Users/2001a/Pictures/Camera Roll/WIN_20220928_14_19_10_Pro.jpg");

  late TextEditingController _controller;
  int slideId = 0;
  int itemId = 0;
  Color _color = Colors.black45;
  Offset _offset = Offset.zero;
  Offset _offsetPos = Offset.zero;
  double width = 300, height = 100;
  double left = 200, top = 200, right = 0, bottom = 0;
  double angle = 0;
  String txt = 'sheet';
  String text = 'hello';
  int f1 = 0, f2 = 0;
  bool flag= true;
  bool flag1= true;


  Widget rightBottomTriger(){
    return Positioned(
      top: (height + 0) < 20 ? 20 : height + 0,
      left: (width + 0) < 20 ? 20 : width + 0,
      child: GestureDetector(
        onPanUpdate: (details) => setState(() => {
          hover = true,
          border = setBorder,
          _offsetPos = details.delta,
          if (width+_offsetPos.dx >= 20){
            width += _offsetPos.dx,
          } else{
            width = 20
          },
          if (height+_offsetPos.dy >= 20){
            height += _offsetPos.dy,
          }
          else{
            height =20
          },
          // width +=  _offsetPos.dx,
          // height += _offsetPos.dy,
          // top += _offsetPos.dy,
          // left += _offsetPos.dx,
          txt = height.toString(),
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
          _offsetPos = details.delta,
          width -= _offsetPos.dx,
          height -= _offsetPos.dy,

          // if (width-_offsetPos.dx >= 20){
          //   width -= _offsetPos.dx,
          //   flag = true,
          // } else{
          //   flag = false,
          //   width = 20
          // },
          // if (height-_offsetPos.dy >= 20){
          //   height -= _offsetPos.dy,
          //   flag1 = true,
          // }
          // else{
          //   flag1 = false,
          //   height =20
          // },

          if (width+_offsetPos.dx > 20 && flag){
            print("left"),
            left += _offsetPos.dx,
          },

          if (height+_offsetPos.dy > 20 && flag1){
            print(""),
            top += _offsetPos.dy,
          },
          txt = _offsetPos.toString(),
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
      top: 20,
      left: width/2,
      child: GestureDetector(
        onPanUpdate: (details) => setState(() => {
          angle = details.delta.distance,
        }),
        child: Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: const Color(0xFF66D286),
            // color: const Color(0xE5DFFFD6),
            borderRadius: BorderRadius.circular(3),
          ),
          child: const Icon(Icons.ice_skating),
        ),
      ),
    );
  }


  BoxBorder? border;
  BoxBorder? setBorder = Border.all(
    strokeAlign: StrokeAlign.outside,
    color: const Color(0xDDB236BD),
    width: 4,
  );
  bool hover = false;
  bool select = false;

  void decrementId(){
    --itemId;
  }
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }
  @override
  void dispose() {
    _controller.dispose();
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
          txt = _offset.toString(),
          // angle = (_offset.dx) / 2 * 0.01,
          top = 200+_offset.dy,
          left = 200+_offset.dx,
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
        child: Stack(
            children: [
              Positioned(
                top: top,
                left: left,
                child:
                // Transform(
                //   transform:Matrix4.identity()
                //     ..setTranslationRaw(_offset.dx, _offset.dy, 0),
                //   // ..scale(0.8),
                //   // ..rotateZ(0.01 * _offset.dx),
                //   alignment: FractionalOffset.center,
                Transform.rotate(
                  angle: angle,
                  child: MouseRegion(
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
                            image: DecorationImage(
                              // image: Image.file(File('dfg')),
                              image: Image.file(imageFile).image,
                              // image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                              fit: BoxFit.cover,
                            ),
                            // borderRadius: BorderRadius.circular(15),
                            border: _ItemId.state == itemId ? setBorder : border,

                          ),
                          height: height < 20 ? 20 : (height).abs(),
                          width: width < 20 ? 20 : (width).abs(),
                          child: Padding(
                            padding: widgetInit != null ?  const EdgeInsets.all(0) : const EdgeInsets.all(10.0),
                            child: Consumer(
                              builder: (context, ref, _) {
                                // print("STACK2");
                                int count = ref.watch(counterProvider);
                                if (widgetInit != null){
                                  return widgetInit!;
                                }
                                else {
                                  return OverflowBox(
                                    child: ScrollConfiguration(
                                      behavior: ScrollConfiguration.of(context)
                                          .copyWith(scrollbars: false),
                                      child: TextField(
                                        scrollPhysics: const NeverScrollableScrollPhysics(),
                                        textDirection: TextDirection.ltr,
                                        controller: _controller,
                                        clipBehavior: Clip.none,
                                        expands: false,
                                        // maxLength: 10,
                                        maxLines: double.maxFinite.toInt(),
                                        scrollPadding: const EdgeInsets.all(0.0),
                                        // keyboardType: TextInputType.multiline,
                                        style: const TextStyle(
                                          fontSize: 50,
                                        ),
                                        decoration: const InputDecoration(
                                          hintText: "Заголовок",
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
              ),
            ]
        ),
      ),
    );
  }
}
