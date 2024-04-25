import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/constants/app_colors.dart';

class AppStyles {
  // Login Screen
  static const TextStyle buttonStyle = TextStyle(
      color: Colors.white,
      // fontSize: 16,
      fontWeight: FontWeight.bold);
  static const TextStyle buttonStyle2 = TextStyle(
      color: AppColors.PRIMARY_COLOR,
      // fontSize: 16,
      fontWeight: FontWeight.bold);
  static const InputDecoration textField = InputDecoration(
    fillColor: Colors.black12,
    filled: true,
    border: InputBorder.none,
  );
  static const TextStyle textFieldStyle = TextStyle(fontSize: 14);
  static const TextStyle subtitle =
      TextStyle(color: Colors.black38, fontSize: 12);

  //Profile page and sub pages

  static const subScreenButton = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xff77838F));
  static const subScreensTitle = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xff4C4C4C));
  static const saveButtonText =
      TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);
  static const lableText = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff4C4C4C));
  static const notificationSettingsScreenTitle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w700);
  static const notificationSettingsScreenSubtitle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
  static const friendName = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const countryPickerNames =
      TextStyle(fontSize: 16, color: Colors.blueGrey);
  static const notificationContent = TextStyle(fontSize: 16);

  static const profileNameStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );
  static const profileLocationStyle = TextStyle(
      fontSize: 10, fontWeight: FontWeight.w400, color: Color(0xFF858383));

  //item page
  static const itemName = TextStyle(fontSize: 24, fontWeight: FontWeight.w700);
  static const descriptionText =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400);

  static const itemPagesubTitle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static const pointzAmountText =
      TextStyle(fontSize: 22, fontWeight: FontWeight.w700);
  static const redeemButtonText = TextStyle(
      color: AppColors.WHITE, fontSize: 22, fontWeight: FontWeight.w700);
  static const buttonShadow = BoxShadow(
    color: Colors.black26,
    offset: Offset(
      0.0,
      3,
    ),
    blurRadius: 0.1,
    spreadRadius: 0.2,
  );
  static const newLabel = BoxShadow(
    color: Colors.black12,
    offset: Offset(
      1,
      1,
    ),
    blurRadius: 0,
    spreadRadius: 0.2,
  );
  static const boxShadow = BoxShadow(
      color: Colors.black12,
      offset: Offset(0, 4),
      blurRadius: 8.0,
      spreadRadius: 0.8);
  static const title = TextStyle(fontSize: 14, fontWeight: FontWeight.w600);

  static var storeTitles = TextStyle(
      color: AppColors.normalTextColor.withOpacity(0.9),
      fontWeight: FontWeight.w600,
      //  letterSpacing: 0.8,
      fontSize: 18.sp);

  // new Styles

  static const profilePageTextSty01 = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: Color(0xFF838282));
  static const friendNameV2 = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 1,
      color: Color(0xFF3C3D3F));
}
