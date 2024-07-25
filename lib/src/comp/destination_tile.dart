import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sidebar_ex/sidebar_ex.dart';

class DestinationTile extends StatelessWidget {
  const DestinationTile({
    super.key,
    this.padding,
    this.isExpanded = true,
    this.childIndex,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.tileColor,
    required this.animation,
  });
  final Animation<double> animation;
  final EdgeInsetsGeometry? padding;
  final bool isExpanded;
  final int? childIndex;
  final Widget icon;
  final Widget label;
  final void Function() onTap;
  final Color tileColor;

  @override
  Widget build(BuildContext context) {
    Widget content;

    final fadeAnimation =
        animation.drive(CurveTween(curve: const Interval(0.0, 0.25)));

    content = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: lerpDouble(
          kSidebarWidth,
          kSidebarWidthExtended,
          animation.value,
        )!,
      ),
      child: ClipRect(
        child: Row(
          children: [
            icon,
            const SizedBox(width: 10),
            Align(
              heightFactor: 1.0,
              widthFactor: animation.value,
              alignment: AlignmentDirectional.centerStart,
              child: FadeTransition(
                alwaysIncludeSemantics: true,
                opacity: fadeAnimation,
                child: label,
              ),
            ),
          ],
        ),
      ),
    );

    return Padding(
      padding: padding ?? const EdgeInsets.all(4),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: tileColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => onTap(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                if (isExpanded) content else icon,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
