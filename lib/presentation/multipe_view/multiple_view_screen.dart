import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/presentation/multipe_view/multiple_view_state.dart';
import 'package:izi_quizi/presentation/single_view/single_view_screen.dart';

class MultipleView extends ConsumerStatefulWidget {
  const MultipleView({super.key});

  @override
  MultipleViewState createState() => MultipleViewState();
}

class MultipleViewState extends ConsumerState<MultipleView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final stateController = ref.watch(multipleView.notifier);

    return Scaffold(
      body: Row(
        children: [
          const Expanded(
            flex: 3,
            child: SingleViewPresentation(),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SelectableText(
                              stateController.idUser(),
                              style: const TextStyle(fontSize: 18.0),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Начать'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 300,
                        padding: const EdgeInsets.all(8.0),
                        child: Expanded(
                          child: ListView.builder(
                            itemCount: stateController.getUserListLength(),
                            itemBuilder: (BuildContext context, int index) {
                              stateController.initUserListWidget();
                              return stateController.getUserWidgets()[index];
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
