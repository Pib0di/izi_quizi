import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/domain/home_page_case.dart';
import 'package:izi_quizi/presentation/home_page/home_page_state.dart';

class HomePageScreen extends ConsumerWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(homePageProvider);
    final homePageController = ref.read(homePageProvider.notifier);
    return ListView(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
      children: [
        const JoinThePresentation(),
        const SizedBox(
          height: 90,
        ),
        const Text(
          'Общедоступные презентации',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 190,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: getUserPresentations(homePageController),
          ),
        ),
        Wrap(
          runSpacing: 10.0,
          spacing: 10,
          alignment: WrapAlignment.start,
          children: getUserPresentations(homePageController),
        ),
      ],
    );
  }
}

class JoinThePresentation extends ConsumerWidget {
  const JoinThePresentation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homePageController =
        ref.read(homePageProvider.notifier).joinPresentTextController;

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
                children: listElement(homePageController),
              ),
            );
          } else {
            return Row(
              children: listElement(homePageController),
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
        joinTheRoom('userName', controller.text);
      },
    ),
  ];
}
