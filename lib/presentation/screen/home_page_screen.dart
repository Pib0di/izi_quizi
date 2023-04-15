import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/domain/home_page/home_page_impl.dart';
import 'package:izi_quizi/presentation/screen/single_view_screen.dart';

import '../../data/repository/local/app_data.dart';
import '../../data/repository/local/slide_data.dart';
import '../../main.dart';
import '../riverpod/home_page/home_page_state.dart';
import 'authentication_popup_screen.dart';
import 'creating_editing_screen.dart';
import 'multiple_view_screen.dart';

HomePageCaseImpl homePageCase = HomePageCaseImpl();


class MyStatefulWidget extends ConsumerStatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  MyStatefulWidgetState createState() => MyStatefulWidgetState();
}

class MyStatefulWidgetState extends ConsumerState<MyStatefulWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void setStates() {
    setState(() {
      request.listWidget(AppData.idUser);
      if (widgetListIsReload) {
        widgetListIsReload = false;
      } else {}
    });
  }


  @override
  Widget build(BuildContext context) {
    appData.widgetRef(ref);

    // bool isAuth = ref.watch(appData.authStateProvider());
    bool validAuth = ref.watch(isAuthorized.notifier).isAuth;

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

        // title: const Text('TabBar Widget'),
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
                      Text("Дом"),
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
                        Text("Мероприятия"),
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
                        Text("Комнаты"),
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
                "Создать",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                homePageCase.createQuizDialog(context);
                setStates();
              },
            ),
          ),
          popapMenu(context),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          FutureBuilder<List<String>>(builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            List<Widget> presentCardList = <Widget>[];
            for (int i = 0; i < appData.getUserPresentName().length; ++i) {
              presentCardList.add(PresentCard(
                idPresent: int.parse(appData.getUserPresentName().keys.elementAt(i)).toInt(),
                presentName: appData.getUserPresentName().values.elementAt(i),
              ));
            }
            return ListView(
              padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
              children: [
                JoinThePresentation(),
                const SizedBox(
                  height: 90,
                ),
                Wrap(
                    runSpacing: 10.0,
                    spacing: 10,
                    alignment: WrapAlignment.start,
                    children: presentCardList),
              ],
            );
          }),
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
                      content: Text("Hi"),
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
                      content: Text("Hi"),
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

Widget popapMenu(BuildContext context) {
  bool isAuth = appData.authStateController().state;

  if (isAuth) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      onSelected: (String item) {
        if (item == "exit") {
          appData.authStateController().state = false;
        }
      },
      itemBuilder: (context) => const <PopupMenuEntry<String>>[
        PopupMenuDivider(),
        PopupMenuItem<String>(
          value: "pref",
          child: Text("Настройки"),
        ),
        PopupMenuItem<String>(
          value: "exit",
          child: Text(
            "Выход",
          ),
        ),
      ],
    );
  }
  return PopupMenuButton<String>(
    padding: EdgeInsets.zero,
    onSelected: (String item) => {
      if (item == "auth") {
        showDialog(
            context: context,
            barrierColor: AppData.typeBrowser == 'Mobile'
                ? Colors.white
                : Colors.black45,
            barrierDismissible: AppData.typeBrowser == 'Mobile'
                ? false
                : true,
            builder: (BuildContext context) => const AlertDialog(
              // contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              contentPadding: EdgeInsets.zero,
              // backgroundColor: Colors.transparent,
              content: Join(),
            )),
      },

    },
    itemBuilder: (context) => const <PopupMenuEntry<String>>[
      PopupMenuDivider(),
      PopupMenuItem<String>(
        value: "settings",
        child: Text("Настройки"),
      ),
      PopupMenuItem<String>(
        value: "auth",
        child: Text(
          "Авторизоваться",
        ),
      ),
    ],
  );
}

class TabBarEvents extends StatefulWidget {
  const TabBarEvents({Key? key}) : super(key: key);

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
          child: TabBarView(controller: tabController, children: [
            current(context),
            currentList(context),
            created(context),
          ]),
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
            horizontal: MediaQuery.of(context).size.width * 0.1),
        height: 1000,
        color: Colors.teal,
      ),
    ],
  );
}

Container current(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.1),
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
    margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1),
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
                  image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
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
                  image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
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
                  image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
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

class JoinThePresentation extends StatelessWidget {
  JoinThePresentation({Key? key}) : super(key: key);

  static final TextEditingController controller = TextEditingController();
  final List<Widget> _list = <Widget>[
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
        print("roomId => ${controller.text}");
        homePageCase.joinRoom("userName", controller.text);
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                  children: _list,
                ),
              );
            } else {
              return Row(
                children: _list,
              );
            }
          }),
    );
  }
}

class PresentCard extends StatefulWidget {
  const PresentCard({
    Key? key,
    required this.idPresent,
    required this.presentName,
  }) : super(key: key);

  final int idPresent;
  final String presentName;

  @override
  State<PresentCard> createState() => _PresentCardState();
}

class _PresentCardState extends State<PresentCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Container(
            width: 190,
            height: 150,
            decoration: BoxDecoration(
              color: const Color(0xff7c94b6),
              image: const DecorationImage(
                image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: RawMaterialButton(
              padding: const EdgeInsets.only(bottom: 10),
              shape: const RoundedRectangleBorder(),
              onPressed: (){
                print("getSlideData");
                request.getPresentation(widget.idPresent, widget.presentName);
                Navigator.of(context).push(PresentationDialog<void>(
                  idPresent: widget.idPresent,
                  presentName: widget.presentName,
                ));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xE5DFFFD6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      widget.presentName,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),


        Positioned(
          right: 0,
          child: Container(
            margin: const EdgeInsets.all(5),
            width: 30,
            height: 30,
            child: RawMaterialButton(
              fillColor: Colors.redAccent,
              shape: const CircleBorder(),
              elevation: 0.0,
              onPressed: () {
                print("email => ${AppData.email}, txt => ${widget.idPresent.toString()}");
                request.deletePresent(AppData.email, widget.idPresent.toString());
              },
              child: const Icon(Icons.delete, size: 20,),
            ),
          ),
        ),
      ],
    );
  }
}

class PresentationDialog<T> extends PopupRoute<T> {
  PresentationDialog({
    Key? key,
    required this.idPresent,
    required this.presentName,
  });

  final int idPresent;
  final String presentName;

  @override
  Color? get barrierColor => Colors.black.withAlpha(0x50);

  // This allows the popup to be dismissed by tapping the scrim or by pressing
  // the escape key on the keyboard.
  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Presentation Dialog';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
  SlideData slideData = SlideData();

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Center(
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!,
        // UnconstrainedBox is used to make the dialog size itself
        // to fit to the size of the content.
        child: UnconstrainedBox(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                // Text('Presentation Dialog', style: Theme.of(context).textTheme.headlineSmall),
                ElevatedButton(
                  onPressed: () {
                    // request.getSlideData(idPresent, presentName); //Т.К ДАННЫЕ УЖЕ ЗАПРОШЕНЫ ПРИ НАЖАТИИ
                    slideData.setItemsView();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SingleViewPresentation()),
                    );
                  },
                  child: Row(
                    children: const [
                      Text("Просмотреть"),
                      SizedBox(width: 5,),
                      Icon(
                          Icons.person,
                          color: Colors.green
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    request.createRoom(AppData.idUser, presentName);
                    slideData.setItemsView();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MultipleView()),
                    );
                  },
                  child: Row(
                    children: const [
                      Text("Начать сессию"),
                      SizedBox(width: 5,),
                      Icon(
                          Icons.group,
                          color: Colors.green
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    slideData.setItemsEdit();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PresentationEdit.edit(presentName)),
                    );
                  },
                  child: Row(
                    children: const [
                      Text("Редактировать"),
                      SizedBox(width: 5,),
                      Icon(
                          Icons.edit,
                          color: Colors.green
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}