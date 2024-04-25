import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/constants/app_colors.dart';

InkWell answerBtn(
    {String answer, bool selected, Function function, BuildContext context}) {
  return InkWell(
    onTap: function,
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
          color:
              selected ? Color.fromARGB(255, 58, 192, 62) : Color(0xFFECEEF1),
          borderRadius: BorderRadius.all(const Radius.circular(12.0))),
      child: Row(
        children: [
          selected
              ? Radio(
                  value: 2,
                  groupValue: 2,
                  fillColor: MaterialStateColor.resolveWith(
                      (states) => AppColors.WHITE),
                )
              : Radio(
                  value: 1,
                  groupValue: 2,
                  fillColor: MaterialStateColor.resolveWith(
                      (states) => Colors.black54),
                  onChanged: (val) {
                    function();
                  },
                ),
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              answer,
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

MaterialButton answerSubmitBtn(BuildContext context,
    {var size, Function function}) {
  return MaterialButton(
    onPressed: function,
    child: Container(
      height: kToolbarHeight * 0.8,
      width: size.width,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
          color: AppColors.PRIMARY_COLOR,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.0,
              spreadRadius: 2.0,
            ),
          ],
          borderRadius: BorderRadius.all(const Radius.circular(6.0))),
      child: Center(
        child: Text(
          'Submit',
          style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}

InkWell selectCharacterBtn(
    {String character, bool selected, Function function}) {
  return InkWell(
    onTap: () {
      function();
    },
    child: Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: selected ? Colors.transparent : Colors.grey.shade400,
              blurRadius: 8,
              offset: Offset(0, 3), // Shadow Positioned
              spreadRadius: 1,
            ),
          ],
          borderRadius: BorderRadius.circular(10),
          color: selected ? Color.fromARGB(255, 66, 211, 70) : Colors.white),
      child: Center(
          child: Text(
        character,
        style: TextStyle(
            color: selected ? Colors.white : Colors.grey.shade700,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700),
      )),
    ),
  );
}
