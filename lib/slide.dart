import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:izi_quizi/jsonParse.dart';
import 'model/ItemsShel.dart';
import 'model/ListDataSlide.dart';
import 'main.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'dart:math';
import 'package:screenshot/screenshot.dart';

import 'model/SlideItem.dart';


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
  SlideData data = SlideData();

  int numWidget = 0;

  List<Widget> listWidgets = [];

  List<SlideItems> listSlide = [];
  Future<Uint8List> imageElementToUint8List(ImageElement imageElement) async {
    // Create a Canvas element and set its dimensions to match the image element
    final canvas = CanvasElement(width: imageElement.width, height: imageElement.height);

    // Draw the image element onto the canvas
    final context = canvas.context2D;
    context.drawImage(imageElement, 0, 0);

    // Get the ImageData object from the canvas
    final imageData = context.getImageData(0, 0, imageElement.width!.toInt(), imageElement.height!.toInt());

    // Return a Uint8List containing the pixel data from the ImageData object
    return Uint8List.view(imageData.data.buffer);
  }
  Future<void> pickFileWeb(int buttonId, StateController<int> _numAddItemState) async {
    Uint8List? imageData;

    print("_pickFile=>");
    var input = html.FileUploadInputElement()..click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);

      reader.onLoad.listen((event) {
        imageData = reader.result as Uint8List;
        Widget imageWidget = Container(
          // margin: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(imageData!),
              fit: BoxFit.cover,
            ),
          ),
        );
        ItemsShel imageBox = ItemsShel.imageWidget(UniqueKey(), imageWidget);
        print ("img => 3333");

        data.indexOfListSlide(buttonId).addItemShel(imageBox);
        // listSlide[buttonId].addItem(imageBox);
      });
    });

    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   dialogTitle: "Выберите изображение или gif",
    //   type: FileType.image,
    //   // allowedExtensions: ['jpg','gif','jpeg'],
    // );
    //
    // if (result != null) {
    //   PlatformFile file = result.files.single;
    //
    //   print(file.path);
    //   // File _file = File(file.path!);
    //   File _file = File(file.path!);
    //   // __fileProvidere.state = _file;
    //   // print("${__fileProvidere.state}");
    //   Widget imageWidget = Container(
    //     // margin: const EdgeInsets.all(0),
    //     decoration: BoxDecoration(
    //       image: DecorationImage(
    //         image: Image.file(_file).image,
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //   );
    //
    //   // TextBox textBox = TextBox.image(UniqueKey(), _file);
    //   TextBox imageBox = TextBox.widget(UniqueKey(), imageWidget);
    //
    //   listSlide[buttonId].addItem(imageBox);
    // } else {
    //   // User canceled the picker
    // }
    _numAddItemState.state = -100;
  }
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
    SlideItems slide = SlideItems();
    StateController<int> _buttonID = ref.watch(buttonID.notifier);
    final _counterSlide = ref.watch(counterSlide);


    final _numAddItem = ref.watch(numAddItem);
    StateController<int> _numAddItemState = ref.watch(numAddItem.notifier);


    final __fileProvider = ref.watch(fileProvider);

    //удаление элементов из слайда
    final _DelItemId = ref.watch(delItemId);



    if ( data.getLengthListSlide() < _counterSlide){
      data.addListSlide(slide);
      // listSlide.add(slide);
    }

    if (_numAddItem == 1){
      print ("Add text item =>${_numAddItem}");
      // TextSlide textBox = TextSlide.Id(data.indexOfListSlide(_buttonID.state).lengthArr());
      ItemsShel itemsShel = ItemsShel.id(UniqueKey(), data.indexOfListSlide(_buttonID.state).lengthArr());
      data.indexOfListSlide(_buttonID.state).addItemShel(itemsShel);
    }

    if (_numAddItem == -4){
      print ("Add image item =>${_numAddItem}");
      pickFileWeb(_buttonID.state, _numAddItemState);
    }


    // print("_DelItemId=> ${_DelItemId}");
    // listSlide[_buttonID.state].delItem(_DelItemId);
    data.indexOfListSlide(_buttonID.state).delItem(_DelItemId);

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
                                // for (Slide name in listSlide) (name.getSlide()),
                                for (SlideItems name in data.getListSlide()) (name.getSlide()),
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