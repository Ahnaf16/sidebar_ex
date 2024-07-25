import 'package:flutter/material.dart';
import 'package:sidebar_ex/src/comp/destination_tile.dart';

import 'comp/grouped_destination_tile.dart';
import 'destination.dart';
import 'theme/sidebar_ex_theme.dart';

const double kSidebarWidth = 80;
const double kSidebarWidthExtended = 200;

typedef OnDestinationSelected<T> = void Function(
    int rootIndex, int? childIndex, T? extra);

class SideBarEx<T> extends StatefulWidget {
  const SideBarEx({
    super.key,
    required this.destinations,
    this.selectedIndex,
    this.leading,
    this.trailing,
    this.onDestinationSelected,
    this.selectedChildIndex,
    this.extended = true,
    this.width = kSidebarWidth,
    this.exWidth = kSidebarWidthExtended,
  });

  final bool extended;
  final List<Destination> destinations;
  final int? selectedIndex;
  final int? selectedChildIndex;
  final OnDestinationSelected<T>? onDestinationSelected;
  final Widget? leading;
  final Widget? trailing;
  final double width;
  final double exWidth;

  @override
  State<SideBarEx<T>> createState() => _SideBarExState<T>();
}

class _SideBarExState<T> extends State<SideBarEx<T>>
    with TickerProviderStateMixin {
  late List<AnimationController> _destinationControllers;
  late List<Animation<double>> _destinationAnimations;
  late AnimationController _extendedController;
  late Animation<double> _extendedAnimation;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  void didUpdateWidget(SideBarEx<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.extended != oldWidget.extended) {
      if (widget.extended) {
        _extendedController.forward();
      } else {
        _extendedController.reverse();
      }
    }

    if (widget.destinations.length != oldWidget.destinations.length) {
      _resetState();
      return;
    }

    if (widget.selectedIndex != oldWidget.selectedIndex) {
      if (oldWidget.selectedIndex != null) {
        _destinationControllers[oldWidget.selectedIndex!].reverse();
      }
      if (widget.selectedIndex != null) {
        _destinationControllers[widget.selectedIndex!].forward();
      }
      return;
    }
  }

  void _disposeControllers() {
    for (final AnimationController controller in _destinationControllers) {
      controller.dispose();
    }
    _extendedController.dispose();
  }

  void _initControllers() {
    _destinationControllers = List<AnimationController>.generate(
      widget.destinations.length,
      (_) => AnimationController(duration: kThemeAnimationDuration, vsync: this)
        ..addListener(_rebuild),
    );

    _destinationAnimations =
        _destinationControllers.map((c) => c.view).toList();

    if (widget.selectedIndex != null) {
      _destinationControllers[widget.selectedIndex!].value = 1.0;
    }

    _extendedController = AnimationController(
      duration: kThemeAnimationDuration,
      vsync: this,
      value: widget.extended ? 1.0 : 0.0,
    );
    _extendedAnimation = CurvedAnimation(
      parent: _extendedController,
      curve: Curves.easeInOut,
    );
    _extendedController.addListener(() => _rebuild());
  }

  void _resetState() {
    _disposeControllers();
    _initControllers();
  }

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final canExpand = widget.extended && widget.width == kSidebarWidth;
    final th = SidebarExTheme.of(context);
    return _ExtendedAnimation(
      animation: _extendedAnimation,
      child: AnimatedContainer(
        duration: kThemeAnimationDuration,
        color: th.backgroundColor,
        width: canExpand ? widget.exWidth : widget.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            if (widget.leading != null) ...[
              const SizedBox(height: 10),
              widget.leading!,
            ],
            const SizedBox(height: 10),
            Expanded(
              child: Column(
                children: [
                  for (int i = 0; i < widget.destinations.length; i += 1)
                    _SideBarItem(
                      destination: widget.destinations[i],
                      selected: i == widget.selectedIndex,
                      childIndex: widget.selectedChildIndex,
                      index: i,
                      isExpanded: canExpand,
                      extendedTransitionAnimation: _extendedAnimation,
                      destinationAnimation: _destinationAnimations[i],
                      onTap: (childIndex, extra) {
                        widget.onDestinationSelected?.call(
                          i,
                          childIndex,
                          extra ?? widget.destinations[i].extra,
                        );
                      },
                    ),
                  if (widget.trailing != null) widget.trailing!,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExtendedAnimation extends InheritedWidget {
  const _ExtendedAnimation({
    required this.animation,
    required super.child,
  });

  final Animation<double> animation;

  @override
  bool updateShouldNotify(_ExtendedAnimation old) => animation != old.animation;
}

class _SideBarItem<T> extends StatelessWidget {
  const _SideBarItem({
    required this.destination,
    required this.selected,
    required this.onTap,
    required this.index,
    this.isExpanded = false,
    this.childIndex,
    required this.destinationAnimation,
    required this.extendedTransitionAnimation,
  });

  final int? childIndex;
  final Destination destination;
  final int index;
  final Function(int? childIndex, T? extra) onTap;
  final bool selected;
  final bool isExpanded;
  final Animation<double> destinationAnimation;
  final Animation<double> extendedTransitionAnimation;

  @override
  Widget build(BuildContext context) {
    final disabled = destination.disabled;

    final theme = Theme.of(context);
    final exTheme = SidebarExTheme.of(context);

    Widget themedIcon(Widget icon) {
      final iconTheme = theme.iconTheme.copyWith(
        color: selected ? exTheme.selectedIconColor : exTheme.iconColor,
      );
      return IconTheme(data: iconTheme, child: icon);
    }

    Widget styledLabel(Widget label) {
      return DefaultTextStyle(
        style: disabled ? exTheme.textStyle : exTheme.selectedTextStyle,
        child: label,
      );
    }

    const padding = EdgeInsets.symmetric(vertical: 4, horizontal: 8);

    Color tileColor(bool isSelected) =>
        isSelected ? exTheme.selectedTileColor : exTheme.tileColor;

    Widget tileBuilder(Destination d, [int? childIndex]) {
      bool isSelected = selected;
      if (childIndex != null) isSelected = childIndex == this.childIndex;

      return DestinationTile(
        animation: extendedTransitionAnimation,
        padding: padding,
        isExpanded: isExpanded,
        childIndex: childIndex,
        label: styledLabel(d.label),
        onTap: () => onTap(childIndex, d.extra),
        tileColor: tileColor(isSelected),
        icon: themedIcon(d.icon),
      );
    }

    Widget content = tileBuilder(destination);

    final dest = destination;

    if (dest is GroupedDestination) {
      content = GroupedDestinationTile(
        animation: extendedTransitionAnimation,
        padding: padding,
        tileColor: tileColor(selected),
        backgroundColor: exTheme.backgroundColor,
        isExpanded: isExpanded,
        isSelected: selected,
        childIndex: childIndex,
        icon: themedIcon(dest.icon),
        label: styledLabel(dest.label),
        itemBuilder: (context, i) => tileBuilder(dest.children[i], i),
        length: dest.children.length,
      );
    }

    if (dest is DestinationDivider) {
      content = Container(
        height: dest.thickness,
        width: double.infinity,
        color: dest.color ?? theme.dividerColor,
        margin: EdgeInsets.symmetric(
          vertical: dest.verticalPadding ?? 0,
          horizontal: dest.horizontalPadding ?? 0,
        ),
      );
    }

    return content;
  }
}
