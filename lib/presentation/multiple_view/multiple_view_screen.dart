import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/server/server_data.dart';
import 'package:izi_quizi/presentation/multiple_view/multiple_view_state.dart';
import 'package:izi_quizi/presentation/single_view/single_view_screen.dart';
import 'package:izi_quizi/presentation/single_view/single_view_state.dart';

class MultipleView extends ConsumerStatefulWidget {
  const MultipleView({super.key});

  @override
  MultipleViewState createState() => MultipleViewState();
}

class MultipleViewState extends ConsumerState<MultipleView> {
  @override
  Widget build(BuildContext context) {
    final multipleViewController = ref.read(multipleViewProvider.notifier);
    final appDataController = ref.read(appDataProvider.notifier);
    ref.watch(multipleViewProvider);

    return Scaffold(
      body: Row(
        children: [
          const Expanded(
            flex: 3,
            child: SingleViewPresentation(),
          ),
          if (!multipleViewController.isHideMenu)
            Expanded(
              flex: 1,
              child: Container(
                color: Theme.of(context).colorScheme.secondary,
                alignment: Alignment.topCenter,
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ID комнаты: ',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              SelectableText(
                                appDataController.getIdRoom(),
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      multipleViewController.isManager
                          ? ElevatedButton(
                              onPressed: () {
                                if (multipleViewController.isStart) {
                                  multipleViewController.stop();
                                } else {
                                  multipleViewController.start();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: multipleViewController.isStart
                                    ? Theme.of(context)
                                        .colorScheme
                                        .errorContainer
                                    : Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: Text(
                                multipleViewController.isStart
                                    ? 'Завершить'
                                    : 'Начать',
                                style: TextStyle(
                                  fontSize: 30,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            )
                          : Text(
                              'Ожидание запуска...',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Container(
                          height: double.maxFinite,
                          padding: const EdgeInsets.all(8.0),
                          child: Consumer(
                            builder: (context, ref, _) {
                              ref.watch(multipleViewProvider);
                              return ListView.builder(
                                itemCount:
                                    multipleViewController.getUserListLength(),
                                itemBuilder: (BuildContext context, int index) {
                                  return multipleViewController
                                      .getUserWidgets()[index];
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class ReportWidget extends ConsumerWidget {
  const ReportWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(multipleViewProvider);
    final singleViewController = ref.read(singleViewProvider.notifier);
    Row row;
    final textWidgetList = <Widget>[];
    final reportWidget = <Widget>[];
    presentationQuizReport.forEach((key, value) {
      for (var i = 0; i < value.numSlideList.length; ++i) {
        if (value.numSlideList[i] ==
            (singleViewController.getState() - 1).toString()) {
          textWidgetList.clear();
          for (var i = 0; i < value.dataList.length; ++i) {
            textWidgetList.add(
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  value.dataList[i],
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
              ),
            );
          }
        }
      }
      row = Row(
        children: [
          Expanded(
            child: Text(
              key,
              style: TextStyle(
                fontSize: 20.0,
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.numSlideList.first.toString(),
              style: TextStyle(
                fontSize: 20.0,
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.typeSlideList.first.toString(),
              style: TextStyle(
                fontSize: 20.0,
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: textWidgetList,
            ),
          ),
        ],
      );
      reportWidget.add(
        row,
      );
      // for (var i = 0; i < value.numSlideList.length; ++i) {
      //   row = Row(
      //     children: [
      //       Expanded(
      //         child: Text(
      //           key,
      //           style: TextStyle(
      //             fontSize: 20.0,
      //             color: Theme.of(context).colorScheme.background,
      //           ),
      //         ),
      //       ),
      //       Expanded(
      //         child: Text(
      //           value.numSlideList.first.toString(),
      //           style: TextStyle(
      //             fontSize: 20.0,
      //             color: Theme.of(context).colorScheme.background,
      //           ),
      //         ),
      //       ),
      //       Expanded(
      //         child: Text(
      //           value.typeSlideList.first.toString(),
      //           style: TextStyle(
      //             fontSize: 20.0,
      //             color: Theme.of(context).colorScheme.background,
      //           ),
      //         ),
      //       ),
      //       Expanded(
      //         child: Text(
      //           value.dataList.first.toString(),
      //           style: TextStyle(
      //             fontSize: 20.0,
      //             color: Theme.of(context).colorScheme.background,
      //           ),
      //         ),
      //       ),
      //     ],
      //   );
      //   reportWidget.add(row,);
      // }
    });
    return ListView(
      children: reportWidget,
    );
  }
}
