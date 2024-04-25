import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Api/ApiV2/api_V2.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/widgets/login/login_button_set.dart';
import '../../Animations/fade_animations.dart';
import '../../constants/app_colors.dart';
import 'password_reset.dart';

class ForgetPasswordOtpPage extends StatefulWidget {
  final String email;
  const ForgetPasswordOtpPage({Key key, this.email}) : super(key: key);

  @override
  State<ForgetPasswordOtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<ForgetPasswordOtpPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController forgotPasswordEmailController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;

  bool showbtn = false;
  bool verifyemail = false;
  bool enableResend = false;
  bool otpbtnLoading = false;
  bool shouldLoad = false;
  String otpText = "";

  int secondsRemaining = 0;
  int index;
  UserController userController = Get.put(UserController());

  Timer _timer;
  int _start = 60;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            enableResend = true;
            _start = 60;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    debugPrint("input otp length ${textEditingController.text.length}");
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
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
              height: 20.h,
            ),
            Text(
              "Check your email and enter OTP",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              height: 200.h,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset("assets/new/OTP_1.png"),
              ),
            ),
            SizedBox(
              height: 380.h,
              width: size.width,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 100.h,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 30),
                        child: PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                          length: 4,
                          blinkWhenObscuring: true,
                          animationType: AnimationType.fade,
                          validator: (v) {
                            if (v.length < 4) {
                              return "Code must contain 4 numbers";
                            } else {
                              return null;
                            }
                          },
                          pinTheme: PinTheme(
                            inactiveFillColor: Colors.white,
                            selectedFillColor: Colors.white,
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            activeFillColor: Colors.white,
                          ),
                          cursorColor: Colors.black,
                          animationDuration: const Duration(milliseconds: 300),
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: textEditingController,
                          keyboardType: TextInputType.number,
                          boxShadows: const [
                            BoxShadow(
                              offset: Offset(0, 1),
                              color: Colors.black12,
                              blurRadius: 10,
                            )
                          ],
                          onCompleted: (v) {
                            if (v.length == 4) {
                              setState(() {
                                showbtn = true;
                              });
                            } else {
                              setState(() {
                                showbtn = false;
                              });
                            }
                          },
                          onChanged: (value) {
                            debugPrint(value);
                            setState(() {
                              otpText = value;
                            });
                            if (value.length != 4) {
                              setState(() {
                                showbtn = false;
                              });
                            }
                          },
                          beforeTextPaste: (text) {
                            return true;
                          },
                        )),
                    enableResend
                        ? InkWell(
                            onTap: () async {
                              setState(() {
                                enableResend = false;
                              });
                              startTimer();
                              await Api()
                                  .sendEmailForgotPassword(widget.email)
                                  .then((value) {
                                if (value.done) {
                                  Get.snackbar("Please check your email!",
                                      "Password rest otp sent successfully");
                                } else {
                                  Get.snackbar("Sending reset OTP failed",
                                      "Please check your OTP!");
                                }
                              });
                            },
                            child: Text(
                              'Resend',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18.sp,
                              ),
                            ))
                        : Text(
                            'Resend after $_start seconds',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                            ),
                          ),
                    SizedBox(
                      height: 50,
                    ),
                    verifyemail
                        ? showbtn
                            ? FadeAnimation(
                                delay: 0.2,
                                child: loginBtnClr(
                                    loading: otpbtnLoading,
                                    context: context,
                                    size: size,
                                    title: 'Continue',
                                    route: () async {}),
                              )
                            : Container()
                        : showbtn
                            ? shouldLoad
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.PRIMARY_COLOR,
                                    ),
                                  )
                                : FadeAnimation(
                                    delay: 0.2,
                                    child: MaterialButton(
                                      onPressed: () async {
                                        setState(() {
                                          shouldLoad = true;
                                        });
                                        var res = await ApiV2()
                                            .checkForgetToken(
                                                email: widget.email,
                                                token: otpText);
                                        debugPrint("RES >>>> ${res["done"]}");
                                        debugPrint("continue button called");
                                        setState(() {
                                          shouldLoad = false;
                                        });
                                        if (res["done"] == true) {
                                          Get.off(() => PasswordReset(
                                              email: widget.email));
                                        } else {
                                          Get.snackbar(
                                              "ERROR", "${res["message"]}");
                                        }
                                      },
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      minWidth:
                                          MediaQuery.of(context).size.width *
                                              0.9,
                                      height: kToolbarHeight,
                                      child: Text(
                                        "Continue",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.sp,
                                        ),
                                      ),
                                      color: AppColors.PRIMARY_COLOR,
                                    ),
                                  )
                            : Container()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
