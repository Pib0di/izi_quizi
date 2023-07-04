import 'package:flutter/material.dart';

ColorScheme colorScheme = ColorScheme.fromSeed(
  // seedColor: const Color(0xe500c37e),
  // seedColor: const Color(0xe585038a),
  // seedColor: Colors.deepPurpleAccent,
  seedColor: const Color(0xE527D2D9),
  // seedColor: const Color(0xE57727D9),
  // brightness: Brightness.dark,
  // primary: const Color(0xE527D2D9),
);

ThemeData basicTheme() => ThemeData(
      listTileTheme: const ListTileThemeData(
        tileColor: Color(0xE5EF0808),
      ),

      tabBarTheme: TabBarTheme(
        // labelColor: colorScheme.onPrimary,
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
      colorScheme: colorScheme.copyWith(secondary: Colors.white54),
      // buttonTheme: const ButtonThemeData(
      //   height: 80,
      //   buttonColor: Colors.deepPurple,
      //   textTheme: ButtonTextTheme.accent,
      // ),

      // bottomAppBarColor: Colors.deepPurple,
      // cardColor: Colors.orange.shade100,
      // scaffoldBackgroundColor: Colors.yellow,
    );
