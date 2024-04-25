import 'package:flutter/material.dart';

class DefaultRouter {
  static void defaultRouter(Widget widget, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: ((context) => widget)));
  }
}
