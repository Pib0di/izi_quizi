import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/domain/home_page/home_page.dart';
import 'package:izi_quizi/presentation/home_page/home_page_state.dart';

class JoinThePresentation extends ConsumerWidget {
  const JoinThePresentation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(homePage.notifier).controller;

    return Container(
      padding: const EdgeInsets.all(20),
      // color: Colors.black,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < 470) {
            return SizedBox(
              height: 120,
              child: Column(
                children: listElement(controller),
              ),
            );
          } else {
            return Row(
              children: listElement(controller),
            );
          }
        },
      ),
    );
  }
}

List<Widget> listElement(TextEditingController controller) {
  return <Widget>[
    Expanded(
      child: TextFormField(
        controller: controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Введите код присоединения',
        ),
      ),
    ),
    const SizedBox(
      width: 15,
      height: 15,
    ),
    OutlinedButton.icon(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 23.0, horizontal: 10),
        ),
        backgroundColor: MaterialStateProperty.all(
          Colors.green.shade300,
        ),
        side: MaterialStateProperty.all(
          const BorderSide(
            color: Colors.transparent,
          ),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      icon: const Icon(
        Icons.add,
        size: 18,
        color: Colors.white,
      ),
      label: const Text(
        'Присоедениться',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () {
        HomePageCase().joinRoom('userName', controller.text);
      },
    ),
  ];
}
