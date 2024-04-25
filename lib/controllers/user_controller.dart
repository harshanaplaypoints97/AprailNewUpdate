import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Shared%20Pref/player_pref.dart';
import 'package:play_pointz/models/login.dart';

class UserController extends GetxController {
  Rx<User> currentUser = Rx<User>(null);
  String newLogo = 'assets/new/logo.png';

  List<String> search = [];
  // Rx<User> currentUser =User().obs;

  //set current user
  Future<void> setCurrentUser() async {
    try {
      Map login = await Api().getProfiledata();
      //  debugPrint("login is $login");
      if (login.isNotEmpty) {
        User u = User.fromMap(login["body"]);
        currentUser = Rx(u);
        // debugPrint(
        //     "----------- current user set succesfully, user name is ${currentUser.value.fullName}");
        update();
      }
    } catch (e) {
      debugPrint("------------- getx set current user failed $e");
    }
  }

  //set current user
  Future<void> setLogo() async {
    try {
      Map logo = await Api().getNewLogo();
      //  debugPrint("logo is $logo");
      if (logo.isNotEmpty && logo != null) {
        // User u = User.fromMap(logo["body"]);
        if (logo["body"]["logo_url"] != null &&
            logo["body"]["logo_url"] != "") {
          newLogo = logo["body"]["logo_url"];
        } else {
          newLogo = 'assets/new/logo.png';
        }

        debugPrint("logo----$newLogo");
        // debugPrint(
        //     "----------- current user set succesfully, user name is ${currentUser.value.fullName}");
        // update();
      } else {
        newLogo = 'assets/new/logo.png';
      }
    } catch (e) {
      debugPrint("------------- getx set current user failed $e");
    }
  }

  Future<void> getSearchSuggest() async {
    var search1 = await getPlayerPref(key: 'search');
    var search2 = search1 != null && search1 != "" ? search1["search"] : [];

    search.clear();

    for (int i = 0; i < search2.length; i++) {
      search.add(search2[i]);
    }
  }

  @override
  void onInit() {
    setCurrentUser();
    setLogo();
    getSearchSuggest();
    super.onInit();
  }
}
