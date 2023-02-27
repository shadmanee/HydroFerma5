import 'package:flutter/material.dart';

class TopAnimatedContainer extends StatefulWidget {
  final Widget child;

  const TopAnimatedContainer({required Key key, required this.child}) : super(key: key);

  @override
  _TopAnimatedContainerState createState() => _TopAnimatedContainerState();
}

class _TopAnimatedContainerState extends State<TopAnimatedContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  late Animation<EdgeInsets> _marginAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _heightAnimation = Tween<double>(
      begin: 0,
      end: 100,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.0,
        0.5,
        curve: Curves.easeOut,
      ),
    ));
    _marginAnimation = Tween<EdgeInsets>(
      begin: const EdgeInsets.only(top: 0),
      end: const EdgeInsets.only(top: 100),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.easeOut,
      ),
    ));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Container(
          key: const ValueKey(''),
          height: _heightAnimation.value,
          margin: _marginAnimation.value,
          child: widget.child,
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
