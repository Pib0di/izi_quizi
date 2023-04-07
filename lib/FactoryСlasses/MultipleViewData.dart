import 'package:flutter/widgets.dart';

class MultipleViewData{
  static final MultipleViewData _instance = MultipleViewData._internal();
  factory MultipleViewData() { return _instance; }
  MultipleViewData._internal();

  Map<String, dynamic> userList = {};
  void setUserList(Map<String, dynamic> userPresentName){
    userList = userPresentName;
  }
  Map<String, dynamic> getUserList(){
    return userList;
  }

  void initUserListWidget(){
    for(int i = 0; i < userList.length; ++i)
    {
      addUserWidget(userList.values.elementAt(i));
    }
  }

  List<Widget> userListWidget = [];
  addUserWidget(String userName){
    userListWidget.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(userName),
        )
    );
  }

  List<Widget> getUserWidgets(){
    return userListWidget;
  }
}