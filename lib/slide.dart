import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:izi_quizi/jsonParse.dart';
import 'FactoryСlasses/SideSlides.dart';
import 'model/ItemsShel.dart';
import 'FactoryСlasses/SlideData.dart';
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



    // if ( data.getLengthListSlide() < _counterSlide){
    //   data.addListSlide(slide);
    //   // listSlide.add(slide);
    // }

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
                  int count = ref.watch(buttonID);
                  if (count > 0) {
                    --count;
                  }
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





