import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Api/handle_api.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/models/check_plyer_login.dart';
import 'package:play_pointz/screens/home/home_page.dart';
import 'package:play_pointz/screens/new_login/new_login_screen.dart';
import 'package:play_pointz/widgets/common/toast.dart';
import 'package:store_redirect/store_redirect.dart';
import '../../constants/page_transaction_router.dart';

class MainSplashScreen extends StatefulWidget {
  const MainSplashScreen({Key key}) : super(key: key);

  @override
  _MainSplashScreenState createState() => _MainSplashScreenState();
}

class _MainSplashScreenState extends State<MainSplashScreen> {
  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  int index = 0;

  bool isNotify = false;
  bool verifiedUser = false;
  var message;
  bool isBannedUser = false;

  String newVersion;
  bool isUpdateAvailable;
  String localVersion;

  String deviceId = '';

  Timer timer;

  @override
  void initState() {
    initPlugin();
    getConnectivity();
    getDeviceId();
    Platform.isAndroid ? getAppDetails() : checkplayerLogin();
    super.initState();
  }

  //Auto Navigate to login register page
  navigate() async {
    var duration = Duration(seconds: 0);
    return Timer(duration, route);
  }

  getConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected && !isAlertSet) {
        showDialogBox();
        setState(() {
          isAlertSet = true;
        });
      } else {
        Platform.isAndroid ? getAppDetails() : checkplayerLogin();
      }
    });
  }

  Future<void> initPlugin() async {
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      // Show a custom explainer dialog before the system dialog
      await showCustomTrackingDialog(context);
      // Wait for dialog popping animation
      await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
    }
  }

  Future<void> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dear User'),
          content: const Text(
            'We care about your privacy and data security. We keep this app free by showing ads. '
            'Can we continue to use your data to tailor ads for you?\n\nYou can change your choice anytime in the app settings. '
            'Our partners will collect data and use a unique identifier on your device to show you ads.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue'),
            ),
          ],
        ),
      );

  getAppDetails() async {
    try {
      final newVersionPlus = NewVersionPlus();
      final version = await newVersionPlus.getVersionStatus();
      if (version != null) {
        setState(() {
          newVersion = version.storeVersion;
          isUpdateAvailable = version.canUpdate;
          localVersion = version.localVersion;
        });
        int getExtendedVersionNumber(String version) {
          List versionCells = version.split('.');
          versionCells = versionCells.map((i) => int.parse(i)).toList();
          return versionCells[0] * 100000 + versionCells[1] * 100;
        }

        int _localVersion = getExtendedVersionNumber(localVersion);
        int _newVersion = getExtendedVersionNumber(newVersion);
        if (_newVersion > _localVersion) {
          if (isUpdateAvailable) {
            showAppDetailDialogBox(newVersion: newVersion);
          } else {
            checkplayerLogin();
          }
        } else {
          checkplayerLogin();
        }
      } else {
        checkplayerLogin();
      }
    } catch (e) {
      checkplayerLogin();
    }
  }

  showAppDetailDialogBox({String newVersion}) {
    return showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("New Update Available"),
            content: Center(
                child: Column(
              children: [
                Text('Version ' + newVersion + ' is available in Play Store.'),
              ],
            )),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  StoreRedirect.redirect(
                      androidAppId: "com.avanux.playpointz",
                      iOSAppId: "1660002125");
                },
                child: Text("Update"),
              )
            ],
          );
        });
  }

  showDialogBox() {
    return showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("No Connection"),
            content: Center(
                child: Text("Please Check Your Internet \n Connectivity")),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.pop(context, "cancel");
                  setState(() {
                    isAlertSet = false;
                  });
                  isDeviceConnected =
                      await InternetConnectionChecker().hasConnection;
                  if (!isDeviceConnected) {
                    showDialogBox();
                    setState(() {
                      isAlertSet = true;
                    });
                  } else {
                    // checkplayerLogin();
                    Platform.isAndroid ? getAppDetails() : checkplayerLogin();
                  }
                },
                child: Text("OK"),
              )
            ],
          );
        });
  }

  getDeviceId() async {
    try {
      String devId = await PlatformDeviceId.getDeviceId;
      setState(() {
        deviceId = devId;
      });

      Platform.isAndroid ? getAppDetails() : checkplayerLogin();
    } catch (e) {
      Platform.isAndroid ? getAppDetails() : checkplayerLogin();
    }
  }

  Future<void> checkplayerLogin() async {
    // FlutterDisplayMode.setHighRefreshRate();
    //
    CheckPlayerLogin result = await Api()
        .playerLoginCheck(version: localVersion, deviceId: deviceId, fcm: null);
    // Api().testMe('CheckPlayerLogin');
    if (result.done != null) {
      if (result.done) {
        setState(() {
          verifiedUser = result.body.isVerified;
          getPlayerProfData();
          // getplayers();
          route();
        });
      } else {
        debugPrint(
            "--------------------------------- player checking result is false");
        route();
      }
    } else {
      messageToastRed(result.message);
      debugPrint(
          "---------------------------------------- player checking result is null");
    }
  }

  getPlayerProfData() async {
    await HandleApi().getPlayerProfileDetails();
  }

  getplayers() async {
    await HandleApi().getPlayerSearch(context);
  }

  route() async {
    verifiedUser
        ? Navigator.pushReplacement(
            context,
            FadeTransitionRouter(
                child: HomePage(
              activeIndex: 0,
            )))
        : Navigator.pushReplacement(
            context, FadeTransitionRouter(child: NewLoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
        color: Colors.white,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(60),
              child: Image.asset(
                "assets/new/logo.png",
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              bottom: size.height * 0.1,
              child: SizedBox(
                width: size.width * 0.3,
                child: Image.asset(
                  "assets/logos/from-avanux-gray.png",
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  height: 25,
                  width: size.width,
                  color: Colors.white,
                  child: Row(
                    children: [
                      Text(
                        "PlayPointz",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16.sp,
                            fontFamily: "Inter"),
                      ),
                      Spacer(),
                      Text(
                        'Version ' + '1.16.0',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16.sp,
                            fontFamily: "Inter"),
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
