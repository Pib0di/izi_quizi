import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/presentation/single_view/single_view_state.dart';
import 'package:izi_quizi/widgets/slide_item.dart';

class SingleViewPresentation extends ConsumerStatefulWidget {
  const SingleViewPresentation({super.key});

  @override
  ViewPresentationState createState() => ViewPresentationState();
}

class ViewPresentationState extends ConsumerState<SingleViewPresentation> {

  @override
  Widget build(BuildContext context) {
    final stateController = ref.watch(singleView.notifier);

    final totalSlide = stateController.getTotalSlide();

    //get the current slide number
    final numSelectSlide = ref.watch(singleView) as int;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.exit_to_app,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.fullscreen_sharp,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(child: PresentationViewport()),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Text('${numSelectSlide + 1}/${totalSlide + 1}'),
                  const Spacer(),
                  IconButton(
                    onPressed: stateController.decrement,
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  IconButton(
                    onPressed: stateController.increment,
                    icon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
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
  const ItemsViewPresentation.imageWidgetJson({
    required this.width,
    required this.height,
    required this.left,
    required this.top,
    this.url,
    this.text,
    super.key,
  });

  const ItemsViewPresentation.textWidgetJson({
    required this.width,
    required this.height,
    required this.left,
    required this.top,
    this.url,
    this.text,
    super.key,
  });

  final String? text;
  final String? url;
  final double width, height;
  final double left, top;

  @override
  ItemsViewPresentationState createState() => ItemsViewPresentationState();
}

class ItemsViewPresentationState extends ConsumerState<ItemsViewPresentation> {

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.text = widget.text ?? '';

    return RepaintBoundary(
      child: Transform.rotate(
        angle: 0,
        alignment: Alignment.topLeft,
        child: Stack(
          children: [
            Positioned(
              top: widget.top,
              left: widget.left,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: const EdgeInsets.all(5),
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
                            controller: controller,
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
                  const SizedBox(
                    height: 50,
                    width: 50,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PresentationViewport extends ConsumerWidget {
  const PresentationViewport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slideNum = ref.watch(singleView) as int;

    return Center(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return OverflowBox(
              maxWidth: double.infinity,
              maxHeight: double.infinity,
              child: Transform.scale(
                scale: constraints.maxWidth < 1920
                    ? constraints.maxWidth / 1920
                    : 1920 / constraints.maxWidth,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.grey[350],
                  width: constraints.maxWidth *
                      (constraints.maxWidth < 1920
                          ? 1920 / constraints.maxWidth
                          : constraints.maxWidth / 1920),
                  height: constraints.maxHeight *
                      (constraints.maxWidth < 1920
                          ? 1920 / constraints.maxWidth
                          : constraints.maxWidth / 1920),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      IndexedStack(
                        sizing: StackFit.expand,
                        index: slideNum,
                        children: <Widget>[
                          for (SlideItems name in SlideData().getListSlide())
                            (name.getSlideView()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
