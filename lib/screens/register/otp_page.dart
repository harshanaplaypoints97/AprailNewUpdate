import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Api/handle_api.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/models/send_mail_to_reset_pass.dart';
import 'package:play_pointz/screens/home/home_page.dart';
import 'package:play_pointz/widgets/common/toast.dart';
import 'package:play_pointz/widgets/login/login_button_set.dart';
import '../../Animations/fade_animations.dart';
import '../../constants/app_colors.dart';
import '../../constants/page_transaction_router.dart';
import '../../models/login.dart';

class OtpPage extends StatefulWidget {
  String username;
  String password;
  String uId;
  OtpPage({Key key, this.username, this.password, this.uId}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController forgotPasswordEmailController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;

  UserController userController = Get.put(UserController());

  bool showbtn = false;
  bool verifyemail = false;
  bool enableResend = false;
  bool otpbtnLoading = false;
  bool shouldLoad = false;

  String otpText = "";

  int secondsRemaining = 0;
  int index;

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
    // super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 60.h,
            ),
            // PlayPointzLogoContainer(),
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
                          // obscureText: true,
                          // obscuringCharacter: '.',
                          // obscuringWidget: const FlutterLogo(
                          //   size: 24,
                          // ),
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
                          // onTap: () {
                          //   print("Pressed");
                          // },
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
                            debugPrint("Allowing to paste $text");
                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                            return true;
                          },
                        )),
                    enableResend
                        ? InkWell(
                            onTap: () async {
                              startTimer();
                              setState(() {
                                enableResend = false;
                                secondsRemaining = 90;
                              });
                              SendMailToResetPass result =
                                  await Api().resendOtp("${widget.uId}");
                              if (result.done) {
                                debugPrint(result.message);
                              }
                            },
                            child: Text(
                              'Resend',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 14),
                            ))
                        : Text(
                            'Resend after $_start seconds',
                            style: TextStyle(color: Colors.black, fontSize: 12),
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
                                    route: () async {
                                      SendMailToResetPass result = await Api()
                                          .verifyEmailByOtp(
                                              otpCode: otpText, id: widget.uId);
                                      if (result.done != null) {
                                        if (result.done) {
                                          // SendUser().saveDeviceToken("id");
                                          await messageToastGreen(
                                              result.message);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HomePage(activeIndex: 0),
                                            ),
                                          );
                                          // Get.off(HomePage());
                                        } else {
                                          messageToastRed(result.message);
                                        }
                                      }
                                    }),
                              )
                            : Container()
                        : showbtn
                            ? FadeAnimation(
                                delay: 0.2,
                                // child: loginBtnClr(
                                //     loading: otpbtnLoading,
                                //     context: context,
                                //     size: size,
                                //     title: 'Continue',
                                //     route: () async {
                                //       //EasyLoading.show(status: "Loading...");
                                //       SendMailToResetPass result = await Api()
                                //           .verifyEmail(
                                //               email:
                                //                   forgotPasswordEmailController
                                //                       .text,
                                //               otpCode: otpText);
                                //       if (result.done != null) {
                                //         if (result.done) {
                                //           //EasyLoading.dismiss();
                                //           messageToastGreen(result.message);
                                //           setState(() {
                                //             index = 3;
                                //           });
                                //         } else {
                                //           //EasyLoading.dismiss();
                                //           messageToastRed(result.message);
                                //         }
                                //       }
                                //     }),
                                child: shouldLoad
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                        color: AppColors.PRIMARY_COLOR,
                                      ))
                                    : MaterialButton(
                                        onPressed: () async {
                                          // await widget.action();

                                          // Only work when user is sign up and log to the account Then OTP will check once when that time it works now
                                          setState(() {
                                            shouldLoad = true;
                                          });
                                          Login login = await Api().loginApi(
                                              widget.username, widget.password);
                                          if (login.done) {
                                            SendMailToResetPass result =
                                                await Api().verifyEmailByOtp(
                                                    otpCode: otpText,
                                                    id: widget.uId);
                                            // messageToastGreen(result.message);

                                            if (result.done) {
                                              await HandleApi()
                                                  .getPlayerProfileDetails();
                                              Navigator.pushReplacement(
                                                  context,
                                                  FadeTransitionRouter(
                                                      child: HomePage(
                                                          fromRegisterPage:
                                                              true,
                                                          activeIndex: 0)));
                                              // Get.off(HomePage(
                                              //       fromRegisterPage: true,
                                              //     ));
                                            } else {
                                              messageToastRed(result.message);
                                              // debugPrint(
                                              //     "second request failed");
                                            }
                                          }
                                          setState(() {
                                            shouldLoad = false;
                                          });
                                          // SendMailToResetPass result = await Api()
                                          //     .verifyEmailByOtp(otpCode: otpText);
                                          // messageToastGreen(result.message);
                                          // messageToastGreen(result.done.toString());
                                          // if (result.done) {
                                          //   Login login = await Api().loginApi(
                                          //       widget.username, widget.password);
                                          //   if (login.done) {
                                          //     Navigator.pushReplacement(
                                          //         context,
                                          //         FadeTransitionRouter(
                                          //             child: HomePage()));
                                          //   }
                                          // }
                                          // SendMailToResetPass result = await Api()
                                          //       .verifyEmail(
                                          //           email:
                                          //               forgotPasswordEmailController
                                          //                   .text,
                                          //           otpCode: otpText);
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
