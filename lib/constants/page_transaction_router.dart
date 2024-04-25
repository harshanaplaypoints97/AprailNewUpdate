import 'package:flutter/material.dart';

class FadeTransitionRouter extends PageRouteBuilder {
  final Widget child;
  FadeTransitionRouter({
    this.child,
  }) : super(
            transitionDuration: const Duration(milliseconds: 200),
            pageBuilder: (context, animation1, animation2) => child);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      FadeTransition(
        opacity: animation,
        child: Material(
          child: child,
        ),
      );
}
