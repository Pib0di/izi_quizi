

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';

class AppData{
  static final AppData _instance = AppData._internal();
  factory AppData() { return _instance; }
  AppData._internal();

  // set of user presentations
  Map<String, dynamic> userPresentName = {};
  void setUserPresentName(Map<String, dynamic> userPresentName){
    this.userPresentName = userPresentName;
  }
  Map<String, dynamic> getUserPresentName(){
    return userPresentName;
  }


  // authentication ui Update
  WidgetRef? ref;
  static const bool isAuth = false;
  final isAuthorized = StateProvider<bool>(
        (ref) => isAuth,
  );

  void widgetRef (WidgetRef ref){
    this.ref = ref;
  }
  StateController<bool> authStateController(){
    return ref!.watch(isAuthorized.notifier);
  }
  StateProvider<bool> authStateProvider(){
    return isAuthorized;
  }
  void authentication (bool valid){
    // ref!.watch(isAuthorized.notifier).state = valid;
    ref!.refresh(isAuthorized.notifier).state = valid;
  }


}