import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/domain/home_page/home_page.dart';
import 'package:izi_quizi/main.dart';
import 'package:izi_quizi/presentation/authentication/authentication_popup_screen.dart';
import 'package:izi_quizi/presentation/home_page/common/join_presentation.dart';
import 'package:izi_quizi/presentation/home_page/common/popup_menu.dart';
import 'package:izi_quizi/presentation/home_page/common/present_card.dart';
import 'package:izi_quizi/presentation/home_page/home_page_state.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    request.listWidget(AppDataState.idUser);
  }

  void setStates() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AppDataState().widgetRef(ref);

    final validAuth = ref.watch(homePage.notifier).isAuth;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        toolbarHeight: 50,
        leadingWidth: 120,
        leading: const Center(
          child: Text(
            'IziQuizi',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(left: 150),
            child: TabBar(
              labelColor: Colors.white60,
              indicatorColor: Colors.green[800],
              isScrollable: true,
              controller: _tabController,
              tabs: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.home),
                      SizedBox(width: 5),
                      Text('Дом'),
                    ],
                  ),
                ),
                if (validAuth)
                  (Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.av_timer),
                        SizedBox(width: 5),
                        Text('Мероприятия'),
                      ],
                    ),
                  )),
                if (validAuth)
                  (Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.people),
                        SizedBox(width: 5),
                        Text('Комнаты'),
                      ],
                    ),
                  ))
              ],
            ),
          ),
          const Spacer(),
          Center(
            child: OutlinedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade300,
                padding: const EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: (const BorderSide(
                  color: Colors.transparent,
                )),
              ),
              icon: const Icon(
                Icons.add,
                size: 18,
                color: Colors.white,
              ),
              label: const Text(
                'Создать',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                HomePageCase().createQuizDialog(context);
                setStates();
              },
            ),
          ),
          const PopupMenu(),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          FutureBuilder<List<String>>(
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              final presentCardList = <Widget>[];
              for (var i = 0;
                  i < AppDataState().getUserPresentName().length;
                  ++i) {
                presentCardList.add(
                  PresentCard(
                    idPresent: int.parse(
                      AppDataState().getUserPresentName().keys.elementAt(i),
                    ).toInt(),
                    presentName:
                        AppDataState().getUserPresentName().values.elementAt(i),
                  ),
                );
              }
              return ListView(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
                children: [
                  const JoinThePresentation(),
                  const SizedBox(
                    height: 90,
                  ),
                  Wrap(
                    runSpacing: 10.0,
                    spacing: 10,
                    alignment: WrapAlignment.start,
                    children: presentCardList,
                  ),
                ],
              );
            },
          ),
          FutureBuilder<String>(
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (validAuth) {
                return const TabBarEvents();
              }
              return Center(
                // heightFactor: MediaQuery.of(context).size.height+500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [TabBarEvents()],
                ),
              );
            },
          ),
          FutureBuilder<String>(
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                if (validAuth) {
                  // return Join();
                  children = <Widget>[
                    const Center(
                      child: Text("It's sunny here"),
                    ),
                    const AlertDialog(
                      content: Text('Hi'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Result: ${snapshot.data}'),
                    ),
                  ];
                } else {
                  return const Join();
                }
              } else if (snapshot.hasError) {
                if (validAuth) {
                  // return Join();
                  children = <Widget>[
                    const Center(
                      child: Text("It's sunny here"),
                    ),
                    const AlertDialog(
                      content: Text('Hi'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Result: ${snapshot.data}'),
                    ),
                  ];
                } else {
                  return const Join();
                }
              } else {
                children = const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  ),
                ];
              }
              return Center(
                // heightFactor: MediaQuery.of(context).size.height+500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              );
            },
          ),
        ],
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
              currentList(context),
              created(context),
            ],
          ),
        ),
      ],
    );
  }
}

ListView currentList(BuildContext context) {
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

Container created(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.1,
    ),
    // height: 1000,
    // color: Colors.teal,
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
