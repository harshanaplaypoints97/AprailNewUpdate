// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class TextComponent extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight fontWeight;
  final String fontfamily;

  const TextComponent({
   
    @required this.text,
    @required this.size,
   @ required this.color,
    @required this.fontWeight,
    @required this.fontfamily,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: fontfamily,
        fontSize: size,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}
