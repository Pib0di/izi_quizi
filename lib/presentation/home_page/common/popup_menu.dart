import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/presentation/authentication/authentication_popup_screen.dart';
import 'package:izi_quizi/presentation/home_page/home_page_state.dart';

class PopupMenu extends ConsumerWidget {
  const PopupMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuth = ref.watch(homePage.notifier).isAuth;

    if (isAuth) {
      return PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        onSelected: (String item) {
          if (item == 'exit') {
            AppDataState().authStateController().state = false;
          }
        },
        itemBuilder: (context) => const <PopupMenuEntry<String>>[
          PopupMenuDivider(),
          PopupMenuItem<String>(
            value: 'pref',
            child: Text('Настройки'),
          ),
          PopupMenuItem<String>(
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
              barrierColor: AppDataState.typeBrowser == 'Mobile'
                  ? Colors.white
                  : Colors.black45,
              barrierDismissible:
                  AppDataState.typeBrowser == 'Mobile' ? false : true,
              builder: (BuildContext context) => const AlertDialog(
                // contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                contentPadding: EdgeInsets.zero,
                // backgroundColor: Colors.transparent,
                content: Join(),
              ),
            ),
          },
      },
      itemBuilder: (context) => const <PopupMenuEntry<String>>[
        PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'settings',
          child: Text('Настройки'),
        ),
        PopupMenuItem<String>(
          value: 'auth',
          child: Text(
            'Авторизоваться',
          ),
        ),
      ],
    );
  }
}
