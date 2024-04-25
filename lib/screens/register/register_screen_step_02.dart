import 'package:flutter/material.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/screens/new_login/new_login_screen.dart';
import 'package:play_pointz/screens/register/components/auth_button.dart';
import 'package:play_pointz/screens/register/components/input_field.dart';

enum gender { male, female }

class RegisterViewStep02 extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback setMale;
  final VoidCallback setFemale;
  final VoidCallback pageTransfer;
  final VoidCallback back;
  const RegisterViewStep02({
    Key key,
    this.controller,
    this.setMale,
    this.setFemale,
    this.pageTransfer,
    this.back,
  }) : super(key: key);

  @override
  State<RegisterViewStep02> createState() => _RegisterViewStep02State();
}

class _RegisterViewStep02State extends State<RegisterViewStep02> {
  gender g = gender.male;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 8,
          ),
          AuthenticationInputField(
            isUsername: false,
            isEmail: true,
            maxLength:100 ,
            controller: widget.controller,
            isPassword: false,
            textInputType: TextInputType.emailAddress,
            hintText: "Email",
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Radio(
                value: gender.male,
                groupValue: g,
                onChanged: (val) {
                  widget.setMale();
                  setState(() {
                    g = gender.male;
                  });
                },
              ),
              Text("Male"),
              Radio(
                value: gender.female,
                groupValue: g,
                onChanged: (val) {
                  widget.setFemale();
                  setState(() {
                    g = gender.female;
                  });
                },
              ),
              Text("Female"),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: AuthenticationButton(
                  callback: widget.back,
                  text: "Previous",
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: AuthenticationButton(
                  callback: widget.pageTransfer,
                  text: "Next",
                ),
              ),
            ],
          ),
          SizedBox(height: 8,),
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
          SizedBox(height: 16,),
        ],
      ),
    );
  }
}
