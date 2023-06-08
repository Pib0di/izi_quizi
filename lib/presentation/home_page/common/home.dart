import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/domain/home_page_case.dart';
import 'package:izi_quizi/presentation/home_page/home_page_state.dart';
import 'package:izi_quizi/utils/theme.dart';

class HomePageScreen extends ConsumerWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(homePageProvider);
    final homePageController = ref.read(homePageProvider.notifier);
    return ListView(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            // horizontal: MediaQuery.of(context).size.width * 0.1,
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 90,
              ),
              const JoinThePresentation(),
              const SizedBox(
                height: 90,
              ),
              Text(
                'Общедоступные презентации',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Theme.of(context).colorScheme.onBackground,
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
          ),
        )
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
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          // BoxShadow(
          //   color: Colors.grey.withOpacity(0.5),
          //   spreadRadius: 2,
          //   blurRadius: 3,
          //   offset: const Offset(0, 2), // changes position of shadow
          // ),
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
        decoration: InputDecoration(
          // fillColor: Theme.of(context).colorScheme.onSecondaryContainer,
          filled: true,
          fillColor: colorScheme.onPrimary,
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
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 23.0, horizontal: 10),
        // backgroundColor: Colors.green.shade300,
        backgroundColor: colorScheme.primaryContainer,
        side: const BorderSide(
          color: Colors.transparent,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: Icon(
        Icons.add,
        size: 18,
        color: colorScheme.onPrimaryContainer,
      ),
      label: Text(
        'Присоедениться',
        style: TextStyle(
          color: colorScheme.onPrimaryContainer,
        ),
      ),
      onPressed: () {
        joinTheRoom('userName', controller.text);
      },
    ),
  ];
}
