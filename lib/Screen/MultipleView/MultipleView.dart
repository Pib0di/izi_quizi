
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../FactoryСlasses/SideSlides.dart';
import '../../main.dart';
import '../SingleView/ViewPresentation.dart';

class MultipleView extends ConsumerStatefulWidget {
  const MultipleView({Key? key}) : super(key: key);

  @override
  _MultipleViewState createState() => _MultipleViewState();
}

class _MultipleViewState extends ConsumerState<MultipleView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Expanded(
            flex: 3,
            child: ViewPresentation(),
          ),
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SelectableText(
                                idUser,
                                style: const TextStyle(fontSize: 18.0),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20,),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        ElevatedButton(
                            onPressed: (){

                            },
                            child: const Text("Начать")
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          height: 300,
                          padding: const EdgeInsets.all(8.0),
                          child: Expanded(
                            child: ListView.builder(
                              itemCount: multipleViewData.getUserList().length,
                              itemBuilder: (BuildContext context, int index) {
                                multipleViewData.initUserListWidget();
                                return multipleViewData.getUserWidgets()[index];
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
          ),
        ],
      ),
    );
  }
}
