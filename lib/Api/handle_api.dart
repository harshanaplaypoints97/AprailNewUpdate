import 'package:flutter/material.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Shared%20Pref/player_pref.dart';
import 'package:play_pointz/models/get_notifi_settings.dart';
import 'package:play_pointz/models/get_players.dart';
import 'package:play_pointz/widgets/common/toast.dart';

class HandleApi {
  getPlayerProfileDetails() async {
    Map result = await Api().getProfiledata();
    if (result["done"] != null) {
      if (result["done"]) {
        updatePlayerPref(key: "playerProfileDetails", data: result["body"]);
      } else {
        messageToastGreen(result["message"]);
      }
    }
  }

  getPlayerSearch(BuildContext context) async {
    GetPlayers result = await Api().getPlayers(context);
    if (result.done != null) {
      if (result.done) {
        updatePlayerPref(key: "playerDetails", data: result.body.players);
      } else {
        messageToastGreen(result.message);
      }
    }
  }

  getNotifiSettings() async {
    GetNotifiSettings results = await Api().getNotifiSettings();
    if (results.done != null) {
      if (results.done) {
        updatePlayerPref(key: "notificationDetails", data: results.body);
      } else {
        messageToastRed(results.message);
      }
    }
  }
}
