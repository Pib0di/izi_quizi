import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [TabBarEvents()],
      ),
    );
  }
}

class TabBarEvents extends StatefulWidget {
  const TabBarEvents({super.key});

  @override
  State<TabBarEvents> createState() => TabBarEventsState();
}

class TabBarEventsState extends State<TabBarEvents>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: TabBar(
            unselectedLabelColor: Colors.teal,
            labelColor: Colors.lightBlue,
            indicatorColor: Colors.teal,
            controller: tabController,
            tabs: const <Widget>[
              Tab(text: 'Текущие'),
              Tab(text: 'Завершенные'),
              Tab(text: 'Созданные'),
            ],
          ),
        ),
        // SizedBox(width: 400,),
        Container(
          color: Colors.grey[200],
          // padding: const EdgeInsets.only(left: 20),
          height: MediaQuery.of(context).size.height - 104,
          // height: 400,
          width: double.maxFinite,
          child: TabBarView(
            controller: tabController,
            children: [
              current(context),
              completed(context),
              created(context),
            ],
          ),
        ),
      ],
    );
  }
}

Container current(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.1,
    ),
    height: 1000,
    color: Colors.teal,
    child: ListView(
      children: [
        Container(
          height: 1000,
        )
      ],
    ),
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
