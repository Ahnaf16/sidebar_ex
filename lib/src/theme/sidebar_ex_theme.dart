import 'package:flutter/material.dart';
import 'package:sidebar_ex/src/theme/sidebar_ex_theme_data.dart';

class SidebarExTheme extends StatelessWidget {
  const SidebarExTheme({
    super.key,
    required this.child,
    required this.data,
  });

  final Widget child;
  final SidebarExThemeData data;

  static SidebarExThemeData of(BuildContext context) {
    final _SideBarInheritedTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_SideBarInheritedTheme>();

    final theme = Theme.of(context);
    final exTheme =
        inheritedTheme?.theme.data ?? SidebarExThemeData.fromThemeData(theme);
    return exTheme;
  }

  Widget _wrapsWidgetThemes(BuildContext context, Widget child) {
    return IconTheme(
      data: Theme.of(context).iconTheme.copyWith(color: data.iconColor),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _SideBarInheritedTheme(
      theme: this,
      child: _wrapsWidgetThemes(context, child),
    );
  }
}

class _SideBarInheritedTheme extends InheritedTheme {
  const _SideBarInheritedTheme({
    required this.theme,
    required super.child,
  });

  final SidebarExTheme theme;

  @override
  bool updateShouldNotify(_SideBarInheritedTheme old) =>
      theme.data != old.theme.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return SidebarExTheme(data: theme.data, child: child);
  }
}
