import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Api/handle_api.dart';
import 'package:play_pointz/Shared%20Pref/player_pref.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/constants/page_transaction_router.dart';
import 'package:play_pointz/models/login.dart';
import 'package:play_pointz/models/send_mail_to_reset_pass.dart';
import 'package:play_pointz/screens/home/home_page.dart';
import 'package:play_pointz/screens/new_login/forget_password_view.dart';
import 'package:play_pointz/screens/register/otp_page.dart';
import 'package:play_pointz/screens/register/register_screen.dart';
import 'package:play_pointz/services/firebase_service.dart';

import '../../controllers/user_controller.dart';

class NewLoginScreen extends StatefulWidget {
  const NewLoginScreen({Key key}) : super(key: key);

  @override
  State<NewLoginScreen> createState() => _NewLoginScreenState();
}

class _NewLoginScreenState extends State<NewLoginScreen> {
  final TextEditingController userNameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool shouldLoad = false;

  bool shouldVisible = false;

  Timer timer;

  UserController userController = Get.put(UserController());

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
        child: SingleChildScrollView(
          reverse: true,
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // PlayPointzLogoContainer(),
                SizedBox(
                  height: 60.h,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: FittedBox(
                    child: Image.asset(
                      "assets/new/logo.png",
                      fit: BoxFit.cover,
                      // repeat: false,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  "Welcome",
                  style: TextStyle(fontSize: 18.sp),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: 250.h,
                    width: MediaQuery.of(context).size.width,
                    child: FittedBox(
                      child: Image.asset(
                        "assets/new/login.png",
                        // repeat: false,
                      ),
                    ),
                  ),
                ),

                inputField(userNameController, "Username / Email"),
                const SizedBox(
                  height: 8,
                ),
                inputField(passwordController, "Password",
                    isPassword: shouldVisible),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        DefaultRouter.defaultRouter(
                            ForgetPasswordView(), context);
                      },
                      child: const Text(
                        "Forgot Password",
                        style: TextStyle(
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                shouldLoad
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      )
                    : MaterialButton(
                        color: AppColors.PRIMARY_COLOR,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        onPressed: () async {
                          if (_key.currentState.validate()) {
                            setState(() {
                              shouldLoad = true;
                            });
                            Login login = await Api().loginApi(
                                userNameController.text,
                                passwordController.text);
                            if (login.done) {
                              await HandleApi().getPlayerProfileDetails();
                              var profileData = await getPlayerPref(
                                  key: "playerProfileDetails");
                              if (profileData["is_verified"]) {
                                Get.off(() => HomePage(
                                      activeIndex: 0,
                                    ));
                                SendUser().saveDeviceToken("id");
                              } else {
                                SendMailToResetPass result =
                                    await Api().resendOtp(profileData["id"]);
                                if (result.done) {
                                  debugPrint(result.message);
                                  Navigator.pushReplacement(
                                      context,
                                      FadeTransitionRouter(
                                          child: OtpPage(
                                              username: userNameController.text,
                                              password: passwordController.text,
                                              uId: profileData["id"])));
                                }
                              }
                            } else {
                              setState(() {
                                shouldLoad = false;
                              });
                              SnackBar snackBar = SnackBar(
                                  content: Text(
                                "Login failed, ${login.message}",
                                textAlign: TextAlign.center,
                              ));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                          setState(() {
                            shouldLoad = false;
                          });
                        },
                        minWidth: MediaQuery.of(context).size.width,
                        height: kToolbarHeight,
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        DefaultRouter.defaultRouter(RegisterScreen(), context);
                      },
                      child: Text(
                        "Create One",
                        style: TextStyle(
                          color: AppColors.PRIMARY_COLOR,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget inputField(TextEditingController controller, String hintTetx,
      {bool isPassword = false}) {
    return TextFormField(
      obscureText: hintTetx == "Password" ? !isPassword : false,
      controller: controller,
      validator: (val) {
        if (val != null) {
          if (val.isEmpty) {
            return "Please fill this field";
          } else {
            return null;
          }
        } else {
          return null;
        }
      },
      maxLength: 30,
      buildCounter: (BuildContext context,
              {int currentLength, int maxLength, bool isFocused}) =>
          null,
      decoration: InputDecoration(
        labelText: hintTetx,
        fillColor: AppColors.scaffoldBackGroundColor,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none),
        suffixIcon: hintTetx == "Password"
            ? IconButton(
                onPressed: () {
                  setState(() {
                    shouldVisible = !shouldVisible;
                  });
                },
                icon: Icon(!shouldVisible
                    ? FontAwesomeIcons.eyeSlash
                    : FontAwesomeIcons.eye),
              )
            : null,
      ),
    );
  }
}
