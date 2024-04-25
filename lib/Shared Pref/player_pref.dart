import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void updatePlayerPref({String key, var data}) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setString(key, json.encode(data));
}

void removePlayerPref({String key}) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.remove(key);
}

Future getPlayerPref({String key}) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (pref.getString(key) == null) {
    return "";
  } else {
    return json.decode(pref.getString(key));
  }
}
