import 'package:flutter/material.dart';
import 'package:play_pointz/constants/app_colors.dart';

Widget textInput({
  TextEditingController textcontroller,
  TextInputType textInputType,
  String labletext,
  Icon icon,
  bool obsecuretext,
  bool border,
  int maxInputLength,
  Function onChange
}) {
  return TextFormField(
    keyboardType: textInputType,
    style: TextStyle(fontSize: 12),
    validator: (value) {
      if (value.isEmpty) {
        return (labletext + " can't be empty");
      }
      return null;
    },
    maxLength: maxInputLength,
    onChanged: (value) {
      onChange();
    },
    buildCounter: (BuildContext context,
            {int currentLength, int maxLength, bool isFocused}) =>
        null,
    obscureText: obsecuretext,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      //disabledBorder: InputBorder.none,
      border: InputBorder.none,
      enabledBorder: border
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            )
          : OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.transparent, width: 2)),
      //border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide:
              BorderSide(color: AppColors.PRIMARY_COLOR_LIGHT, width: 2)),
      hintText: labletext,
      // labelText: labletext,
      contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
    ),
    controller: textcontroller,
    textInputAction: TextInputAction.done,
  );
}
