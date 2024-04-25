import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Shared%20Pref/player_pref.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/models/log_out.dart';
import 'package:play_pointz/screens/home/splash_screen.dart';
import 'package:play_pointz/screens/profile/brand_page.dart';
import 'package:play_pointz/screens/profile/profile_privacy.dart';
import 'package:play_pointz/services/firebase_service.dart';
import 'package:play_pointz/widgets/common/toast.dart';
import 'package:play_pointz/widgets/profile/dialog_Widget.dart';
import 'package:play_pointz/widgets/profile/sub_screen_buttons.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSettings extends StatefulWidget {
  final VoidCallback callback;
  const ProfileSettings({
    Key key,
    this.callback,
  }) : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  bool btnLoading = false;
  final TextEditingController passwordController = TextEditingController();
  bool shouldVisible = false;

  @override
  void initState() {
    super.initState();
  }

  deactivatedUser() async {
    try {
      setState(() {
        btnLoading = true;
      });
      Navigator.pop(context);
      alertDialogDeactivate(
          loading: btnLoading,
          passwordField: inputField(passwordController, "Password",
              isPassword: shouldVisible),
          context: context,
          function: () async {
            deactivatedUser();
          },
          cancel: () {
            setState(() {
              passwordController.clear();
            });
          });
      LogOut result = await Api().playerDeactivate(
          email: userController.currentUser.value.email,
          userName: userController.currentUser.value.username,
          password: passwordController.text);
      if (result.done) {
        LogOut result2 = await Api().PlayerLogOut();
        if (result2.done) {
          await SendUser().deleteDeviceToken();
          removePlayerPref(key: "playerProfileDetails");
          removePlayerPref(key: "search");
          Get.deleteAll();
          socket.destroy();

          setState(() {
            btnLoading = false;
          });
          final prefManager = await SharedPreferences.getInstance();
          await prefManager.clear();
          Restart.restartApp();
          socket.dispose();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => MainSplashScreen(),
            ),
            (route) => false,
          );
        }
      } else {
        setState(() {
          btnLoading = false;
        });
        messageToastRed(result.message);
        Navigator.pop(context);
        alertDialogDeactivate(
            loading: btnLoading,
            passwordField: inputField(passwordController, "Password",
                isPassword: shouldVisible),
            context: context,
            function: () async {
              deactivatedUser();
            },
            cancel: () {
              setState(() {
                passwordController.clear();
              });
            });
      }
    } catch (e) {
      debugPrint("++++++++++++++ deactivating failed" + e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(),
        backgroundColor: Colors.white,
        title: Text("Profile Settings"),
      ),
      backgroundColor: AppColors.scaffoldBackGroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            subScreenButtonProfile(
                context: context,
                displayText: "Convert to brand page",
                // displayIcon: FaIcon(FontAwesomeIcons),
                displayIcon: FaIcon(Icons.repeat),
                navigateScreen: () {
                  DefaultRouter.defaultRouter(ConvertToPage(
                    callback: () {
                      setState(() {});
                    },
                  ), context);
                }),
            subScreenButtonProfile(
                context: context,
                displayText: "Account privacy",
                displayIcon: FaIcon(FontAwesomeIcons.lock),
                navigateScreen: () {
                  DefaultRouter.defaultRouter(ProfilePrivacy(
                    callback: () {
                      setState(() {});
                    },
                  ), context);
                }),
            subScreenButtonProfile(
                context: context,
                displayText: "Account delete",
                displayIcon: FaIcon(
                  FontAwesomeIcons.userMinus,
                  color: Colors.red,
                ),
                navigateScreen: () => alertDialogDeactivate(
                    loading: btnLoading,
                    passwordField: inputField(passwordController, "Password",
                        isPassword: shouldVisible),
                    context: context,
                    function: () async {
                      deactivatedUser();
                    },
                    cancel: () {
                      setState(() {
                        passwordController.clear();
                      });
                    })),
          ],
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
      maxLength: 20,
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
                  Navigator.pop(context);
                  alertDialogDeactivate(
                      loading: btnLoading,
                      passwordField: inputField(passwordController, "Password",
                          isPassword: shouldVisible),
                      context: context,
                      function: () async {
                        deactivatedUser();
                      },
                      cancel: () {
                        setState(() {
                          passwordController.clear();
                        });
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
