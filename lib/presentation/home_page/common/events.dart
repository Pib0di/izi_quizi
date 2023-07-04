import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/domain/home_page_case.dart';
import 'package:izi_quizi/presentation/home_page/home_page_state.dart';
import 'package:izi_quizi/utils/theme.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: TabBarEvents(),
    );
  }
}

class TabBarEvents extends ConsumerStatefulWidget {
  const TabBarEvents({super.key});

  @override
  TabBarEventsState createState() => TabBarEventsState();
}

class TabBarEventsState extends ConsumerState<TabBarEvents>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final homePageController = ref.read(homePageProvider.notifier);
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            color: colorScheme.secondaryContainer,
            child: TabBar(
              unselectedLabelColor: colorScheme.onSecondaryContainer,
              labelColor: colorScheme.primary,
              indicatorColor: colorScheme.secondary,
              controller: tabController,
              tabs: const <Widget>[
                Tab(
                  child: Text(
                    'Текущие',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Завершенные',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Созданные',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // SizedBox(width: 400,),
        SizedBox(
          // color: Colors.grey[200],
          // padding: const EdgeInsets.only(left: 20),
          // height: MediaQuery.of(context).size.height - 104,
          height: 180,
          width: double.maxFinite,
          child: TabBarView(
            controller: tabController,
            children: [
              current(context),
              Container(
                padding: const EdgeInsets.all(14.0),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: ListView.builder(
                  clipBehavior: Clip.none,
                  controller: homePageController.scrollController,
                  itemCount: getUserPresentations(homePageController).length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onPanUpdate: (details) {
                        final position = homePageController.currentPosition;
                        if ((position - details.delta.dx) >= 0 &&
                            (position - details.delta.dx) <=
                                homePageController.scrollController.position
                                    .maxScrollExtent) {
                          homePageController.currentPosition -=
                              details.delta.dx;
                        }
                        homePageController.scrollController
                            .jumpTo(homePageController.currentPosition);
                      },
                      child: getUserPresentations(homePageController)[index],
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(14.0),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: ListView.builder(
                  clipBehavior: Clip.none,
                  controller: homePageController.scrollController,
                  itemCount: getUserPresentations(homePageController).length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onPanUpdate: (details) {
                        final position = homePageController.currentPosition;
                        if ((position - details.delta.dx) >= 0 &&
                            (position - details.delta.dx) <=
                                homePageController.scrollController.position
                                    .maxScrollExtent) {
                          homePageController.currentPosition -=
                              details.delta.dx;
                        }
                        homePageController.scrollController
                            .jumpTo(homePageController.currentPosition);
                      },
                      child: getUserPresentations(homePageController)[index],
                    );
                  },
                ),
              ),
              // created(context),
            ],
          ),
        ),
      ],
    );
  }
}

Container current(BuildContext context) {
  return Container(
    // margin: EdgeInsets.symmetric(
    //   horizontal: MediaQuery.of(context).size.width * 0.1,
    // ),
    height: double.maxFinite,
    color: colorScheme.background,
    child: Padding(
      padding: const EdgeInsets.only(top: 90.0),
      child: Text(
        'Текущие сессии отсутствуют',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: colorScheme.surfaceVariant,
        ),
        textAlign: TextAlign.center,
      ),
    ),

    // ListView(
    //   children: [
    //     Container(
    //       height: 1000,
    //     )
    //   ],
    // ),
  );
}

ListView completed(BuildContext context) {
  return ListView(
    children: [
      Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
        ),
        height: 1000,
        color: Colors.teal,
      ),
    ],
  );
}

Container created(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.1,
    ),
    child: ListView(
      padding: const EdgeInsets.all(10),
      children: [
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff7c94b6),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
                // border: Border.all(
                //   width: 2,
                // ),
                borderRadius: BorderRadius.circular(15),
              ),
              // color: Colors.teal[300],
              height: 200,
              width: 200,
            ),
            Container(
              color: Colors.teal[300],
              height: 400,
              width: 400,
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff7c94b6),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
                // border: Border.all(
                //   width: 2,
                // ),
                borderRadius: BorderRadius.circular(15),
              ),
              // color: Colors.teal[300],
              height: 200,
              width: 200,
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff7c94b6),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
                // border: Border.all(
                //   width: 2,
                // ),
                borderRadius: BorderRadius.circular(15),
              ),
              // color: Colors.teal[300],
              height: 200,
              width: 200,
            ),
            Container(
              color: Colors.teal[300],
              height: 400,
              width: 400,
            ),
            Container(
              color: Colors.teal[300],
              height: 400,
              width: 400,
            ),
            Container(
              color: Colors.teal[300],
              height: 400,
              width: 400,
            ),
          ],
        ),
      ],
    ),
  );
}
