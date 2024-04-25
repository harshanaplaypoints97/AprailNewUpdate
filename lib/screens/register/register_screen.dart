import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Shared%20Pref/player_pref.dart';
import 'package:play_pointz/models/login.dart';
import 'package:play_pointz/models/signUp.dart';
import 'package:play_pointz/screens/register/otp_page.dart';
import 'package:play_pointz/screens/register/register_screen_step_3.dart';
import 'package:play_pointz/screens/register/register_screen_step_01.dart';
import 'package:play_pointz/screens/register/register_screen_step_02.dart';
import 'package:play_pointz/widgets/common/loading_screen.dart';

import '../../constants/page_transaction_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int activeIndex = 0;
  final PageController pageController = PageController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController city = TextEditingController();
  String gender = "male";

  String deviceId = '';
  // String deviceId='';

  bool signingLoad = false;

  final _key = GlobalKey<FormState>();

  List<Widget> get registerScreens => [
        RegisterViewStep01(
          callback: navigateToPageOne,
          firstName: firstName,
          lastName: lastName,
          username: username,
          city: city,
        ),
        RegisterViewStep02(
          controller: email,
          setFemale: setFemale,
          setMale: setMale,
          pageTransfer: navigateToPageTwo,
          back: stepBack,
        ),
        RegisterViewStep03(
          password: password,
          confirmPassword: confirmPassword,
          action: register,
          back: stepBack,
          signingLoad: signingLoad,
        ),
      ];

  List<Map<String, String>> lottiePaths = [
    {"title": "Play Games", "path": "play_games.json"},
    {"title": "Buy Items", "path": "e-commerce.json"},
    {"title": "Win Items", "path": "game.json"},
  ];

  Future<void> navigateToPageOne() async {
    if (_key.currentState.validate()) {
      String name = "${firstName.text} ${lastName.text}".toLowerCase();
      if (name.contains("play points") ||
          name.contains("play pointz") ||
          name.contains("playpointz") ||
          name.contains("playpoints") ||
          name.contains("points play")) {
        Get.dialog(AlertDialog(
          title: Text(
              "You can't add names like PlayPointz, Play Points and PlayPoints etc..."),
        ));
      } else {
        /* setState(() {
          activeIndex = 1;
        }); */
        Login responce = await Api().checkUserName(username.text);
        if (responce.done) {
          setState(() {
            activeIndex = 1;
          });
        } else {
          Get.snackbar("Username exist", responce.message);
        }
      }
    }
  }

  getDeviceId() async {
    String devId = await PlatformDeviceId.getDeviceId;
    setState(() {
      deviceId = devId;
    });
  }

  void navigateToPageTwo() async {
    if (_key.currentState.validate()) {
      if (gender != "") {
        Login result = await Api().checkEmailDomain(email.text);
        if (result.done) {
          setState(() {
            activeIndex = 2;
          });
        } else {
          Get.snackbar("Hey", result.message);
        }
      } else {
        Get.snackbar("Hey", "Plase pick a gender");
      }
    }
  }

  void stepBack() {
    setState(() {
      activeIndex--;
    });
  }

  void setMale() {
    setState(() {
      gender = "male";
    });
  }

  void setFemale() {
    setState(() {
      gender = "female";
    });
  }

  bool shouldLoad = false;

  Future<void> register() async {
    await getDeviceId();
    if (_key.currentState.validate()) {
      if (password.text == confirmPassword.text) {
        setState(() {
          signingLoad = true;
        });
        var token = await getPlayerPref(key: "ref_token");

        String refToken = token == "" ? null : token["ref_token"];

        NewSignUp signUp = await Api().playerSignUp(
            email.text,
            username.text,
            gender,
            "${firstName.text} ${lastName.text}",
            password.text,
            refToken,
            deviceId);
        if (signUp.done) {
          Navigator.pushReplacement(
              context,
              FadeTransitionRouter(
                  child: OtpPage(
                      username: username.text,
                      password: password.text,
                      uId: signUp.body.id)));
        } else {
          setState(() {
            signingLoad = false;
          });
          SnackBar snackBar = SnackBar(
            content: Text(
              "Signup failed.${signUp.message}",
              textAlign: TextAlign.center,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }

        // setState(() {
        //   shouldLoad = true;
        // });

      } else {
        Get.snackbar("Hey", "Passwords didn't match. Please re-enter");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: shouldLoad
            ? const LoadingScreen()
            : Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
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
                      "All in one place",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: activeIndex == 1
                          ? Image.asset("assets/new/register1.png")
                          : Image.asset("assets/new/register2.png"),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3,
                      child: Form(
                        key: _key,
                        // child: AnimatedSwitcher(
                        //   child: registerScreens[activeIndex],
                        //   duration: const Duration(milliseconds: 800),
                        // ),
                        child: PageView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: registerScreens.length,
                          itemBuilder: ((context, index) =>
                              registerScreens[activeIndex]),
                          onPageChanged: ((value) => setState(() {
                                activeIndex = value;
                              })),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
