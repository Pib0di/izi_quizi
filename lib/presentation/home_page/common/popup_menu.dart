import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/presentation/home_page/authentication/authentication_popup_screen.dart';
import 'package:izi_quizi/presentation/home_page/authentication/authentication_state.dart';
import 'package:izi_quizi/presentation/home_page/home_page_state.dart';

class PopupMenu extends ConsumerWidget {
  const PopupMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authenticationProvider);

    final homePageController = ref.read(homePageProvider.notifier);
    final authenticationController = ref.read(authenticationProvider.notifier);
    final appDataController = ref.read(appDataProvider.notifier);

    if (authenticationController.isAuth) {
      return PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        onSelected: (String item) {
          if (item == 'exit') {
            authenticationController.notAuthorized();
            homePageController.tabController.index = 0;
            appDataController.isAuthorized = false;
            homePageController.userPresentations.clear();
            homePageController.updateUi();
          }
        },
        itemBuilder: (context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            enabled: false,
            child: Text('ID: ${appDataController.idUser}'),
          ),
          PopupMenuItem<String>(
            enabled: false,
            child: Text('Email: ${appDataController.email}'),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem<String>(
            value: 'pref',
            child: Text('Настройки'),
          ),
          const PopupMenuItem<String>(
            value: 'exit',
            child: Text(
              'Выход',
            ),
          ),
        ],
      );
    }
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      onSelected: (String item) => {
        if (item == 'auth')
          {
            showDialog(
              context: context,
              barrierColor:
                  appDataController.isMobile ? Colors.white : Colors.black45,
              barrierDismissible: !appDataController.isMobile,
              builder: (BuildContext context) => const AlertDialog(
                contentPadding: EdgeInsets.zero,
                content: Join(),
              ),
            ),
          },
      },
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          enabled: false,
          child: Text('ID: ${appDataController.idUser}'),
        ),
        PopupMenuItem<String>(
          enabled: false,
          child: Text('Email: ${appDataController.email}'),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'settings',
          child: Text('Настройки'),
        ),
        const PopupMenuItem<String>(
          value: 'auth',
          child: Text(
            'Авторизоваться',
          ),
        ),
      ],
    );
  }
}
