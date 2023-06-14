import 'package:flutter/material.dart';

ColorScheme colorScheme = ColorScheme.fromSeed(
  // seedColor: const Color(0xe500c37e),
  // seedColor: const Color(0xe585038a),
  // seedColor: Colors.deepPurpleAccent,
  // seedColor: Color(0xE527D2D9),
  seedColor: Color(0xE527D2D9),
  // brightness: Brightness.dark,
  // primary: const Color(0xE527D2D9),
);

ThemeData basicTheme() => ThemeData(
      colorScheme: colorScheme,
    // primaryColor: const Color(0xBFF69910),

      // appBarTheme: AppBarTheme(
      //   color: Color(0xFF78AF5D),
      //   backgroundColor: Color(0xFF78AF5D),
      // ),
      listTileTheme: const ListTileThemeData(
        tileColor: Color(0xE5EF0808),
      ),

      tabBarTheme: TabBarTheme(
        labelColor: colorScheme.onPrimary,
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          color: colorScheme.onPrimary,
        ),
        backgroundColor: colorScheme.secondary,
      ),
      scaffoldBackgroundColor: colorScheme.background,
      elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            colorScheme.primary,
          ),
          foregroundColor: MaterialStateProperty.all(
            colorScheme.onPrimary,
          ),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.background,
        contentTextStyle: TextStyle(
          color: colorScheme.onBackground,
        ),
      ),
      iconTheme: IconThemeData(
        color: colorScheme.secondary,
      ),
      // textTheme: TextTheme(
      //   headline6: const TextStyle(
      //     fontFamily: FontNameTitle,
      //     fontSize: MediumTextSize,
      //     color: Colors.purple,
      //   ),
      //   headline4: TextStyle(
      //     fontFamily: FontNameDefault,
      //     fontSize: MediumTextSize,
      //     fontWeight: FontWeight.w800,
      //     color: kSecondaryColor,
      //   ),
      //   bodyText1: const TextStyle(
      //     fontFamily: FontNameDefault,
      //     fontSize: BodyTextSize,
      //     color: Colors.green,
      //   ),
      // ),

      // iconTheme: const IconThemeData(
      //   // color: Colors.red,
      //   size: 25.0,
      //   color: Colors.black54,
      // ),
      //
      // floatingActionButtonTheme: const FloatingActionButtonThemeData(
      //   backgroundColor: Colors.red,
      //   foregroundColor: Colors.purple,
      // ),

      accentColor: Colors.orange,
      // buttonTheme: const ButtonThemeData(
      //   height: 80,
      //   buttonColor: Colors.deepPurple,
      //   textTheme: ButtonTextTheme.accent,
      // ),

      // bottomAppBarColor: Colors.deepPurple,
      // cardColor: Colors.orange.shade100,
      // scaffoldBackgroundColor: Colors.yellow,
    );
