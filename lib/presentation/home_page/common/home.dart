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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'Ваши презентации',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 150,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        final position = homePageController.currentPosition;
                        if ((position - 198) >= 0) {
                          homePageController.currentPosition -= 198;
                        } else {
                          homePageController.currentPosition = 0;
                        }
                        homePageController.scrollController.animateTo(
                          homePageController.currentPosition,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 40,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14.0),
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: ListView.builder(
                          clipBehavior: Clip.none,
                          controller: homePageController.scrollController,
                          itemCount:
                              getUserPresentations(homePageController).length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onPanUpdate: (details) {
                                final position =
                                    homePageController.currentPosition;
                                if ((position - details.delta.dx) >= 0 &&
                                    (position - details.delta.dx) <=
                                        homePageController.scrollController
                                            .position.maxScrollExtent) {
                                  homePageController.currentPosition -=
                                      details.delta.dx;
                                }
                                homePageController.scrollController
                                    .jumpTo(homePageController.currentPosition);
                              },
                              child: getUserPresentations(
                                  homePageController)[index],
                            );
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        final position = homePageController.currentPosition;
                        if ((position + 198) <=
                            homePageController
                                .scrollController.position.maxScrollExtent) {
                          homePageController.currentPosition += 198;
                        } else {
                          homePageController.currentPosition =
                              homePageController
                                  .scrollController.position.maxScrollExtent;
                        }
                        homePageController.scrollController.animateTo(
                          homePageController.currentPosition,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 40,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  children: [
                    Text(
                      'Общедоступные презентации',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    RawMaterialButton(
                      // fillColor: Theme.of(context).colorScheme.errorContainer,
                      shape: const CircleBorder(),
                      elevation: 0.0,
                      onPressed: getPublicListPresentation,
                      child: Icon(
                        Icons.refresh,
                        weight: 3,
                        // color: Theme.of(context).colorScheme.onPrimary,
                        color: Theme.of(context).colorScheme.onBackground,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Wrap(
                  runSpacing: 10.0,
                  // spacing: 10,
                  alignment: WrapAlignment.start,
                  children: getPublicPresentations(homePageController),
                ),
              ),
              const SizedBox(
                height: 100,
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
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
      // color: Colors.black,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          strokeAlign: BorderSide.strokeAlignOutside,
          color: Theme.of(context).colorScheme.surfaceVariant,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            // offset: const Offset(-4, 7), // changes position of shadow
            offset: const Offset(0, 0),
          ),
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
      child: Form(
        key: homePageController.formKey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                validator: nameUserValidator,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    homePageController.formKey.currentState!.validate();
                  }
                },
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
                validator: nameUserValidator,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    homePageController.formKey.currentState!.validate();
                  }
                },
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
    ),
    const SizedBox(
      width: 15,
      height: 15,
    ),
    ElevatedButton(
      onPressed: () {
        if (homePageController.formKey.currentState!.validate()) {
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
        }
      },
      style: ElevatedButton.styleFrom(
        padding:
            const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 22),
      ),
      child: Text(
        'Присоедениться',
        style: TextStyle(
          fontSize: 20,
          color: colorScheme.onPrimary,
        ),
      ),
    ),
  ];
}

String? nameUserValidator(String? text) {
  if (text == null || text.isEmpty) {
    return 'Заполните поле';
  }
  return null;
}