import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/style.dart';

profileName({String name}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        name,
        maxLines: 3,
        style: AppStyles.profileNameStyle,
      ),
      /*  SizedBox(
        width: 5,
      ), */
    ],
  );
}

pageName({String name, Size size, bool verified}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      SizedBox(
        width: size.width - 80,
        child: RichText(
            strutStyle: StrutStyle(height: 1.5),
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  text: name + ' ',
                  style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: Colors.black87)),
              if (verified)
                WidgetSpan(
                  child: Icon(
                    Icons.verified,
                    size: 16,
                    color: AppColors.BUTTON_BLUE_COLLOR,
                  ),
                ),
            ])),
      ),
    ],
  );
}

bioname({
  String name,
  Size size,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      SizedBox(
        width: size.width - 80,
        child: RichText(
            strutStyle: StrutStyle(height: 1.5),
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  text: name + ' ',
                  style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                      color: Color(0xff0F1419))),
            ])),
      ),
    ],
  );
}

userLocation({String name}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        name,
        maxLines: 3,
        style: AppStyles.profileLocationStyle,
      ),
      SizedBox(
        width: 5,
      ),
    ],
  );
}

pageCategory({String name}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        name,
        maxLines: 3,
        style: TextStyle(fontSize: 14),
      ),
      SizedBox(
        width: 5,
      ),
    ],
  );
}

profileBtn({Function function, String title, String count}) {
  return MaterialButton(
    padding: const EdgeInsets.all(0),
    onPressed: function,
    child: Column(children: [
      Text(
        count,
        style: TextStyle(
            fontSize: 20,
            color: Color(0XFFDF5E01),
            fontWeight: FontWeight.w700),
      ),
      SizedBox(
        height: 5,
      ),
      Text(
        title,
        style: TextStyle(
            fontSize: 13,
            color: Color(0XFF000000),
            fontWeight: FontWeight.w400),
      )
    ]),
  );
}

orderbtn({Function function, String title, IconData icon}) {
  return MaterialButton(
    padding: const EdgeInsets.all(0),
    onPressed: function,
    child: Column(children: [
      FaIcon(
        icon,
        size: 15,
        color: Color(0XFFDF5E01),
      ),
      SizedBox(
        height: 5,
      ),
      Text(
        title,
        style: TextStyle(
            fontSize: 18,
            color: Color(0XFF000000),
            fontWeight: FontWeight.w500),
      )
    ]),
  );
}

profileBtns({Function function, String title, IconData icon}) {
  return MaterialButton(
    padding: const EdgeInsets.all(0),
    onPressed: function,
    child: Column(children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xff8E8E8E).withOpacity(0.1),
        ),
        width: 40,
        height: 40,
        child: Center(
          child: FaIcon(
            icon,
            size: 25,
            color: Color(0xff8E8E8E),
          ),
        ),
      ),
      SizedBox(
        height: 5,
      ),
      Text(
        title,
        style: TextStyle(
            fontSize: 14, color: AppColors.normalTextColor.withOpacity(0.6)),
      )
    ]),
  );
}
