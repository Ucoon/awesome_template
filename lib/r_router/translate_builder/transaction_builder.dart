import 'package:flutter/material.dart';

class DefaultTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    Offset begin = const Offset(1.0, 0.0);
    Offset end = Offset.zero;
    Tween<Offset> tween = Tween<Offset>(begin: begin, end: end);
    CurvedAnimation curvedAnimation =
        CurvedAnimation(parent: animation, curve: Curves.easeOut);
    return SlideTransition(
      position: tween.animate(curvedAnimation),
      child: child,
    );
  }
}
