import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:play_pointz/Shared%20Pref/player_pref.dart';
import 'package:play_pointz/screens/home/splash_screen.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

//live server
const baseUrl = "https://playpointz.com";

const newbaseUrl = "https://game-uat.playpointz.com";

const my_new_baseUrl = "";

// //test server
// const baseUrl = "https://game-uat.playpointz.com";

/* const baseUrl =
    "https://5051-2402-d000-8100-13d5-f96f-90aa-faf6-2206.ngrok-free.app"; */

const bool testAdsOn = false;

//google ad unit id
const String googleBannerAdUnitIdAndroid = testAdsOn
    ? "ca-app-pub-3940256099942544/6300978111"
    : "ca-app-pub-6117502516046959/5053948375";
const String googleBannerAdUnitIdIos = testAdsOn
    ? "ca-app-pub-3940256099942544/2934735716"
    : "ca-app-pub-6117502516046959/2420842339";

const String admobAppIdInterstitialAndroid = testAdsOn
    ? "ca-app-pub-3940256099942544/1033173712"
    : "ca-app-pub-6117502516046959/2219498520";
const String admobAppIdInterstitialIOS = testAdsOn
    ? "ca-app-pub-3940256099942544/4411468910"
    : "ca-app-pub-6117502516046959/7461298481";

//local ad unit ids
const String oneByOneAdUnitId = "/22963169719/002";
const String wideBannerAdUnitId = "/22963169719/001";

const thisVersion = '1.14.1';

//local
/* IO.Socket socket = IO.io(
    'https://5051-2402-d000-8100-13d5-f96f-90aa-faf6-2206.ngrok-free.app',
    OptionBuilder() /* .setAuth({
      'offset': null, // set your authentication token here
    }) */
        .enableAutoConnect()
        .setTransports(['websocket', 'polling']).build());
 */
//test
/* IO.Socket socket = IO.io(
    'wss://game-uat.playpointz.com',
    OptionBuilder()
        .enableAutoConnect()
        .setTransports(['websocket', 'polling']).build()); */

//live
IO.Socket socket = IO.io(
    'wss://playpointz.com',
    OptionBuilder()
        .enableAutoConnect()
        .setTransports(['websocket', 'polling']).build());

class ForceLogOutClass {
  final BuildContext context;
  ForceLogOutClass(this.context);
  void forceLogOut() async {
    //await SendUser().deleteDeviceToken();
    // removePlayerPref(key: "PlayerToken");
    removePlayerPref(key: "playerProfileDetails");
    Get.deleteAll();

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
}
