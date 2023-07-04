import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/data/repository/server/server_data.dart';
import 'package:izi_quizi/presentation/home_page/common/action_dialog.dart';
import 'package:izi_quizi/presentation/home_page/home_page_state.dart';
import 'package:izi_quizi/presentation/single_view/single_view_state.dart';

class PresentCard extends ConsumerStatefulWidget {
  const PresentCard({
    required this.idPresent,
    required this.presentName,
    this.uint8List,
    this.isPublic,
    super.key,
  });

  final Uint8List? uint8List;
  final bool? isPublic;
  final String idPresent;
  final String presentName;

  @override
  PresentCardState createState() => PresentCardState();
}

class PresentCardState extends ConsumerState<PresentCard> {
  @override
  Widget build(BuildContext context) {
    final myValueRef = ref.read(slideDataProvider.notifier).ref;
    final appDataController = ref.read(appDataProvider.notifier);
    return Container(
      margin: const EdgeInsets.only(right: 24),
      decoration: BoxDecoration(
        // image: DecorationImage(
        //   image: Image.memory(uint8List!),
        // ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.outline.withAlpha(40),
            blurRadius: 7,
            spreadRadius: 2,
            offset: const Offset(-5, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            width: 290,
            height: 230,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              // image: DecorationImage(
              //   image: Image.memory(uint8List!),
              // ),
              // color: const Color(0xff7c94b6),
              image: DecorationImage(
                image: MemoryImage(
                  widget.uint8List ?? Uint8List(0),
                ),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: RawMaterialButton(
              // padding: const EdgeInsets.only(bottom: 10),
              shape: const RoundedRectangleBorder(),
              onPressed: () {
                ref.read(singleViewProvider.notifier).set(0);
                // final numSelectSlide = singleViewController.getState();

                getPresentation(widget.idPresent);
                appDataController
                  ..idPresent = widget.idPresent
                  ..presentName = widget.presentName;
                Navigator.of(context).push(
                  PresentationDialog<void>(
                    isPublic: widget.isPublic ?? false,
                    idPresent: widget.idPresent,
                    presentName: widget.presentName,
                    ref: myValueRef,
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    // margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                      color: Color(0xE5DFFFD6),
                      // color: Theme.of(context).colorScheme.surfaceVariant,
                      // borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.w500,
                      ),
                      widget.presentName,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!(widget.isPublic ?? false))
            Positioned(
              right: 0,
              child: Container(
                margin: const EdgeInsets.all(5),
                width: 30,
                height: 30,
                child: RawMaterialButton(
                  // fillColor: Theme.of(context).colorScheme.errorContainer,
                  shape: const CircleBorder(),
                  elevation: 0.0,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          backgroundColor:
                          Theme.of(context).colorScheme.background,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          title: Column(
                            children: [
                              Text(
                                'Удалить презентацию:',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.presentName,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          children: <Widget>[
                            const SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, ClipRRect);
                                  },
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    padding: const EdgeInsets.all(16.0),
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  child: Text(
                                    'Отмена',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    getPublicListPresentation();
                                    deletePresent(
                                      appDataController.email,
                                      widget.idPresent.toString(),
                                    );
                                    ScaffoldMessenger.of(
                                      ref
                                          .read(homePageProvider.notifier)
                                          .context!,
                                    ).showSnackBar(
                                      const SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        duration: Duration(seconds: 2),
                                        content: Center(
                                          child: Text(
                                            'Процесс удаления...',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                    Navigator.pop(context, ClipRRect);
                                  },
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    padding: const EdgeInsets.all(16.0),
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  child: Text(
                                    'Удалить',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Icon(
                    Icons.cancel,
                    // color: Theme.of(context).colorScheme.onPrimary,
                    color: Theme.of(context).colorScheme.error.withAlpha(80),
                    size: 30,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
