

// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repository/local/slide_data.dart';
import '../../Widgets/slide_item.dart';
import '../riverpod/single_view/single_view_state.dart';

class SingleViewPresentation extends ConsumerStatefulWidget {
  const SingleViewPresentation({Key? key}) : super(key: key);

  @override
  ViewPresentationState createState() => ViewPresentationState();
}

class ViewPresentationState extends ConsumerState<SingleViewPresentation> {
  static const double heightBox = 70;
  static const double heightIcon = heightBox - 30;
  SlideData slideData = SlideData();
  late int slideNum;

  @override
  Widget build(BuildContext context) {
    final totalSlide = slideData.getLengthListSlide() - 1;

    //state management
    final slideCounter = ref.watch(slideNumProvider.notifier);

    //get the current slide number
    final numSelectSlide = ref.watch(slideNumProvider) as int;


    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            SizedBox(
              height: heightBox,
              child: Row(
                children: [
                  IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.exit_to_app,
                        size: heightIcon,
                        color: Colors.grey,
                      ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: (){
                      slideCounter.set(0);
                    },
                    icon: const Icon(
                      Icons.fullscreen_sharp,
                      size: heightIcon,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: PresentationViewport()),
            SizedBox(
              height: heightBox,
              child: Row(
                children: [
                  Text("${numSelectSlide+1}/${totalSlide+1}"),
                  const Spacer(),
                  IconButton(
                    onPressed: (){
                      if (numSelectSlide > 0) {
                        slideCounter.decrement();
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: heightIcon,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8,),
                  IconButton(
                    onPressed: (){
                      if (numSelectSlide < totalSlide) {
                        slideCounter.increment();
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: heightIcon,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemsViewPresentation extends ConsumerStatefulWidget {
  ItemsViewPresentation({
    Key? key,
  }) : super(key: key);
  ItemsViewPresentation.id(Key key, this.itemId) : super(key: key){
    type = "text";
  }
  // ItemsViewPresentation.imageWidget(Key key, this.widgetInit) : super(key: key){
  //   type = "image";
  // }
  ItemsViewPresentation.imageWidgetJson({
    Key? key,
    this.url = '',
    this.width = 300,
    this.height = 100,
    this.left = 200,
    this.top = 200,
  }) : super(key: key){
    type = "image";
  }
  ItemsViewPresentation.textWidgetJson({
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

  final TextEditingController controller = TextEditingController();
  int itemId = 0;
  String text = '';
  String url = '';
  double width = 300, height = 100;
  // Widget? widgetInit;
  double left = 200, top = 200;

  @override
  ItemsViewPresentationState createState() => ItemsViewPresentationState();
}
class ItemsViewPresentationState extends ConsumerState<ItemsViewPresentation> {
  double angle = 0;

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.controller.text = widget.text;
    return RepaintBoundary(
      child: Transform.rotate(
        angle: angle,
        alignment: Alignment.topLeft,
        child: Stack(
            children: [
              Positioned(
                top: widget.top,
                left: widget.left,
                child:
                Stack(
                  clipBehavior: Clip.none,
                  children:[
                    Container(
                      margin: const EdgeInsets.all(5),
                      // decoration: const BoxDecoration(
                      //   image: DecorationImage(
                      //     // image: Image.file(File('dfg')),
                      //     image: Image.file(imageFile).image,
                      //     // image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                      //     fit: BoxFit.cover,
                      //   ),
                      //   borderRadius: BorderRadius.circular(15),
                      // ),
                      height: widget.height,
                      width: widget.width,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: OverflowBox(
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context)
                                .copyWith(scrollbars: false),
                            child: TextField(
                              enabled: false,
                              scrollPhysics: const NeverScrollableScrollPhysics(),
                              textDirection: TextDirection.ltr,
                              controller: widget.controller,
                              clipBehavior: Clip.none,
                              expands: false,
                              maxLines: double.maxFinite.toInt(),
                              scrollPadding: const EdgeInsets.all(0.0),
                              style: const TextStyle(
                                fontSize: 50,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50, width: 50,),
                  ],
                ),
              ),
            ]
        ),
      ),
    );
  }
}

class PresentationViewport extends ConsumerWidget{
  PresentationViewport({Key? key}) : super(key: key);
  SlideData data = SlideData();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slideNum = ref.watch(slideNumProvider) as int;
    return Center(
      child: AspectRatio(
        aspectRatio: 16/9,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
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
                        IndexedStack(
                          sizing: StackFit.expand,
                          index: slideNum,
                          children: <Widget>[
                            for (SlideItems name in data.getListSlide()) (name.getSlideView()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}