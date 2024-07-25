import 'package:flutter/material.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class ExpandableTile extends StatefulWidget {
  const ExpandableTile({
    super.key,
    required this.icon,
    required this.label,
    this.background,
    this.tileColor,
    required this.children,
    required this.animation,
  });

  final Animation<double> animation;
  final Color? background;
  final List<Widget> children;
  final Widget icon;
  final Widget label;
  final Color? tileColor;

  @override
  State<ExpandableTile> createState() => _ExpandableTileState();
}

class _ExpandableTileState extends State<ExpandableTile>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);

  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  final CurveTween _heightFactorTween = CurveTween(curve: Curves.easeIn);

  late AnimationController _animationController;
  late Animation<double> _heightFactor;
  late Animation<double> _iconTurns;
  bool _isExpanded = false;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _animationController.drive(_heightFactorTween);
    _iconTurns = _animationController.drive(_halfTween.chain(_easeInTween));
    if (_isExpanded) _animationController.value = 1.0;
  }

  void _toggleExpansion() {
    setState(
      () {
        _isExpanded = !_isExpanded;
        if (_isExpanded) {
          _animationController.forward();
        } else {
          _animationController.reverse().then((value) {
            if (!mounted) return;
            setState(() {});
          });
        }
        PageStorage.maybeOf(context)?.writeState(context, _isExpanded);
      },
    );
  }

  void _handleTap() => _toggleExpansion();

  Widget _buildIcon(BuildContext context) {
    return RotationTransition(
      turns: _iconTurns,
      child: const Icon(Icons.expand_more),
    );
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final radius = BorderRadius.circular(10);
    final shape = RoundedRectangleBorder(borderRadius: radius);

    final tile = InkWell(
      borderRadius: radius,
      onTap: _handleTap,
      child: Material(
        shape: shape,
        color: widget.tileColor,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              widget.icon,
              const SizedBox(width: 10),
              Align(
                heightFactor: 1.0,
                widthFactor: widget.animation.value,
                alignment: AlignmentDirectional.centerStart,
                child: FadeTransition(
                  alwaysIncludeSemantics: true,
                  opacity: widget.animation,
                  child: widget.label,
                ),
              ),
              // if (widget.animation.value == 1) ...[
              //   const Spacer(),
              //   _buildIcon(context),
              // ],
            ],
          ),
        ),
      ),
    );
    final tileWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        tile,
        ClipRect(
          child: Align(
            alignment: Alignment.center,
            heightFactor: _heightFactor.value,
            child: child,
          ),
        ),
      ],
    );

    return Material(
      color: widget.background,
      shape: shape,
      child: tileWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    final closed = !_isExpanded && _animationController.isDismissed;
    final shouldRemoveChildren = closed;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: widget.children,
        ),
      ),
    );
    return AnimatedBuilder(
      animation: _animationController.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}
