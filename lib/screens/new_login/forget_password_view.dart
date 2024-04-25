import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/screens/new_login/foreget_password_otp_view.dart';

import 'package:play_pointz/screens/register/components/auth_button.dart';
import 'package:play_pointz/screens/register/components/input_field.dart';

import '../../controllers/user_controller.dart';

class ForgetPasswordView extends StatefulWidget {
  ForgetPasswordView({Key key}) : super(key: key);

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final UserController userController = Get.put(UserController());

  final TextEditingController email = TextEditingController();

  final _key = GlobalKey<FormState>();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        //  height: MediaQuery.of(context).size.height,
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
            SizedBox(height: 30.h),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                //height: 200.h,
                width: MediaQuery.of(context).size.width,
                child: FittedBox(
                  child: Image.asset(
                    "assets/new/register2.png",
                    // repeat: false,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            Form(
              key: _key,
              child: AuthenticationInputField(
                isUsername: false,
                maxLength: 100,
                isEmail: true,
                hintText: "Email",
                controller: email,
                isPassword: false,
                textInputType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            loading
                ? Container(
                    padding: const EdgeInsets.only(top: 24, bottom: 24),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.PRIMARY_COLOR,
                      ),
                    ),
                  )
                : AuthenticationButton(
                    callback: () async {
                      if (_key.currentState.validate()) {
                        setState(() {
                          loading = true;
                        });
                        await Api()
                            .sendEmailForgotPassword(email.text)
                            .then((value) {
                          if (value.done) {
                            DefaultRouter.defaultRouter(
                                ForgetPasswordOtpPage(email: email.text),
                                context);
                            setState(() {
                              loading = false;
                            });
                          } else {
                            Get.snackbar("Sending reset password failed",
                                "Please check your email!");
                            setState(() {
                              loading = false;
                            });
                          }
                        });
                      }
                    },
                    text: "Submit",
                  )
          ],
        ),
      ),
    );
  }
}
