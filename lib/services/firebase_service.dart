import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:play_pointz/Api/handle_api.dart';
import 'package:play_pointz/Shared%20Pref/player_pref.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:get/get.dart';

class SendUser {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  UserController userController = Get.put(UserController());

  String playerCollection =
      baseUrl == "https://playpointz.com" ? 'players' : 'uat_players';
  String tokenCollection =
      baseUrl == "https://playpointz.com" ? 'tokens' : 'uat_tokens';

  saveDeviceToken(uid) async {
    await HandleApi().getPlayerProfileDetails();
    var profileData = await getPlayerPref(key: "playerProfileDetails");

    String userId = profileData["id"];
    String fcmToken = await _fcm.getToken();
    // Save it to Firestore
    if (userId != "") {
      if (fcmToken != null) {
        /*  var tokens = _db
            .collection(playerCollection)
            .doc(userId)
            .collection(tokenCollection)
            .doc(fcmToken); */

        /*   await tokens.set({
          'token': fcmToken,
          'createdAt': FieldValue.serverTimestamp(), // optional
          'platform': Platform.operatingSystem // optional
        }); */
        updatePlayerPref(key: "token", data: {"token": fcmToken});
      }
    } else {
      saveDeviceToken('id');
    }
  }

  deleteDeviceToken() async {
    var profileData = await getPlayerPref(key: "playerProfileDetails");
    var token = await getPlayerPref(key: "token");

    String _fcmToken = await _fcm.getToken();

    String userId = profileData["id"];
    String fcmToken = token["token"];
    if (fcmToken != null) {
      /*  await _db
          .collection(playerCollection)
          .doc(userId)
          .collection(tokenCollection)
          .doc(fcmToken)
          .delete(); */
      removePlayerPref(key: "token");
    } else if (_fcmToken != null) {
      /* await _db
          .collection(playerCollection)
          .doc(userId)
          .collection(tokenCollection)
          .doc(_fcmToken)
          .delete(); */
      removePlayerPref(key: "token");
    } else {
      return null;
    }
  }
}
