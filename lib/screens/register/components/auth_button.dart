import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/constants/app_colors.dart';

class AuthenticationButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;
  const AuthenticationButton({
    Key key,
    this.callback,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      onPressed: callback,
      minWidth: MediaQuery.of(context).size.width,
      height: kToolbarHeight,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
        ),
      ),
      color: AppColors.PRIMARY_COLOR,
    );
  }
}
