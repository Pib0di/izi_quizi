import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/server/server_data.dart';
import 'package:izi_quizi/domain/home_page_case.dart';
import 'package:izi_quizi/presentation/authentication/authentication_state.dart';
import 'package:izi_quizi/presentation/home_page/common/events.dart';
import 'package:izi_quizi/presentation/home_page/common/home.dart';
import 'package:izi_quizi/presentation/home_page/common/popup_menu.dart';
import 'package:izi_quizi/presentation/home_page/common/rooms.dart';
import 'package:izi_quizi/presentation/home_page/home_page_state.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  late AppDataState appDataController;
  late HomePageController homePageController;
  late AuthenticationController authenticationPopupController;

  @override
  void initState() {
    // запуск веб-сокета!!!
    ref.read(webSocketProvider);
    ref.read(appDataProvider.notifier).checkMobileMode();

    appDataController = ref.read(appDataProvider.notifier);
    homePageController = ref.read(homePageProvider.notifier);
    authenticationPopupController = ref.read(authenticationProvider.notifier);

    ref.read(homePageProvider.notifier).tabController =
        TabController(length: 3, vsync: this);

    getListWidget(appDataController.idUser);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(homePageProvider);

    final validAuth = authenticationPopupController.isAuth;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 50,
        leadingWidth: 120,
        leading: Center(
          child: Text(
            'IziQuizi',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(left: 150),
            child: TabBar(
              isScrollable: true,
              controller: homePageController.tabController,
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
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.av_timer),
                        SizedBox(width: 5),
                        Text('Мероприятия'),
                      ],
                    ),
                  ),
                if (validAuth)
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.people),
                        SizedBox(width: 5),
                        Text('Комнаты'),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const Spacer(),
          Center(
            child: OutlinedButton.icon(
              style: ElevatedButton.styleFrom(
                // backgroundColor: Colors.green.shade300,
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                padding: const EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: (const BorderSide(
                  color: Colors.transparent,
                )),
              ),
              icon: Icon(
                Icons.add,
                size: 18,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              label: Text(
                'Создать',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              onPressed: () {
                createQuizDialog(context, ref);
              },
            ),
          ),
          const PopupMenu(),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            repeat: ImageRepeat.repeat,
            image: AssetImage('assets/image/background.png'),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.background,
                blurRadius: 40, // Установите радиус размытия тени
                spreadRadius: 15, // Установите радиус распространения тени
                offset: Offset(0,
                    -40), // Установите смещение тени по горизонтали и вертикали
              ),
            ],
          ),
          // color: Theme.of(context).colorScheme.background,
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
          ),
          child: TabBarView(
            controller: homePageController.tabController,
            children: const <Widget>[
              HomePageScreen(),
              EventsScreen(),
              RoomsScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
