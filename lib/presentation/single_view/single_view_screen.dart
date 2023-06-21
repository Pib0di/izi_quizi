import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/data/repository/server/server_data.dart';
import 'package:izi_quizi/presentation/multiple_view/multiple_view_screen.dart';
import 'package:izi_quizi/presentation/multiple_view/multiple_view_state.dart';
import 'package:izi_quizi/presentation/single_view/single_view_state.dart';

class SingleViewPresentation extends ConsumerStatefulWidget {
  const SingleViewPresentation({super.key});

  @override
  SingleViewPresentationState createState() => SingleViewPresentationState();
}

class SingleViewPresentationState
    extends ConsumerState<SingleViewPresentation> {
  @override
  Widget build(BuildContext context) {
    ref
      ..watch(singleViewProvider)
      ..watch(multipleViewProvider);
    final singleViewController = ref.read(singleViewProvider.notifier);
    final multipleViewController = ref.read(multipleViewProvider.notifier);
    final appDataController = ref.read(appDataProvider.notifier);

    final totalSlide = singleViewController.getTotalSlide();

    //get the current slide number
    final numSelectSlide = singleViewController.getState();

    singleViewController.context = context;
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            SizedBox(
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      final addDataController =
                          ref.read(appDataProvider.notifier);
                      removeUser(addDataController.idUserInRoom,
                          addDataController.getIdRoom());
                      Navigator.pop(context);
                    },
                    padding: const EdgeInsets.all(0),
                    icon: Icon(
                      Icons.exit_to_app,
                      size: 40,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    padding: const EdgeInsets.all(0),
                    icon: Icon(
                      Icons.fullscreen_sharp,
                      size: 40,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  if (multipleViewController.isManager ||
                      multipleViewController.isStart)
                    IconButton(
                      onPressed: () {
                        if (multipleViewController.isHideMenu) {
                          multipleViewController.isHideMenu = false;
                        } else {
                          multipleViewController.isHideMenu = true;
                        }
                        multipleViewController.updateUi();
                      },
                      // tooltip: multipleViewController.isHideMenu
                      //     ? ' боковую панель'
                      //     : 'Скрыть боковую панель',
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        multipleViewController.isHideMenu
                            ? Icons.arrow_back
                            : Icons.arrow_forward,
                        size: 40,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                ],
              ),
            ),
            if (multipleViewController.isManager &&
                multipleViewController.isShowReporting)
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    'ID',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '№ слайда',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Тип слайда',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Ответ',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                                height: 600,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                ),
                                child: const ReportWidget()),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(child: PresentationViewport()),
                  ],
                ),
              ),
            if (!multipleViewController.isManager ||
                !multipleViewController.isShowReporting)
              const Expanded(child: PresentationViewport()),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Text(
                    '${numSelectSlide + 1}/${totalSlide + 1}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  if (multipleViewController.isManager)
                    OutlinedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: (BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        )),
                      ),
                      icon: Icon(
                        Icons.newspaper,
                        size: 30,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      label: Text(
                        'Показать отчетность',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                      onPressed: () {
                        multipleViewController.isShowReporting =
                            !multipleViewController.isShowReporting;
                        multipleViewController.updateUi();
                      },
                    ),
                  SizedBox(
                    width: 10,
                  ),
                  OutlinedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: (BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      )),
                    ),
                    icon: Icon(
                      Icons.people,
                      size: 30,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    label: Text(
                      multipleViewController.getUserListLength() - 1 < 0
                          ? '0'
                          : (multipleViewController.getUserListLength() - 1)
                              .toString(),
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  if (multipleViewController.isManager)
                    VerticalDivider(
                      indent: 6,
                      endIndent: 6,
                      thickness: 2,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  const SizedBox(
                    width: 5,
                  ),
                  if (multipleViewController.isManager)
                    IconButton(
                      onPressed: () {
                        singleViewController.decrement();
                        presentationManagement(
                          'set-${singleViewController.getState()}',
                          appDataController.getIdRoom(),
                        );
                      },
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 40,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                  const SizedBox(
                    width: 20,
                  ),
                  if (multipleViewController.isManager)
                    IconButton(
                      onPressed: () {
                        singleViewController.increment();
                        presentationManagement(
                          'set-${singleViewController.getState()}',
                          appDataController.getIdRoom(),
                        );
                      },
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 40,
                        color: Theme.of(context).colorScheme.outlineVariant,
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
                    decoration: widget.url != null
                        ? BoxDecoration(
                            image: DecorationImage(
                              // image: NetworkImage(widget.url),
                              image: CachedNetworkImageProvider(widget.url!),
                              fit: BoxFit.cover,
                            ),
                          )
                        : const BoxDecoration(),
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
    final slideNum = ref.watch(singleViewProvider) as int;
    ref.watch(multipleViewProvider);
    final slideDataController = ref.read(slideDataProvider.notifier);

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
                  // color: Colors.grey[350],
                  color: Theme.of(context).colorScheme.background,
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
                      Consumer(
                        builder: (context, ref, _) {
                          ref.watch(multipleViewProvider);
                          return IndexedStack(
                            sizing: StackFit.expand,
                            index: slideNum,
                            children: slideDataController.getSlideSingleView(),
                            // children: <Widget>[
                            //   for (SlideItems name in ref
                            //       .read(slideDataProvider.notifier)
                            //       .getListSlide())
                            //     (name.getSlideView()),
                            // ],
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
    );
  }
}
