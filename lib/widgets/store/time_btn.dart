import 'package:flutter/material.dart';
import 'package:play_pointz/constants/app_colors.dart';

Widget timeBtn(
    {String title, bool active, String countdown, BuildContext context}) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 8,
          height: MediaQuery.of(context).size.width / 8,
          alignment: Alignment.center,
          //padding: const EdgeInsets.all(3),
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(const Radius.circular(5.0))),
          child: FittedBox(
            child: Text(
              countdown,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: active ? Color(0xff02A41C) : Colors.amber[600],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          title,
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 25,
              fontWeight: FontWeight.w400,
              color: active
                  ? Colors.white70
                  : /* Colors.black */ Color.fromARGB(179, 122, 117, 117)),
        )
      ]);
}

Widget timeBtnSmall(
    {String title,
    bool active,
    String countdown,
    BuildContext context,
    Duration difference,
    Duration difference2,
    bool taken = false}) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.05,
          height: MediaQuery.of(context).size.width * 0.05,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(2),
          margin: EdgeInsets.symmetric(horizontal: 3, vertical: 4),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(const Radius.circular(5.0))),
          child: FittedBox(
            child: Text(
              difference != null
                  ? difference.isNegative || taken
                      ? "00"
                      : countdown
                  : countdown,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: difference != null
                      ? taken
                          ? Colors.red
                          : !difference.isNegative
                              ? /* AppColors.PRIMARY_COLOR */ !difference2
                                      .isNegative
                                  ? Colors.amber[600]
                                  : Color(0xFF64CE68)
                              : Colors.red
                      : !difference2.isNegative
                          ? Colors.amber[600]
                          : Color(0xFF64CE68)),
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          title,
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.028,
              fontWeight: FontWeight.bold,
              color: active
                  ? /* AppColors.PRIMARY_COLOR */ AppColors.normalTextColor
                      .withOpacity(0.8)
                  : AppColors.normalTextColor.withOpacity(0.8)),
        )
      ]);
}

Widget timeBtnActive(
    {String title,
    bool active,
    String countdown,
    BuildContext context,
    Duration difference,
    Duration difference2,
    bool taken = false}) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.08,
          height: MediaQuery.of(context).size.width * 0.08,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(2),
          margin: EdgeInsets.symmetric(horizontal: 3, vertical: 4),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(const Radius.circular(5.0))),
          child: FittedBox(
            child: Text(
              difference != null
                  ? difference.isNegative || taken
                      ? "00"
                      : countdown
                  : countdown,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: difference != null
                      ? taken
                          ? Colors.red
                          : !difference.isNegative
                              ? /* AppColors.PRIMARY_COLOR */ !difference2
                                      .isNegative
                                  ? Colors.yellow[700]
                                  : Color(0xFF64CE68)
                              : Colors.red
                      : !difference2.isNegative
                          ? Colors.yellow[700]
                          : Color(0xFF64CE68)),
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          title,
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.028,
              fontWeight: FontWeight.bold,
              color: active
                  ? /* AppColors.PRIMARY_COLOR */ AppColors.normalTextColor
                      .withOpacity(0.8)
                  : AppColors.normalTextColor.withOpacity(0.8)),
        )
      ]);
}

Widget timeBtnMedium(
    {String title, bool active, String countdown, BuildContext context}) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
      color: Colors.white,
      borderRadius: BorderRadius.all(const Radius.circular(5.0)),
    ),
    padding: EdgeInsets.all(8),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.06,
              height: MediaQuery.of(context).size.width * 0.06,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(2),
              margin: EdgeInsets.symmetric(horizontal: 3, vertical: 4),
              child: FittedBox(
                child: Text(
                  countdown,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: active
                        ? /* AppColors.PRIMARY_COLOR */ Color(0xFF64CE68)
                        : Colors.amber[600],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.024,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54
                  // color: AppColors.PRIMARY_COLOR,
                  ),
            ),
          )
        ]),
  );
}
