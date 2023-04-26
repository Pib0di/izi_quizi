import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:izi_quizi/presentation/home_page/home_page_state.dart';

final appData = StateNotifierProvider((ref) {
  return AppDataState();
});

class AppDataState extends StateNotifier<AppDataState> {
  AppDataState() : super(AppDataState());

  static String idUser = '1';
  static String email = '';
  static String presentName = '';
  static String typeBrowser = 'Browser';
  bool isMobile = false;
  Map<String, dynamic> userPresentations = {};

  void setIdUser(String userId) {
    idUser = userId;
  }

  void setEmail(String userEmail) {
    email = userEmail;
  }

  Future<void> checkMobileMode() async {
    isMobile = await isMobileBrowser();
  }

  void setUserPresentName(Map<String, dynamic> userPresentName) {
    userPresentations = userPresentName;
  }

  Map<String, dynamic> getUserPresentName() {
    return userPresentations;
  }

  WidgetRef? ref;
  static const bool isAuth = false;
  final authorized = StateProvider<bool>(
    (ref) => isAuth,
  );

  void widgetRef(WidgetRef ref) {
    this.ref = ref;
  }

  StateController<bool> authStateController() {
    return ref!.watch(authorized.notifier);
  }

  StateProvider<bool> authStateProvider() {
    return authorized;
  }

  void authentication(bool valid) {
    ref!.refresh(authorized.notifier).state = valid;
    ref!.watch(homePage.notifier).isAuth = valid;
  }
}

Future<bool> isMobileBrowser() async {
  try {
    final response =
        await http.get(Uri.parse('https://httpbin.org/user-agent'));
    final userAgent = response.body;

    if (userAgent.contains('Mobile')) {
      return true;
      // typeBrowser = 'Mobile';
    } else if (userAgent.contains('Browser')) {
      return true;
      // typeBrowser = 'Browser';
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

// class AppDataState {
//   static final AppDataState _instance = AppDataState._internal();
//
//   factory AppDataState() {
//     return _instance;
//   }
//
//   AppDataState._internal();
//
//   static String idUser = '1';
//   static String email = '';
//   static String presentName = '';
//   static String typeBrowser = 'Browser';
//
//   Future<void> checkMobileBrowser() async {
//     final response =
//     await http.get(Uri.parse('https://httpbin.org/user-agent'));
//     final userAgent = response.body;
//
//     if (userAgent.contains('Mobile')) {
//       typeBrowser = 'Mobile';
//     } else if (userAgent.contains('Browser')) {
//       typeBrowser = 'Browser';
//     }
//   }
//
//   // set of user presentations
//   Map<String, dynamic> userPresentName = {};
//
//   void setUserPresentName(Map<String, dynamic> userPresentName) {
//     this.userPresentName = userPresentName;
//   }
//
//   Map<String, dynamic> getUserPresentName() {
//     return userPresentName;
//   }
//
//   // authentication ui Update
//   WidgetRef? ref;
//   static const bool isAuth = false;
//   final authorized = StateProvider<bool>(
//         (ref) => isAuth,
//   );
//
//   void widgetRef(WidgetRef ref) {
//     this.ref = ref;
//   }
//
//   StateController<bool> authStateController() {
//     return ref!.watch(authorized.notifier);
//   }
//
//   StateProvider<bool> authStateProvider() {
//     return authorized;
//   }
//
//   void authentication(bool valid) {
//     ref!.refresh(authorized.notifier).state = valid;
//     ref!.watch(homePage.notifier).isAuth = valid;
//   }
// }
