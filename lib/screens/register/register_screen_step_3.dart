import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/screens/register/Privacy_policy/privacy_policy.dart';
import 'package:play_pointz/screens/register/components/auth_button.dart';
import 'package:play_pointz/screens/register/terms_conditions.dart';

class RegisterViewStep03 extends StatefulWidget {
  final TextEditingController password;
  final TextEditingController confirmPassword;
  final Future Function() action;
  final VoidCallback back;
  bool signingLoad;

  RegisterViewStep03(
      {Key key,
      this.password,
      this.confirmPassword,
      this.action,
      this.back,
      this.signingLoad})
      : super(key: key);

  @override
  State<RegisterViewStep03> createState() => _RegisterViewStep03State();
}

class _RegisterViewStep03State extends State<RegisterViewStep03> {
  bool shouldVisiblePw = false;
  bool shouldVisibleConPw = false;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 8,
          ),
          TextFormField(
            validator: (val) {
              if (val != null) {
                RegExp regex = RegExp(
                    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d`!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?~\d]{6,}$');
                if (val.isEmpty) {
                  return 'Please enter password!';
                } else {
                  if (!regex.hasMatch(val)) {
                    return 'Please enter a valid password!';
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
            controller: widget.password,
            decoration: InputDecoration(
              errorMaxLines: 2,
              labelText: "Password",
              fillColor: AppColors.scaffoldBackGroundColor,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide.none,
              ),
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
            height: 8,
          ),
          TextFormField(
            obscureText: !shouldVisibleConPw,
            validator: (val) {
              if (val != null) {
                RegExp regex = RegExp(
                    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d`!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?~\d]{6,}$');
                if (val.isEmpty) {
                  return 'Please enter password';
                } else {
                  if (!regex.hasMatch(val)) {
                    return 'Please enter a valid password.';
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
            controller: widget.confirmPassword,
            decoration: InputDecoration(
              errorMaxLines: 2,
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
                icon: Icon(
                  !shouldVisibleConPw
                      ? FontAwesomeIcons.eyeSlash
                      : FontAwesomeIcons.eye,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: SizedBox(
                  child: Text(
                '(Password must contain at least one character and a number. Minimum length should be 6)',
                style: TextStyle(color: Colors.grey[600], fontSize: 11.sp),
                textAlign: TextAlign.center,
              )),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          widget.signingLoad
              ? Container(
                  padding: const EdgeInsets.only(top: 24, bottom: 24),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.PRIMARY_COLOR,
                    ),
                  ),
                )
              : Row(
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
                        child: MaterialButton(
                          onPressed: () async {
                            await widget.action();
                          },
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          minWidth: MediaQuery.of(context).size.width,
                          height: kToolbarHeight,
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                          color: AppColors.PRIMARY_COLOR,
                        )),
                  ],
                ),
          SizedBox(
            height: 16,
          ),
          Center(
            child: Column(
              //  mainAxisSize: MainAxisSize.min,
              children: [
                Text("By signing up, you Agree to our"),
                SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        DefaultRouter.defaultRouter(TermsConditions(), context);
                      },
                      child: Text(
                        "Terms & Conditions",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    ),
                    Text("  and  "),
                    InkWell(
                      onTap: () {
                        DefaultRouter.defaultRouter(PrivacyPolicy(), context);
                      },
                      child: Text(
                        "Privacy Policy",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    ),
                  ],
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
