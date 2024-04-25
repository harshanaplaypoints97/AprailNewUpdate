import 'package:flutter/material.dart';

class AnimatedHurryText extends StatefulWidget {
  const AnimatedHurryText({Key key}) : super(key: key);

  @override
  State<AnimatedHurryText> createState() => _AnimatedHurryTextState();
}

class _AnimatedHurryTextState extends State<AnimatedHurryText>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800));
    animation = Tween<double>(begin: 1, end: 1.2).animate(_controller);
    _controller.forward();
    _controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint("$animation");
    return Container(
      width: MediaQuery.of(context).size.width,
      height: kToolbarHeight,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Text(
              "Hurry, someone might be trying to get this already",
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15 * animation.value,
                fontWeight: FontWeight.w500,
              ),
            );
          }),
    );
  }
}
