import 'package:flutter/material.dart';

class PageFlipBuilder extends StatefulWidget {
  final Widget frontWidget;
  final Widget backWidget;
  final bool showFront;

  PageFlipBuilder({
    required this.frontWidget,
    required this.backWidget,
    required this.showFront,
  });

  @override
  _PageFlipBuilderState createState() => _PageFlipBuilderState();
}

class _PageFlipBuilderState extends State<PageFlipBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.5), weight: 50.0),
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.0), weight: 50.0),
    ]).animate(_controller);

    if (!widget.showFront) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(PageFlipBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showFront != oldWidget.showFront) {
      if (widget.showFront) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final isFront = _animation.value < 0.5;
        final child = isFront ? widget.frontWidget : Transform(
          transform: Matrix4.identity()..rotateY(3.14159),
          alignment: Alignment.center,
          child: widget.backWidget,
        );

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(_animation.value * 3.14159),
          alignment: Alignment.center,
          child: child,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
