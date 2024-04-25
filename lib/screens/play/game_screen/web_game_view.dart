// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Shared%20Pref/player_pref.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/controllers/coin_balance_controller.dart';
import 'package:play_pointz/models/play/game_earned_points.dart';
import 'package:play_pointz/models/play/play_section_data.dart';
import 'package:play_pointz/screens/home/home_page.dart';

class WebGameView extends StatefulWidget {
  final CoinBalanceController coinBalanceController;
  final PlaySectionDataBody gameData;
  final WebViewController webviewcontroller;
  final VoidCallback callBack;
  final String gameUrl;
  const WebGameView({
    this.coinBalanceController,
    this.webviewcontroller,
    this.gameUrl,
    this.callBack,
    this.gameData,
  }) : super();

  @override
  State<WebGameView> createState() => _WebGameViewState();
}

class _WebGameViewState extends State<WebGameView> {
  CoinBalanceController coinsController;
  String player_id = '';
  String previousVersion = "";
  final gameController = WebViewController();

  void getGamePreviousVersion() async {
    previousVersion =
        await getPlayerPref(key: "${widget.gameData.name}+previousVersion");
    if (widget.gameData.version != previousVersion ||
        previousVersion == null ||
        previousVersion.isEmpty) {
      await gameController.clearLocalStorage();
      updatePlayerPref(
          key: "${widget.gameData.name}+previousVersion",
          data: widget.gameData.version);
      gameController
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(NavigationDelegate(
          onWebResourceError: (error) {},
        ))
        ..loadRequest(Uri.parse(widget.gameUrl));
      gameController.setBackgroundColor(Colors.black);
    } else {
      gameController
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(NavigationDelegate(
          onWebResourceError: (error) {},
        ))
        ..loadRequest(Uri.parse(widget.gameUrl));
      gameController.setBackgroundColor(Colors.black);
    }
  }

  @override
  void initState() {
    getGamePreviousVersion();

    setState(() {
      if (widget.coinBalanceController == null) {
        coinsController = Get.put(
          CoinBalanceController(
            callback: () => widget.callBack,
          ),
        );
      } else {
        coinsController = widget.coinBalanceController;
      }
    });
    super.initState();
  }

  getPlayerDetails() async {
    player_id = await getPlayerPref(key: "playerProfileDetails");
  }

  void _earnedPointzDialog(BuildContext context, int points, String message) {
    switch (widget.gameData.name) {
      case "Cat 3 Match":
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {},
                          child: Image.asset(
                            "assets/popups/game_popups/cat_3_match/EarnedPointz.png",
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: MediaQuery.of(context).size.width * 0.35,
                          bottom: MediaQuery.of(context).size.width * 0.3,
                          child: Text(
                            points.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              decoration:
                                  TextDecoration.none, // Remove underline
                              fontSize: 46.0, // Adjust size
                              fontWeight: FontWeight.w900, // Adjust weight
                            ),
                          ),
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.28,
                          right: MediaQuery.of(context).size.width * 0.28,
                          // top: MediaQuery.of(context).size.width * 0.7,
                          bottom: MediaQuery.of(context).size.width * 0.15,
                          child: SizedBox(
                            height: 79,
                            width: 212,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                try {
                                  coinsController.updateCoinBalance(
                                    (coinsController.coinBalance.value +
                                            points) /
                                        1.0,
                                  );
                                } catch (e) {}
                                try {
                                  coinsController.onInit();
                                } catch (e) {}
                                setState(() {});
                                //point update
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(
                                      activeIndex: 1,
                                      fromRegisterPage: false,
                                    ),
                                  ),
                                );
                              },
                              child: Image.asset(
                                "assets/popups/game_popups/cat_3_match/close.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
        break;
      case "Speed Over Water":
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {},
                          child: Image.asset(
                            "assets/popups/game_popups/speed-over-water/D.png",
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: MediaQuery.of(context).size.width * 0.6,
                          bottom: MediaQuery.of(context).size.width * 0.3,
                          child: Text(
                            points.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              decoration:
                                  TextDecoration.none, // Remove underline
                              fontSize: 46.0, // Adjust size
                              fontWeight: FontWeight.w900, // Adjust weight
                            ),
                          ),
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.25,
                          right: MediaQuery.of(context).size.width * 0.25,
                          top: MediaQuery.of(context).size.width * 0.8,
                          bottom: MediaQuery.of(context).size.width * 0.1,
                          child: SizedBox(
                            height: 79,
                            width: 212,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                try {
                                  coinsController.updateCoinBalance(
                                    (coinsController.coinBalance.value +
                                            points) /
                                        1.0,
                                  );
                                } catch (e) {}
                                try {
                                  coinsController.onInit();
                                } catch (e) {}
                                setState(() {});
                                //point update
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(
                                      activeIndex: 1,
                                      fromRegisterPage: false,
                                    ),
                                  ),
                                );
                              },
                              child: Image.asset(
                                "assets/popups/game_popups/speed-over-water/04.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
        break;
      case "Super Sugar Hallucination":
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {},
                          child: Image.asset(
                            "assets/popups/game_popups/game1/earnedPointz.png",
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: MediaQuery.of(context).size.width * 0.5,
                          bottom: MediaQuery.of(context).size.width * 0.3,
                          child: Text(
                            points.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              decoration:
                                  TextDecoration.none, // Remove underline
                              fontSize: 46.0, // Adjust size
                              fontWeight: FontWeight.w900, // Adjust weight
                            ),
                          ),
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.3,
                          right: MediaQuery.of(context).size.width * 0.3,
                          top: MediaQuery.of(context).size.width * 0.7,
                          bottom: MediaQuery.of(context).size.width * 0.18,
                          child: SizedBox(
                            height: 79,
                            width: 212,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                try {
                                  coinsController.updateCoinBalance(
                                    (coinsController.coinBalance.value +
                                            points) /
                                        1.0,
                                  );
                                } catch (e) {}
                                try {
                                  coinsController.onInit();
                                } catch (e) {}
                                setState(() {});
                                //point update
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(
                                      activeIndex: 1,
                                      fromRegisterPage: false,
                                    ),
                                  ),
                                );
                              },
                              child: Image.asset(
                                "assets/popups/game_popups/game1/closebutton.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
        break;
      case "Space Hero":
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {},
                          child: Image.asset(
                            "assets/popups/game_popups/space-hero/B.png",
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: MediaQuery.of(context).size.width * 0.25,
                          child: Text(
                            points.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              decoration:
                                  TextDecoration.none, // Remove underline
                              fontSize: 40.0, // Adjust size
                              fontWeight: FontWeight.w900, // Adjust weight
                            ),
                          ),
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.25,
                          right: MediaQuery.of(context).size.width * 0.25,
                          //top: MediaQuery.of(context).size.width * 0.5,
                          bottom: MediaQuery.of(context).size.width * 0.1,
                          child: SizedBox(
                            /*  height: 73,
                            width: 260, */
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                try {
                                  coinsController.updateCoinBalance(
                                    (coinsController.coinBalance.value +
                                            points) /
                                        1.0,
                                  );
                                } catch (e) {}
                                try {
                                  coinsController.onInit();
                                } catch (e) {}
                                setState(() {});
                                //point update
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(
                                      activeIndex: 1,
                                      fromRegisterPage: false,
                                    ),
                                  ),
                                );
                              },
                              child: Image.asset(
                                "assets/popups/game_popups/space-hero/02.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
        break;
      default:
    }
  }

  void closeWebView(int points) {
    _earnedPointzDialog(context, points, "");
  }

  Future<int> getEarnedPoints() async {
    GameEarnedPoints response =
        await Api().getEarnedGamepoints(widget.gameData.type);
    if (response != null) {
      return response.body.points;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Do you want to exit from this Game ? "),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("No"),
                      ),
                      TextButton(
                        onPressed: () {
                          socket.disconnect();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        activeIndex: 1,
                                      )),
                              (Route<dynamic> route) => false);
                        },
                        child: Text("Yes"),
                      ),
                    ],
                  ));
        },
        child: Stack(
          children: [
            WebViewWidget(controller: gameController),
            Positioned(
              right: 12,
              top: 36,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: IconButton(
                    onPressed: () async {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return Center(child: CircularProgressIndicator());
                        },
                      );
                      int earnedpoints = await getEarnedPoints();
                      if (earnedpoints != null) {
                        Navigator.pop(context);
                        closeWebView(earnedpoints);
                      }
                    },
                    icon: Icon(Icons.close)),
              ),
            ),
          ],
        ),
      ),
    );
    // return Scaffold();
  }
}
