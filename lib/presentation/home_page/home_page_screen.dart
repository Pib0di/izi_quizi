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
                createQuizDialog(context, appDataController);
              },
            ),
          ),
          const PopupMenu(),
        ],
      ),
      body: TabBarView(
        controller: homePageController.tabController,
        children: const <Widget>[
          HomePageScreen(),
          EventsScreen(),
          RoomsScreen(),
        ],
      ),
    );
  }
}
