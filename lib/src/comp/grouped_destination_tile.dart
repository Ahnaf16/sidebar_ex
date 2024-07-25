import 'package:flutter/material.dart';

import 'expandable_tile.dart';

class GroupedDestinationTile extends StatelessWidget {
  const GroupedDestinationTile({
    super.key,
    this.padding,
    this.isExpanded = true,
    this.isSelected = false,
    required this.childIndex,
    required this.icon,
    required this.label,
    this.tileColor,
    required this.itemBuilder,
    required this.length,
    this.backgroundColor,
    required this.animation,
  });

  final EdgeInsetsGeometry? padding;
  final bool isExpanded;
  final bool isSelected;
  final int? childIndex;
  final Widget icon;
  final Widget label;
  final Color? tileColor;
  final Color? backgroundColor;
  final IndexedWidgetBuilder itemBuilder;
  final Animation<double> animation;

  final int length;

  @override
  Widget build(BuildContext context) {
    final fadeAnimation =
        animation.drive(CurveTween(curve: const Interval(0.0, 0.25)));
    return Padding(
      padding: padding ?? const EdgeInsets.all(4),
      child: Column(
        children: [
          if (isExpanded)
            ExpandableTile(
              icon: icon,
              animation: fadeAnimation,
              label: label,
              children: [
                for (int i = 0; i < length; i += 1) itemBuilder(context, i),
              ],
            )
          else
            Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: MenuAnchor(
                  style: const MenuStyle(
                    alignment: Alignment.topRight,
                    elevation: WidgetStatePropertyAll(0),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  alignmentOffset: const Offset(30, 0),
                  menuChildren: [
                    for (int i = 0; i < length; i += 1) itemBuilder(context, i),
                  ],
                  builder: (context, c, child) => InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      c.isOpen ? c.close() : c.open();
                    },
                    child: child,
                  ),
                  child: icon,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
