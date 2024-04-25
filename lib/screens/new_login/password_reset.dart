import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:play_pointz/Api/ApiV2/api_V2.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/controllers/user_controller.dart';

import 'new_login_screen.dart';

class PasswordReset extends StatefulWidget {
  final String email;

  const PasswordReset({
    Key key,
    this.email,
  }) : super(key: key);

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  bool shouldVisiblePw = false;
  bool shouldVisibleConPw = false;
  TextEditingController passwordControler = TextEditingController();
  TextEditingController conformPasswordControler = TextEditingController();
  UserController userController = Get.put(UserController());
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Form(
            key: _key,
            child: Column(
              children: [
                SizedBox(
                  height: 60.h,
                ),
                SizedBox(
                  height: 60.h,
                  width: MediaQuery.of(context).size.width,
                  child: FittedBox(
                    child: Image.asset(
                      "assets/new/logo.png",
                      fit: BoxFit.cover,
                      // repeat: false,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                SizedBox(
                  height: 200.h,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset("assets/new/OTP_1.png"),
                  ),
                ),
                SizedBox(
                  height: 60.h,
                ),
                TextFormField(
                  validator: (val) {
                    if (val != null) {
                      RegExp regex = RegExp(
                          r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d`!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?~\d]{6,}$');
                      if (val.isEmpty) {
                        return 'Please enter password';
                      } else {
                        if (!regex.hasMatch(val)) {
                          return 'Please, insert valid password';
                        } else {
                          return null;
                        }
                      }
                    } else {
                      return null;
                    }
                  },
                  maxLength: 12,
                  buildCounter: (BuildContext context,
                          {int currentLength, int maxLength, bool isFocused}) =>
                      null,
                  obscureText: !shouldVisiblePw,
                  keyboardType: TextInputType.emailAddress,
                  controller: passwordControler,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.scaffoldBackGroundColor,
                    labelText: "New Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          shouldVisiblePw = !shouldVisiblePw;
                        });
                      },
                      icon: Icon(!shouldVisiblePw
                          ? FontAwesomeIcons.eyeSlash
                          : FontAwesomeIcons.eye),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  obscureText: !shouldVisibleConPw,
                  validator: (val) {
                    if (val != null) {
                      RegExp regex = RegExp(
                          r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d`!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?~\d]{6,}$');
                      if (val.isEmpty) {
                        return 'Please enter above password';
                      } else {
                        if (!regex.hasMatch(val)) {
                          return 'Please, insert valid password';
                        } else {
                          return null;
                        }
                      }
                    } else {
                      return null;
                    }
                  },
                  maxLength: 12,
                  buildCounter: (BuildContext context,
                          {int currentLength, int maxLength, bool isFocused}) =>
                      null,
                  keyboardType: TextInputType.emailAddress,
                  controller: conformPasswordControler,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.scaffoldBackGroundColor,
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          shouldVisibleConPw = !shouldVisibleConPw;
                        });
                      },
                      icon: Icon(!shouldVisibleConPw
                          ? FontAwesomeIcons.eyeSlash
                          : FontAwesomeIcons.eye),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Center(
                    child: SizedBox(
                        child: Text(
                      '(Password must contain at least one character and a number. Minimum length should be 6.)',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11.sp,
                      ),
                      textAlign: TextAlign.center,
                    )),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                MaterialButton(
                  onPressed: () async {
                    if (_key.currentState.validate()) {
                      if (passwordControler.text ==
                          conformPasswordControler.text) {
                        var res = await ApiV2().resetPassword(
                            email: widget.email,
                            password: passwordControler.text);

                        if (res) {
                          Get.snackbar("Password Reset Success",
                              "Now Please Login to your account");
                          Get.off(() => NewLoginScreen());
                        } else {
                          Get.snackbar("Somthing went wrong", "");
                        }
                      } else {
                        Get.snackbar(
                            "Hey", "Passwords didn't match. Please re-enter");
                      }
                    }
                  },
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  minWidth: MediaQuery.of(context).size.width,
                  height: kToolbarHeight,
                  child: Text(
                    "Reset Password",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                  color: AppColors.PRIMARY_COLOR,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
