import 'package:flutter/material.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: const Color.fromARGB(255, 16, 23, 40),
  background: const Color.fromARGB(255, 123, 218, 209),
);

final theme = ThemeData().copyWith(
  colorScheme: colorScheme,
  scaffoldBackgroundColor: colorScheme.background,
  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 2,
    backgroundColor: colorScheme.primaryContainer,
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(color: colorScheme.secondary),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    alignLabelWithHint: true,
  ),
  textTheme: const TextTheme().copyWith(
    titleLarge: TextStyle(
      color: colorScheme.onPrimaryContainer,
    ),
    titleMedium: TextStyle(
      color: colorScheme.onPrimaryContainer,
    ),
    titleSmall: TextStyle(
      color: colorScheme.onPrimaryContainer,
    ),
    bodyLarge: TextStyle(
      color: colorScheme.onPrimaryContainer,
    ),
    bodyMedium: TextStyle(
      color: colorScheme.onPrimaryContainer,
    ),
    bodySmall: TextStyle(
      color: colorScheme.onPrimaryContainer,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: colorScheme.primaryContainer,
      textStyle: const TextStyle(fontSize: 20),
    ),
  ),
  dividerTheme: DividerThemeData(
    thickness: 2,
    color: colorScheme.primaryContainer,
  ),
  cardTheme: CardTheme(
    color: colorScheme.secondaryContainer,
    clipBehavior: Clip.hardEdge,
    margin: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 10,
    ),
    elevation: 0,
  ),
);

final darkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 16, 23, 40),
  background: Colors.blueGrey,
);

final darkTheme = ThemeData().copyWith(
  colorScheme: darkColorScheme,
  scaffoldBackgroundColor: darkColorScheme.background,
  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 2,
    backgroundColor: darkColorScheme.primaryContainer,
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(color: darkColorScheme.secondary),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    alignLabelWithHint: true,
  ),
  textTheme: const TextTheme().copyWith(
    titleLarge: TextStyle(
      color: darkColorScheme.onPrimaryContainer,
    ),
    titleMedium: TextStyle(
      color: darkColorScheme.onPrimaryContainer,
    ),
    titleSmall: TextStyle(
      color: darkColorScheme.onPrimaryContainer,
    ),
    bodyLarge: TextStyle(
      color: darkColorScheme.onPrimaryContainer,
    ),
    bodyMedium: TextStyle(
      color: darkColorScheme.onPrimaryContainer,
    ),
    bodySmall: TextStyle(
      color: darkColorScheme.onPrimaryContainer,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: darkColorScheme.primaryContainer,
      textStyle: const TextStyle(fontSize: 20),
    ),
  ),
  dividerTheme: DividerThemeData(
    thickness: 2,
    color: darkColorScheme.primaryContainer,
  ),
  cardTheme: CardTheme(
    color: darkColorScheme.secondaryContainer,
    clipBehavior: Clip.hardEdge,
    margin: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 10,
    ),
    elevation: 0,
  ),
);
final gradient = LinearGradient(
  colors: [
    colorScheme.primary,
    colorScheme.secondary,
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final darkGradient = LinearGradient(
  colors: [
    darkColorScheme.onPrimary,
    darkColorScheme.onSecondary,
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
