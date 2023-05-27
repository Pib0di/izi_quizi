import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/create_editing_state.dart';
import 'package:izi_quizi/widgets/selection_slide/selection_slide_state.dart';
import 'package:screenshot/screenshot.dart';

class PresentationCreationArea extends ConsumerWidget {
  const PresentationCreationArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slideDataController = ref.read(slideDataProvider.notifier);
    final slidesPreviewController = ref.read(slidesPreviewProvider.notifier);

    slidesPreviewController.screenshotController = ScreenshotController();

    return Expanded(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Screenshot(
            key: UniqueKey(),
            controller: slidesPreviewController.screenshotController,
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
                        // color: Colors.grey[350],
                        color: Theme.of(context).colorScheme.background,
                        // color: Theme.of(context).colorScheme.onTertiaryContainer,
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
                            // listWidgets[count],
                            Consumer(
                              builder: (context, ref, _) {
                                ref
                                  ..watch(selectionSlideProvider)
                                  ..watch(createEditing)
                                  ..watch(delItemKey);
                                var count = ref.watch(currentSlideNumber);

                                if (count > 0) {
                                  --count;
                                } else {
                                  count = 0;
                                }
                                // return SelectionSlide(key: UniqueKey());
                                return IndexedStack(
                                  sizing: StackFit.expand,
                                  index: count,
                                  // children: <Widget>[
                                  //   // for (SlideItems name in slideDataController.getListSlide())
                                  //   //   name.getSlide(),
                                  //   slideDataController.getSlide(),
                                  // ],
                                  children: slideDataController.getSlide(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
