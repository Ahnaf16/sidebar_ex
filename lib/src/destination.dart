import 'package:flutter/material.dart';

class Destination<T> extends NavigationRailDestination {
  const Destination({
    required super.icon,
    required super.label,
    this.extra,
    super.disabled = false,
    super.selectedIcon,
    super.padding,
  });

  final T? extra;
}

class GroupedDestination extends Destination {
  const GroupedDestination({
    required super.icon,
    required super.label,
    required this.children,
    super.disabled,
    super.selectedIcon,
    super.padding,
  });

  final List<Destination> children;
}

class DestinationDivider extends Destination {
  DestinationDivider({
    this.height,
    this.thickness = 1,
    this.color,
    this.verticalPadding = 5,
    this.horizontalPadding,
  }) : super(
          icon: const Icon(Icons.chevron_right),
          label: const Text(''),
        );

  final double? height;
  final double thickness;
  final double? verticalPadding;
  final double? horizontalPadding;
  final Color? color;
}
