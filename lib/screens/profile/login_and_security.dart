import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/style.dart';
import 'package:play_pointz/models/update_password.dart';
import 'package:play_pointz/widgets/common/toast.dart';
import 'package:play_pointz/widgets/login/login_button_set.dart';

class LoginAndSecurity extends StatefulWidget {
  const LoginAndSecurity({Key key}) : super(key: key);

  @override
  State<LoginAndSecurity> createState() => _LoginAndSecurityState();
}

class _LoginAndSecurityState extends State<LoginAndSecurity> {
  TextEditingController email = TextEditingController();
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmNewPassword = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool formvalidated = false;

  bool saveBtnLoading = false;
  bool shouldLoad = false;
  bool obsecure = true;
  bool passwordvalidate = false;
  bool obsecureCurrent = true;
  bool obsecureconfirm = true;
  bool confirmpasword = false;

  void validateAndSave() {
    FormState form = _formKey.currentState;
    if (form.validate()) {
      setState(() {
        formvalidated = true;
      });
    } else {
      setState(() {
        formvalidated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Change Password"),
        leading: BackButton(),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        reverse: true,
        child: SizedBox(
            height: size.height * 0.75,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        TextFormField(
                          style: TextStyle(fontSize: 12),
                          obscureText: obsecureCurrent,
                          maxLength: 30,
                          buildCounter: (BuildContext context,
                                  {int currentLength,
                                  int maxLength,
                                  bool isFocused}) =>
                              null,
                          decoration: InputDecoration(
                            fillColor: AppColors.scaffoldBackGroundColor,
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            labelStyle: AppStyles.lableText,
                            hintText: 'Current Password',
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obsecureCurrent = !obsecureCurrent;
                                  });
                                },
                                icon: FaIcon(
                                  obsecureCurrent
                                      ? FontAwesomeIcons.eyeSlash
                                      : FontAwesomeIcons.eye,
                                  size: 18,
                                )),
                            contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          ),
                          controller: currentPassword,
                          textInputAction: TextInputAction.done,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value.isEmpty) {
                              return ("Current Password can't be empty");
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          maxLength: 12,
                          buildCounter: (BuildContext context,
                                  {int currentLength,
                                  int maxLength,
                                  bool isFocused}) =>
                              null,
                          style: TextStyle(fontSize: 12),
                          obscureText: obsecure,
                          decoration: InputDecoration(
                            fillColor: AppColors.scaffoldBackGroundColor,
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            errorMaxLines: 2,
                            errorStyle: TextStyle(
                                color: passwordvalidate
                                    ? Color.fromARGB(255, 182, 40, 30)
                                    : Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                overflow: TextOverflow.fade),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obsecure
                                        ? obsecure = false
                                        : obsecure = true;
                                  });
                                },
                                icon: FaIcon(
                                  obsecure
                                      ? FontAwesomeIcons.eyeSlash
                                      : FontAwesomeIcons.eye,
                                  size: 18,
                                )),
                            hintText: 'New Password',
                            labelStyle: AppStyles.lableText,
                            contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          ),
                          controller: newPassword,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            FocusScope.of(context).nextFocus();
                            setState(() {
                              passwordvalidate = true;
                            });
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            String pattern1 =
                                r'((?=.*[A-Za-z])(?=.*\d)[A-Za-z\d`!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?~\d])';
                            RegExp regExp1 = RegExp(pattern1);

                            String pattern5 = r'.{6,}';
                            RegExp regExp5 = RegExp(pattern5);
                            if (value.isEmpty) {
                              return "password can't be empty";
                            } else if (!regExp1.hasMatch(value)) {
                              return "please include letters and numbers";
                            } else if (!regExp5.hasMatch(value)) {
                              return "Length should be more than 6";
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        TextFormField(
                          maxLength: 12,
                          buildCounter: (BuildContext context,
                                  {int currentLength,
                                  int maxLength,
                                  bool isFocused}) =>
                              null,
                          style: TextStyle(fontSize: 12),
                          obscureText: obsecureconfirm,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            fillColor: AppColors.scaffoldBackGroundColor,
                            filled: true,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            labelStyle: AppStyles.lableText,
                            hintText: 'Confirm New Password',
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obsecureconfirm
                                        ? obsecureconfirm = false
                                        : obsecureconfirm = true;
                                  });
                                },
                                icon: FaIcon(
                                  obsecureconfirm
                                      ? FontAwesomeIcons.eyeSlash
                                      : FontAwesomeIcons.eye,
                                  size: 18,
                                )),
                            contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          ),
                          controller: confirmNewPassword,
                          textInputAction: TextInputAction.done,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if ((newPassword.text != confirmNewPassword.text)) {
                              return "Enter the same password";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  shouldLoad
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.PRIMARY_COLOR,
                          ),
                        )
                      : Container(
                          width: size.width,
                          padding: const EdgeInsets.all(24),
                          child: loginBtnClr(
                              loading: false,
                              context: context,
                              size: size,
                              title: 'Save',
                              route: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    shouldLoad = true;
                                  });
                                  UpdatePassword result = await Api()
                                      .updatePassword(
                                          email: email.text,
                                          currenPW: currentPassword.text,
                                          newPW: newPassword.text);
                                  if (result.done) {
                                    messageToastGreen(result.message);
                                    setState(() {
                                      currentPassword.clear();
                                      newPassword.clear();
                                      confirmNewPassword.clear();
                                    });
                                    Navigator.pop(context);
                                  } else {
                                    messageToastRed(result.message);
                                  }

                                  setState(() {
                                    shouldLoad = false;
                                  });
                                }
                              }),
                        ),
                ],
              ),
            )),
      ),
    );
  }
}
