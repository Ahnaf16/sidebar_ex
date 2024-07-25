import 'package:flutter/material.dart';

class SidebarExThemeData {
  factory SidebarExThemeData({
    Color? tileColor,
    Color? selectedTileColor,
    Color? iconColor,
    Color? selectedIconColor,
    Color? backgroundColor,
    TextStyle? textStyle,
    TextStyle? selectedTextStyle,
  }) {
    return SidebarExThemeData.raw(
      tileColor: tileColor ?? def.tileColor,
      selectedTileColor: selectedTileColor ?? def.selectedTileColor,
      iconColor: iconColor ?? def.iconColor,
      selectedIconColor: selectedIconColor ?? def.selectedIconColor,
      textStyle: textStyle ?? def.textStyle,
      selectedTextStyle: selectedTextStyle ?? def.selectedTextStyle,
      backgroundColor: backgroundColor ?? def.backgroundColor,
    );
  }

  const SidebarExThemeData.raw({
    required this.tileColor,
    required this.selectedTileColor,
    required this.textStyle,
    required this.selectedTextStyle,
    required this.iconColor,
    required this.selectedIconColor,
    required this.backgroundColor,
  });

  final Color iconColor;
  final Color selectedIconColor;
  final TextStyle textStyle;
  final TextStyle selectedTextStyle;
  final Color selectedTileColor;
  final Color tileColor;
  final Color backgroundColor;

  static SidebarExThemeData fromThemeData(ThemeData theme) {
    return SidebarExThemeData.raw(
      selectedTileColor: theme.colorScheme.primary,
      tileColor: theme.colorScheme.primaryContainer,
      iconColor: theme.iconTheme.color?.withOpacity(.18) ?? def.iconColor,
      selectedIconColor: theme.iconTheme.color ?? def.selectedIconColor,
      textStyle: theme.textTheme.labelLarge ?? def.textStyle,
      selectedTextStyle: theme.textTheme.labelLarge ?? def.selectedTextStyle,
      backgroundColor:
          theme.navigationRailTheme.backgroundColor ?? def.backgroundColor,
    );
  }

  static SidebarExThemeData def = const SidebarExThemeData.raw(
    selectedTileColor: Colors.blue,
    tileColor: Colors.transparent,
    selectedIconColor: Colors.white,
    iconColor: Color.fromARGB(255, 165, 165, 165),
    selectedTextStyle: TextStyle(),
    textStyle: TextStyle(
      color: Color.fromARGB(255, 165, 165, 165),
    ),
    backgroundColor: Color(0xFF263238),
  );
}
