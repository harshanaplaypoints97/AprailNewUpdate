import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/controllers/register_page_controller.dart';
import 'package:play_pointz/screens/new_login/new_login_screen.dart';
import 'package:play_pointz/screens/register/components/auth_button.dart';
import 'package:play_pointz/screens/register/components/input_field.dart';

class RegisterViewStep01 extends StatelessWidget {
  final VoidCallback callback;
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController username;
  final TextEditingController city;
  RegisterViewStep01({
    Key key,
    this.callback,
    this.firstName,
    this.lastName,
    this.city,
    this.username,
  }) : super(key: key);
  final controller = Get.put(RegisterPageIndexController());
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: AuthenticationInputField(
                  isUsername: false,
                  isEmail: false,
                  maxLength: 14,
                  controller: firstName,
                  isPassword: false,
                  textInputType: TextInputType.text,
                  hintText: "First Name",
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: AuthenticationInputField(
                  isUsername: false,
                  isEmail: false,
                  maxLength: 14,
                  controller: lastName,
                  isPassword: false,
                  textInputType: TextInputType.name,
                  hintText: "Last Name",
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          AuthenticationInputField(
            isEmail: false,
            isUsername: true,
            maxLength: 12,
            controller: username,
            isPassword: false,
            textInputType: TextInputType.name,
            hintText: "Username",
          ),
          const SizedBox(
            height: 8,
          ),
          AuthenticationButton(
            callback: callback,
            text: "Next",
          ),
          SizedBox(
            height: 8,
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    DefaultRouter.defaultRouter(NewLoginScreen(), context);
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.PRIMARY_COLOR,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
