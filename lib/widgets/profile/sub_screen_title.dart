import 'package:flutter/material.dart';

import 'package:play_pointz/constants/style.dart';

subScreenTitle({context, String title}) {
  return Container(
    decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(18), bottomRight: Radius.circular(18))),
    height: 60,
    child: Row(
      //crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        Text(
          title,
          style: AppStyles.subScreensTitle,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.transparent,
          ),
        ),
      ],
    ),
  );
}
