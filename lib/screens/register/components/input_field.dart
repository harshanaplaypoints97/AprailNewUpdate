import 'package:flutter/material.dart';
import 'package:play_pointz/constants/app_colors.dart';

class AuthenticationInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType textInputType;
  final String hintText;
  final int maxLength;
  final bool isEmail;
  final bool isUsername;

  const AuthenticationInputField({
    Key key,
    this.controller,
    this.isPassword,
    this.textInputType,
    this.hintText,
    this.maxLength,
    this.isEmail,
    this.isUsername,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: isEmail
          ? (value) {
              // Check if this field is empty
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }

              // using regular expression
              if (!RegExp(
                      r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                  .hasMatch(value)) {
                return "Please enter a valid email address";
              }

              // the email is valid
              return null;
            }
          : isUsername
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  if (!RegExp(r'^[\w]{1,12}$').hasMatch(value)) {
                    return "Username Cannot Include Spaces,Symbols and emoji";
                  }
                 
                  return null;
                }
              : (val) => val != null
                  ? val.isEmpty
                      ? "Please fill this field"
                      : null
                  : null,
      maxLength: maxLength,
      buildCounter: (BuildContext context,
              {int currentLength, int maxLength, bool isFocused}) =>
          null,
      obscureText: isPassword,
      keyboardType: textInputType,
      controller: controller,
      decoration: InputDecoration(
        fillColor: AppColors.scaffoldBackGroundColor,
        filled: true,
        labelText: hintText,
        labelStyle: TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
