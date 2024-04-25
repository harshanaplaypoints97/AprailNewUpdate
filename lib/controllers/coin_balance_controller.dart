import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Api/Api.dart';

class CoinBalanceController extends GetxController {
  final VoidCallback callback;

  CoinBalanceController({
    this.callback,
  });

  RxDouble coinBalance = RxDouble(0);
  RxDouble previousBalance = RxDouble(0);
  //set balace
  set setCoinBalance(double balance) => coinBalance = RxDouble(balance);
  set setPreviusBalance(double balance) => previousBalance = RxDouble(balance);

  void updateCoinBalance(double balance) {
    try {
      setPreviusBalance = coinBalance.value;
      if (balance <= 0) {
        setCoinBalance = 0;
        return;
      }
      setCoinBalance = balance;

      update();
    } catch (e) {}
  }

  Future<void> getPoints() async {
    // final p = await getPlayerPref(key: 'playerPoints');

    var p = await Api().getProfiledata();

    if (p != null) {
      updateCoinBalance(double.parse(p["body"]["points"].toString()));
      update();
    } else {}
  }

  @override
  void onInit() {
    getPoints();
    update();
    super.onInit();
  }
}
