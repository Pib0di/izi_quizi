import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/server/server_data.dart';
import 'package:izi_quizi/utils/theme.dart';

/// number of the current slide
final multipleViewProvider = StateNotifierProvider((ref) {
  return MultipleViewState(ref);
});

// state - number of the selected slide
class MultipleViewState extends StateNotifier<int> {
  MultipleViewState(this.ref) : super(0);

  Ref ref;
  bool isManager = false;
  Map<String, dynamic> userList = {};
  List<Widget> userListWidget = [];
  bool isShowReporting = false;

  void setUserList(Map<String, dynamic> userPresentName) {
    userList.clear();
    userList = userPresentName;
    initUserListWidget();
    updateUi();
    print('userList => $userList');
  }

  List<Widget> getUserWidgets() {
    return userListWidget;
  }

  bool isStart = false;
  bool isHideMenu = false;

  void start() {
    presentationManagement('start', ref.read(appDataProvider.notifier).idRoom);
    isStart = true;
    isHideMenu = true;
    updateUi();
  }

  void stop() {
    presentationManagement('stop', ref.read(appDataProvider.notifier).idRoom);
    isStart = false;
    updateUi();
  }

  void addUserWidget(String userName, String idUser) {
    userListWidget.add(
      UserListItem(
        userName: userName,
        idUser: idUser,
      ),
    );
  }

  void initUserListWidget() {
    userListWidget.clear();
    for (var i = 0; i < userList.length; ++i) {
      addUserWidget(
        userList.values.elementAt(i),
        userList.keys.elementAt(i).toString(),
      );
    }
  }

  int getUserListLength() {
    return userList.length;
  }

  String idUser() {
    return ref.read(appDataProvider.notifier).idUser;
  }

  void updateUi() {
    ++state;
  }
}

class UserListItem extends ConsumerWidget {
  const UserListItem({required this.userName, required this.idUser, super.key});

  final String userName;
  final String idUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appDataController = ref.read(appDataProvider.notifier);
    print('${appDataController.idUserInRoom} ======= $idUser');
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorScheme.secondaryContainer,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  appDataController.idUserInRoom == idUser
                      ? 'Вы: $userName'
                      : userName,
                  style: TextStyle(
                    color: colorScheme.secondary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (ref.read(multipleViewProvider.notifier).isManager)
              IconButton(
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  backgroundColor: colorScheme.errorContainer,
                  foregroundColor: colorScheme.errorContainer,
                ),
                tooltip: 'Исключить пользователя',
                onPressed: () {
                  final addDataController = ref.read(appDataProvider.notifier);
                  removeUser(idUser, addDataController.getIdRoom());
                },
                padding: const EdgeInsets.all(0),
                icon: Icon(
                  Icons.close,
                  size: 40,
                  color: colorScheme.error,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
