import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget subScreenButton({
  context,
  BoxDecoration decoration,
  String displayText,
  FaIcon displayIcon,
  Function navigateScreen, 
  // TextEditingController pwordController,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(
          color: Colors.grey[100],
        ),
      ),
    ),
    child: ListTile(
      leading: displayIcon,
      title: Text(displayText),      
      onTap: () {
        navigateScreen();
      },
    ),
  );
}

Widget subScreenButton2({
  context,
  BoxDecoration decoration,
  String displayText,
  FaIcon displayIcon,
  Function navigateScreen, 
  // TextEditingController pwordController,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.red,
      border: Border(
        bottom: BorderSide(
          color: Colors.grey[100],
        ),
      ),
    ),
    child: ListTile(
      leading: displayIcon,
      title: Text(displayText,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),      
      onTap: () {
        navigateScreen();
      },
    ),
  );
}


Widget subScreenButtonProfile({
  context,
  BoxDecoration decoration,
  String displayText,
  FaIcon displayIcon,
  Function navigateScreen, 
  // TextEditingController pwordController,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(
          color: Colors.grey[100],
        ),
      ),
    ),
    child: ListTile(
      leading: displayIcon,
      trailing: Icon(Icons.arrow_forward_ios),
      title: Text(displayText),      
      onTap: () {
        navigateScreen();
      },
    ),
  );
}