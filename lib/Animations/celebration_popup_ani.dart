import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:lottie/lottie.dart';
import 'package:play_pointz/controllers/coin_balance_controller.dart';
import 'package:play_pointz/screens/home/home_page.dart';
import 'package:play_pointz/screens/orders/my_orders.dart';

class CelebrationPopupAni {
  void DailyRewardPopUp(BuildContext context, bool plus, int points,
      final Callback callback, CoinBalanceController coinController) {
    showDialog(
        barrierDismissible: false,
        barrierColor: Colors.black.withAlpha(200),
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                    child: TweenAnimationBuilder(
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 600),
                  tween: Tween<double>(
                      begin: 1, end: MediaQuery.of(context).size.width),
                  builder: (BuildContext context, dynamic value, Widget child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image(
                          width: value,
                          image: AssetImage("assets/popups/con1.png"),
                          fit: BoxFit.fitWidth,
                        ),
                        Center(
                          child: Text(
                            "+" " " "$points",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        value >= MediaQuery.of(context).size.width
                            ? TweenAnimationBuilder(
                                tween: Tween<double>(
                                    begin: 1,
                                    end: MediaQuery.of(context).size.width *
                                        0.095),
                                duration: const Duration(milliseconds: 400),
                                builder: (BuildContext context, dynamic value,
                                    Widget child) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                      ),
                                      SizedBox(
                                        height: value,
                                        width: value * 2.5,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                    side: BorderSide(
                                                        color: Colors
                                                            .orange[600])))),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Get.off(() => HomePage(
                                                    activeIndex: 0,
                                                  ));
                                              coinController.updateCoinBalance(
                                                (coinController
                                                            .coinBalance.value +
                                                        points) /
                                                    1.0,
                                              );
                                              coinController.onInit();
                                              callback();
                                            },
                                            child: TweenAnimationBuilder(
                                                tween: Tween<double>(
                                                    begin: 0,
                                                    end: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.045),
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                builder: (BuildContext context,
                                                    dynamic value,
                                                    Widget child) {
                                                  return Text(
                                                    "Claim",
                                                    style: TextStyle(
                                                        fontSize: value,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  );
                                                })),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                      ),
                                    ],
                                  );
                                })
                            : SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.1),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        )
                        // ElevatedButton(onPressed: () {}, child: const Text("next"))
                      ],
                    );
                  },
                )),
              ],
            ),
          );
        });
  }

  void DailyRewardLostPopUp(BuildContext context, bool plus, int points,
      final Callback callback, CoinBalanceController coinController) {
    showDialog(
        barrierDismissible: false,
        barrierColor: Colors.black.withAlpha(200),
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                    child: TweenAnimationBuilder(
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 1200),
                  tween: Tween<double>(
                      begin: 1, end: MediaQuery.of(context).size.width),
                  builder: (BuildContext context, dynamic value, Widget child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image(
                          width: value,
                          image: AssetImage("assets/popups/oops.png"),
                          fit: BoxFit.fitWidth,
                        ),
                        Center(
                          child: Text(
                            " " "$points",
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        value >= MediaQuery.of(context).size.width
                            ? TweenAnimationBuilder(
                                tween: Tween<double>(
                                    begin: 1,
                                    end: MediaQuery.of(context).size.width *
                                        0.095),
                                duration: const Duration(milliseconds: 400),
                                builder: (BuildContext context, dynamic value,
                                    Widget child) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                      ),
                                      SizedBox(
                                        height: value,
                                        width: value * 2.5,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                    side: BorderSide(
                                                        color: Colors
                                                            .orange[600])))),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Get.off(() => HomePage(
                                                    activeIndex: 0,
                                                  ));
                                              coinController.updateCoinBalance(
                                                (coinController
                                                            .coinBalance.value +
                                                        points) /
                                                    1.0,
                                              );
                                              coinController.onInit();
                                              callback();
                                            },
                                            child: TweenAnimationBuilder(
                                                tween: Tween<double>(
                                                    begin: 0,
                                                    end: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.045),
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                builder: (BuildContext context,
                                                    dynamic value,
                                                    Widget child) {
                                                  return Text(
                                                    "Got it",
                                                    style: TextStyle(
                                                        fontSize: value,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  );
                                                })),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                      ),
                                    ],
                                  );
                                })
                            : SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.1),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        )
                      ],
                    );
                  },
                )),
              ],
            ),
          );
        });
  }

  void WonItemPopUp(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        barrierColor: Colors.black.withAlpha(200),
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                    child: TweenAnimationBuilder(
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 600),
                  tween: Tween<double>(
                      begin: 1, end: MediaQuery.of(context).size.width * 8),
                  builder: (BuildContext context, dynamic value, Widget child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image(
                          width: value,
                          image: AssetImage("assets/popups/wonItem1.png"),
                          fit: BoxFit.fitWidth,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        value >= MediaQuery.of(context).size.width
                            ? TweenAnimationBuilder(
                                tween: Tween<double>(
                                    begin: 1,
                                    end: MediaQuery.of(context).size.width *
                                        0.1),
                                duration: const Duration(milliseconds: 400),
                                builder: (BuildContext context, dynamic value,
                                    Widget child) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                      ),
                                      SizedBox(
                                        height: value,
                                        width: value * 2.5,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                    side: BorderSide(
                                                        color: Colors
                                                            .orange[600])))),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: TweenAnimationBuilder(
                                                tween: Tween<double>(
                                                    begin: 0,
                                                    end: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.045),
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                builder: (BuildContext context,
                                                    dynamic value,
                                                    Widget child) {
                                                  return Text(
                                                    "Got it",
                                                    style: TextStyle(
                                                        fontSize: value,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  );
                                                })),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                      ),
                                    ],
                                  );
                                })
                            : SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.1),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        SizedBox(
                          width: 250,
                          child: Text(
                            'Your item will be Received within 1 - 14 days!',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              decoration: TextDecoration.none,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  },
                )),
              ],
            ),
          );
        }).then((value) => Get.off(() => MyOrders(fromProfile: false)));
  }

  void FirstLogin(BuildContext context, String points) {
    showDialog(
        barrierDismissible: false,
        barrierColor: Colors.black.withAlpha(200),
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                    child: TweenAnimationBuilder(
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 600),
                  tween: Tween<double>(
                      begin: 1, end: MediaQuery.of(context).size.width),
                  builder: (BuildContext context, dynamic value, Widget child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image(
                          width: value,
                          image: AssetImage("assets/logos/first_login_new.png"),
                          fit: BoxFit.fitWidth,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            "+" " " "${points.toString()}",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        value >= MediaQuery.of(context).size.width
                            ? TweenAnimationBuilder(
                                tween: Tween<double>(
                                    begin: 1,
                                    end: MediaQuery.of(context).size.width *
                                        0.1),
                                duration: const Duration(milliseconds: 400),
                                builder: (BuildContext context, dynamic value,
                                    Widget child) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                      ),
                                      SizedBox(
                                        height: value,
                                        width: value * 2.5,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                    side: BorderSide(
                                                        color: Colors
                                                            .orange[600])))),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Get.off(() => HomePage(
                                                    activeIndex: 0,
                                                  ));
                                            },
                                            child: TweenAnimationBuilder(
                                                tween: Tween<double>(
                                                    begin: 0,
                                                    end: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.045),
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                builder: (BuildContext context,
                                                    dynamic value,
                                                    Widget child) {
                                                  return Text(
                                                    "Claim",
                                                    style: TextStyle(
                                                        fontSize: value,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  );
                                                })),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                      ),
                                    ],
                                  );
                                })
                            : SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.1),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        )
                      ],
                    );
                  },
                )),
              ],
            ),
          );
        });
  }

  void CollectCoinAni(BuildContext context) {
    showDialog(
        barrierColor: Colors.black.withAlpha(1),
        context: context,
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Lottie.asset(
                      "assets/lottie/coinThrow.json",
                      fit: BoxFit.fitHeight,
                      repeat: false,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  void customDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: AlertDialog(
            title: const Text("Dialog title"),
            content: const Text("Simple Dialog content"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Okay"))
            ],
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
