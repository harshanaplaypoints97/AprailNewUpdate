import 'package:flutter/material.dart';

import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/style.dart';

textInputFeild(
    {TextEditingController textcontroller,
    TextInputType textInputType,
    bool obscureText,
    String labelText,
    int maxLength,
    int lines}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15),
    child: TextFormField(
      keyboardType: textInputType,
      controller: textcontroller,
      obscureText: obscureText,
      buildCounter: (BuildContext context,
              {int currentLength, int maxLength, bool isFocused}) =>
          null,
      maxLines: lines,
      maxLength: maxLength,
      validator: (value) {
        if (value.isEmpty) {
          return (labelText + " can't be empty");
        }
        return null;
      },
      decoration: InputDecoration(
          fillColor: AppColors.scaffoldBackGroundColor,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          hintText: labelText,
          labelStyle: AppStyles.lableText,
          floatingLabelBehavior: FloatingLabelBehavior.always),
    ),
  );
}

textInputFeildNew(
    {TextEditingController textcontroller,
    TextInputType textInputType,
    bool obscureText,
    String labelText,
    bool border,
    bool editable,
    int maxLength,
    int lines,
    bool required = true}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            labelText,
            style: TextStyle(
                fontSize: 15,
                color: Color(0xff595858),
                fontWeight: FontWeight.w500),
          ),
        ),
        TextFormField(
          maxLength: maxLength,
          buildCounter: (BuildContext context,
                  {int currentLength, int maxLength, bool isFocused}) =>
              null,
          style: TextStyle(color: !editable ? Colors.grey : Colors.black),
          keyboardType: textInputType,
          enabled: editable,
          controller: textcontroller,
          obscureText: obscureText,
          maxLines: lines,
          validator: (value) {
            if (required) {
              if (value.isEmpty) {
                return ("$labelText cannot be empty");
              }
              return null;
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                    color: AppColors.normalTextColor.withOpacity(0.2),
                    width: 2)),
            enabledBorder: border
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                        color: AppColors.normalTextColor.withOpacity(0.2),
                        width: 2))
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 2)),
            //border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide:
                    BorderSide(color: AppColors.PRIMARY_COLOR_LIGHT, width: 2)),
            hintText: labelText,
            // labelText: labletext,
            contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          ),
        ),
      ],
    ),
  );
}

emailInputFeild({
  TextInputType textInputType,
  TextEditingController textcontroller,
  bool obscureText,
  String labelText,
  bool border,
  bool editable,
  int maxLength,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            labelText,
            style: TextStyle(
                fontSize: 15,
                color: Color(0xff595858),
                fontWeight: FontWeight.w500),
          ),
        ),
        TextFormField(
          style: TextStyle(color: !editable ? Colors.grey : Colors.black),
          keyboardType: textInputType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            return null;
          },
          maxLength: maxLength,
          buildCounter: (BuildContext context,
                  {int currentLength, int maxLength, bool isFocused}) =>
              null,
          enabled: editable,
          controller: textcontroller,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                    color: AppColors.normalTextColor.withOpacity(0.2),
                    width: 2)),
            enabledBorder: border
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                        color: AppColors.normalTextColor.withOpacity(0.2),
                        width: 2))
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 2)),
            //border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide:
                    BorderSide(color: AppColors.PRIMARY_COLOR_LIGHT, width: 2)),
            hintText: "labletext",

            // labelText: labletext,
            contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          ),
        ),
      ],
    ),
  );
}

phoneNufeild({
  TextEditingController textcontroller,
  bool obscureText,
  String labelText,
  bool border,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            labelText,
            style: TextStyle(
                fontSize: 16,
                color: Color(0xff595858),
                fontWeight: FontWeight.w600),
          ),
        ),
        TextFormField(
          controller: textcontroller,
          obscureText: obscureText,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            disabledBorder: InputBorder.none,
            enabledBorder: border
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                        color: AppColors.normalTextColor.withOpacity(0.2),
                        width: 2))
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 2)),
            //border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide:
                    BorderSide(color: AppColors.PRIMARY_COLOR_LIGHT, width: 2)),
            hintText: labelText,
            // labelText: labletext,
            contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          ),
        ),
      ],
    ),
  );
}
