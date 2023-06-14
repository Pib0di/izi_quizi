import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/server/server_data.dart';
import 'package:izi_quizi/domain/home_page_case.dart';
import 'package:izi_quizi/presentation/home_page/home_page_state.dart';
import 'package:izi_quizi/presentation/multiple_view/multiple_view_state.dart';
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
          margin: const EdgeInsets.symmetric(
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
    final homePageController = ref.read(homePageProvider.notifier);
    homePageController.context = context;
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
                children: listElement(
                  ref,
                ),
              ),
            );
          } else {
            return Row(
              children: listElement(
                ref,
              ),
            );
          }
        },
      ),
    );
  }
}

List<Widget> listElement(WidgetRef ref) {
  final homePageController = ref.read(homePageProvider.notifier);
  return <Widget>[
    Expanded(
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: homePageController.joinPresentTextController,
              decoration: InputDecoration(
                // fillColor: Theme.of(context).colorScheme.onSecondaryContainer,
                filled: true,
                fillColor: colorScheme.onPrimary,
                border: const OutlineInputBorder(),
                labelText: 'Код присоединения',
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextFormField(
              controller: homePageController.nameController,
              decoration: InputDecoration(
                // fillColor: Theme.of(context).colorScheme.onSecondaryContainer,
                filled: true,
                fillColor: colorScheme.onPrimary,
                border: const OutlineInputBorder(),
                labelText: 'Никнейм',
              ),
            ),
          ),
        ],
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
        ref.read(appDataProvider.notifier).viewingMode = true;
        ref.read(multipleViewProvider.notifier).isManager = false;
        final userName = homePageController.nameController.text;
        final roomId = homePageController.joinPresentTextController.text;
        ref.read(appDataProvider.notifier).idRoom = roomId;
        joinTheRoom(
          userName,
          roomId,
        );
        getUserRoom(
          userName,
          roomId,
        );
        // final idPresent = int.parse(roomId.split('-')[1]);
        // getPresentation(idPresent);
      },
    ),
  ];
}
