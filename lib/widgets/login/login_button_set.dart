import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/style.dart';

Container loginBtnClr(
    {BuildContext context,
    var size,
    String title,
    Function route,
    bool loading}) {
  return Container(
      decoration: BoxDecoration(
        color: AppColors.PRIMARY_COLOR,
        borderRadius: BorderRadius.all(const Radius.circular(6)),
      ),
      width: size.width,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: MaterialButton(
        elevation: 0,
        onPressed: loading ? null : route,
        child: loading
            ? CupertinoActivityIndicator(
                // color: Colors.white,
                )
            : Text(
                title,
                style: AppStyles.buttonStyle,
              ),
      ));
}

Container loginBtnWhite(
    {BuildContext context, var size, String title, Function route}) {
  return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.PRIMARY_COLOR),
          borderRadius: BorderRadius.all(const Radius.circular(12))),
      width: size.width,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: MaterialButton(
        onPressed: route,
        child: Text(
          title,
          style: AppStyles.buttonStyle2,
        ),
      ));
}

Container loginBtnClrwithIcn(
    {BuildContext context, var size, String title, Function route}) {
  return Container(
      decoration: BoxDecoration(
        color: AppColors.PRIMARY_COLOR,
        borderRadius: BorderRadius.all(const Radius.circular(25.0)),
        boxShadow: [],
      ),
      width: size.width,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: MaterialButton(
        onPressed: route,
        child: Text(
          title,
          style: AppStyles.buttonStyle,
        ),
      ));
}

Container loginBtnWhiteIcn(
    {BuildContext context, var size, String title, Function route}) {
  return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.PRIMARY_COLOR),
          borderRadius: BorderRadius.all(const Radius.circular(25.0))),
      width: size.width,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: MaterialButton(
        onPressed: route,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.camera,
              size: 18,
              color: AppColors.PRIMARY_COLOR,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              title,
              style: AppStyles.buttonStyle2,
            ),
          ],
        ),
      ));
}
