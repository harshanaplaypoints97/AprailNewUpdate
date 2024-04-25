import 'package:flutter/material.dart';
import 'package:play_pointz/constants/app_colors.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton(
      {@required this.buttonText,
      @required this.buttonColor,
      @required this.onPress,
      @required this.height,
      @required this.width,
      @required this.fontWeight,
      @required this.fontSize});

  final String buttonText;
  final VoidCallback onPress;
  double width;
  double height;
  FontWeight fontWeight;
  double fontSize;
  Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPress,
        // ignore: sort_child_properties_last
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
                fontFamily: 'inter',
                fontSize: fontSize,
                color: Colors.white,
                fontWeight: fontWeight),
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}

class ImageRoundedButton extends StatelessWidget {
  ImageRoundedButton(
      {@required this.buttonText,
      @required this.buttonColor,
      @required this.onPress,
      @required this.height,
      @required this.width,
      @required this.fontWeight,
      @required this.fontSize});

  final String buttonText;
  final VoidCallback onPress;
  double width;
  double height;
  FontWeight fontWeight;
  double fontSize;
  Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPress,
        // ignore: sort_child_properties_last
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.asset(
                'assets/bg/send.png',
                height: 25,
                width: 25,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                buttonText,
                style: TextStyle(
                    fontFamily: 'inter',
                    fontSize: fontSize,
                    color: Colors.white,
                    fontWeight: fontWeight),
              ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
