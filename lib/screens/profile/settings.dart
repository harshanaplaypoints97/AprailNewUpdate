import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Api/handle_api.dart';
import 'package:play_pointz/Shared%20Pref/player_pref.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/controllers/coin_balance_controller.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/models/home/popup_banner.dart';
import 'package:play_pointz/models/log_out.dart';
import 'package:play_pointz/screens/about_us/about_us_screen.dart';
import 'package:play_pointz/screens/connect/connect.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/home/home_page.dart';
import 'package:play_pointz/screens/home/splash_screen.dart';
import 'package:play_pointz/screens/profile/login_and_security.dart';
import 'package:play_pointz/screens/profile/profile.dart';

import 'package:play_pointz/screens/profile/support.dart';

import 'package:play_pointz/screens/register/Privacy_policy/privacy_policy.dart';
import 'package:play_pointz/screens/register/delivery_terms.dart';
import 'package:play_pointz/screens/register/terms_conditions.dart';
import 'package:play_pointz/widgets/common/notification_button.dart';
import 'package:play_pointz/widgets/common/popup.dart';
import 'package:play_pointz/widgets/common/toast.dart';
// import 'package:play_pointz/widgets/common/toast.dart';
import 'package:play_pointz/widgets/profile/dialog_Widget.dart';
import 'package:play_pointz/widgets/profile/profile_name.dart';
import 'package:play_pointz/widgets/profile/sub_screen_buttons.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:play_pointz/services/firebase_service.dart';
import 'package:platform_device_id/platform_device_id.dart';

class Settings extends StatefulWidget {
  Settings({Key key, this.unreadNotifications}) : super(key: key);
  String unreadNotifications;

  @override
  State<Settings> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<Settings> {
  bool myData = false;
  var profileData;
  getPlayerDetailsa() async {
    await HandleApi().getPlayerProfileDetails();
    profileData = await getPlayerPref(key: "playerProfileDetails");

    // setState(() {
    //   myData = true;
    // });
  }

  bool btnLoading = false;
  CoinBalanceController coinBalanceController;
  final UserController userController = Get.put(UserController());

  String devId = "";
  String current = '';

  final TextEditingController passwordController = TextEditingController();
  bool shouldVisible = false;

  showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(height: 150, color: Colors.red);
        });
  }

  getDeviceId() async {
    String deviceId = await PlatformDeviceId.getDeviceId;
    setState(() {
      devId = deviceId;
    });
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  getcurrent() async {
    const oneSec = Duration(seconds: 3);
    Timer.periodic(
        oneSec,
        (Timer t) => setState(() {
              current = '';
            }));
  }

  showLatePopup() async {
    PopUpData data = await Api().getlatePopUp();
    if (data.done) {
      if (data.body != null) {
        loadPopup(data.body.image_url, data.body.id);
      }
    }
  }

  loadPopup(String imgUrl, String id) {
    try {
      var _image = NetworkImage(imgUrl);

      _image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener(
          (info, call) {
            print('Networkimage is fully loaded and saved');
            showPopupBanner(imgUrl, id, context);
          },
        ),
      );
    } catch (e) {
      print(e);
    }
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
  void initState() {
    super.initState();
    getPlayerDetailsa();
    getcurrent();
    getDeviceId();
    coinBalanceController = Get.put(CoinBalanceController(callback: () {
      debugPrint(
          "+++++++++++++++++++++++++ controller from paly widget called");
      setState(() {});
    }));
    showLatePopup();
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
//Harshana Devolopment  upper part R*
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GestureDetector(
                onTap: () {
                  // DefaultRouter.defaultRouter(ProfileNew(), context);
                  DefaultRouter.defaultRouter(
                    Profile(
                      myProfile: true,
                    ),
                    context,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  height: 90,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //Profile Image
                        // ProfileImage(profileData: profileData),
                        ClipOval(
                          child: CachedNetworkImage(
                            cacheManager: CustomCacheManager.instance,
                            imageUrl:
                                userController.currentUser.value.profileImage,
                            width: 50.w,
                            height: 50.w,
                            fit: BoxFit.fill,
                            fadeInDuration: const Duration(milliseconds: 600),
                            fadeOutDuration: const Duration(milliseconds: 600),
                            errorWidget: (a, b, c) {
                              return CachedNetworkImage(
                                cacheManager: CustomCacheManager.instance,
                                imageUrl:
                                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                              );
                            },
                          ),
                        ),

                        SizedBox(
                          width: 20,
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            profileName(
                                name: userController.currentUser.value.fullName
                                        .substring(0, 10) ??
                                    ""),
                            userController.currentUser.value.username == null
                                ? Container()
                                : userLocation(
                                    name:
                                        "@${userController.currentUser.value.username}")
                          ],
                        ),
                        Spacer(),
                        NotificationButton(
                          unReadNotificationCount: widget.unreadNotifications,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: subScreenButton(
                  context: context,
                  displayText: "Change Password",
                  displayIcon: FaIcon(FontAwesomeIcons.shieldAlt),
                  navigateScreen: () {
                    DefaultRouter.defaultRouter(LoginAndSecurity(), context);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: subScreenButton(
                  context: context,
                  displayText: "Connect",
                  displayIcon: FaIcon(FontAwesomeIcons.shareAlt),
                  navigateScreen: () {
                    DefaultRouter.defaultRouter(ConnectPage(), context);
                  }),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: subScreenButton(
                  context: context,
                  displayText: "Contact Support",
                  displayIcon: FaIcon(FontAwesomeIcons.microphone),
                  navigateScreen: () {
                    DefaultRouter.defaultRouter(SupportPage(), context);
                  }),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: subScreenButton(
                context: context,
                displayText: "About Us",
                displayIcon: FaIcon(Icons.report),
                navigateScreen: () => {
                  DefaultRouter.defaultRouter(AboutUsScreen(), context),
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: subScreenButton(
                context: context,
                displayText: "Privacy Policy",
                displayIcon: FaIcon(Icons.privacy_tip_sharp),
                navigateScreen: () => {
                  DefaultRouter.defaultRouter(PrivacyPolicy(), context),
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: subScreenButton(
                context: context,
                displayText: "Terms & Conditions",
                displayIcon: FaIcon(Icons.fact_check),
                navigateScreen: () => {
                  DefaultRouter.defaultRouter(TermsConditions(), context),
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: subScreenButton(
                context: context,
                displayText: "Delivery Terms & Conditions",
                displayIcon: FaIcon(Icons.delivery_dining),
                navigateScreen: () => {
                  DefaultRouter.defaultRouter(
                      DeliveryTermsConditions(), context),
                },
              ),
            ),

            // SizedBox(
            //   height: 5,
            // ), // Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: subScreenButton(
                  context: context,
                  displayText: "Log out",
                  displayIcon: FaIcon(FontAwesomeIcons.signOutAlt),
                  navigateScreen: () => alertDialog(
                        loading: btnLoading,
                        context: context,
                        function: () async {
                          setState(() {
                            btnLoading = true;
                          });

                          LogOut result = await Api().PlayerLogOut();
                          if (result.done) {
                            await SendUser().deleteDeviceToken();
                            removePlayerPref(key: "playerProfileDetails");
                            Get.deleteAll();

                            setState(() {
                              btnLoading = false;
                            });
                            final prefManager =
                                await SharedPreferences.getInstance();
                            await prefManager.clear();
                            Restart.restartApp();
                            socket.dispose();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    MainSplashScreen(),
                              ),
                              (route) => false,
                            );
                          } else {
                            setState(() {});
                          }
                        },
                      )),
            ),

            SizedBox(
              height: 80,
            ), // Spacer(),
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

class ProfileImage extends StatelessWidget {
  ProfileImage({
    Key key,
    @required this.profileData,
  }) : super(key: key);

  var profileData;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      cacheManager: CustomCacheManager.instance,
      imageUrl: (profileData ?? const {})['profile_image'] ??
          '$baseUrl/assets/images/no_profile.png',
      imageBuilder: (context, imageProvider) => Stack(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xffFF530D),
                  Color(0xffFF960C)
                ], // Adjust colors as needed
              ),
            ),
            child: Center(
              child: Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFFF2F3F5),
                    width: 1,
                  ),
                  image: DecorationImage(
                    image: imageProvider ??
                        AssetImage("assets/dp/blank-profile-picture-png.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      errorWidget: (context, url, error) => Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: Colors.grey,
          border: Border.all(
            color: Color(0xFFF2F3F5),
            width: 1,
          ),
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(
                "assets/dp/error-placeholder.png"), // Replace with your error placeholder image
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
