

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/Widgets/WidgetsCollection.dart';

import '../main.dart';

class SideSlides {
  static final SideSlides _instance = SideSlides._internal();
  factory SideSlides() {
    return _instance;
  }
  SideSlides._internal();


  int numSlide = 0;
  List<NavSlideButton> sideList = [];

  addSlide(NavSlideButton navSlideButton){
    ++numSlide;
    sideList.add(navSlideButton);
  }

  List<NavSlideButton> getSlide(){
    return sideList;
  }

  void setSlide(List<NavSlideButton> list){
    print("setSlide length => ${sideList.length}");
    // sideList.clear();
    sideList = list;
  }
  void delItem(Key delItemId){
    // countSlide.state = countSlide.state - 1;
    print ("delItemId=> ${delItemId}");
    final result = sideList.retainWhere((item) => item.key != delItemId);

  }
}

class NavSlideButton extends ConsumerStatefulWidget {
  // NavSlideButton({Key? key}) : super(key: key);
  NavSlideButton.buttonID({required this.buttonId, required this.key}) : super(key: key);

  void setButtonId(int id){
    buttonId = id;
  }

  final Key key;

  int buttonId = -10;
  @override
  NavSlideButtonState createState() => NavSlideButtonState();
}
class NavSlideButtonState extends ConsumerState<NavSlideButton> {

  double width = 0;
  double widthBorder = 0;
  bool select = false;


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

  @override
  Widget build(BuildContext context) {
    Widget hoverMenu2 = ButtonDelete.deleteItemId(widget.key);
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
    width = counter.state == widget.buttonId ? 3 : 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          MouseRegion(
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
                      strokeAlign: BorderSide.strokeAlignOutside,
                      width: counter.state == widget.buttonId ? width : widthBorder,
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
                    onHover: (e){
                      kh(e);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.only(bottom: 10),
                    ),
                    // shape: const RoundedRectangleBorder(),
                    onPressed: () {
                      print("Button ID => ${counter.state}");
                      counter.state = widget.buttonId;
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
                            "${widget.buttonId}",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                counter.state == widget.buttonId ? hoverMenu2 : _hoverMenu,
              ],
            ),
          ),
          const SizedBox(
            height: 7,
          ),
        ],
      ),
    );
  }
}


SideSlides sideSlides = SideSlides();
class ListSlide extends ConsumerStatefulWidget {
  const ListSlide({Key? key}) : super(key: key);

  @override
  SideSlidesState createState() => SideSlidesState();
}

class SideSlidesState extends ConsumerState<ListSlide> {

  @override
  Widget build(BuildContext context) {

    StateController<int> countSlide = ref.watch(counterSlide.notifier);
    final delId = ref.watch(delItemId);
    final delIdd = ref.watch(counterSlide);

    sideSlides.delItem(delId);

    return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: sideSlides.getSlide().length,
              itemBuilder: (BuildContext context, int index) {
                return sideSlides.getSlide()[index];
              },
            ),
          ),
          const SizedBox(height: 7,),
          ElevatedButtonFactory(
            onPressed: (){
              setState(() {
                NavSlideButton navSlideButton = NavSlideButton.buttonID(
                  key: UniqueKey(),
                  buttonId: countSlide.state,
                );
                sideSlides.addSlide(navSlideButton);
                ++countSlide.state;
              });
            },
            child: const Text('Добавить'),
          ),
        ]
    );
  }
}