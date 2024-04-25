import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/controllers/coin_balance_controller.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/models/play/game_token.dart';
import 'package:play_pointz/models/play/play_section_data.dart';
import 'package:play_pointz/screens/feed/feed_page.dart';
import 'package:play_pointz/screens/google_ads/inline_adaptive_banner_ads.dart';
import 'package:play_pointz/screens/google_ads/store_banner_ad.dart';
import 'package:play_pointz/screens/play/Awurudu/Tree_Climb.dart';
import 'package:play_pointz/screens/play/My%20Class%20Room/Main_Class_Room.dart';
import 'package:play_pointz/screens/play/WebView/Spinner_Game.dart';
import 'package:play_pointz/screens/play/game_screen/web_game_view.dart';
import 'package:play_pointz/screens/play/quiz_games.dart';
import 'package:play_pointz/screens/shimmers/shimmer_widget.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../store/main Store/Play Mart/Controller/PlayMartController.dart';
import '../../../store/main Store/Play Mart/model/PlayMartModel.dart';
import '../../../store/main Store/Play Mart/provider/PlayMartProvider.dart';

class Awurudugames extends StatefulWidget {
  final VoidCallback cointBalanceUpdater;
  const Awurudugames({Key key, this.cointBalanceUpdater}) : super(key: key);

  @override
  State<Awurudugames> createState() => _AwurudugamesState();
}

class _AwurudugamesState extends State<Awurudugames> {
  // ScrollController scrollcontrller = ScrollController();
////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///

  /////////////////////////////////////////////////////////////////////////////////////
  bool buttonLoading = false;
  bool adLoaded = false;
  bool adFailedToLoad = false;
  CoinBalanceController coinBalanceController;
  final userController = Get.put(UserController());
  PlaySectionData _playSectionData;
  String current = '';

  InterstitialAd _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  static const int maxFailedLoadAttempts = 3;
  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  @override
  void initState() {
    _createInterstitialAd();
    coinBalanceController = Get.put(CoinBalanceController(callback: () {
      debugPrint(
          "+++++++++++++++++++++++++ controller from paly widget called");
      setState(() {});
    }));
    getPlaySectionData();
    super.initState();
  }

  void returnCallBack() {
    setState(() {
      coinBalanceController.onInit();
    });
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? admobAppIdInterstitialAndroid
            : admobAppIdInterstitialIOS,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            setState(() {
              adLoaded = true;
              adFailedToLoad = false;
            });
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            } else {
              setState(() {
                adLoaded = false;
                adFailedToLoad = true;
              });
            }
          },
        ));
  }

  void _showInterstitialAd(
      {BuildContext context, PlaySectionData snapshot, int index}) {
    if (_interstitialAd == null) {
      setState(() {
        buttonLoading = false;
        snapshot.body[index].loading = false;
      });
      return;
    }
    ShowLoadingPopUp(context);
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        InterstitialAdResponse(
            context: context, snapshot: snapshot, index: index);
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        InterstitialAdResponse(
            context: context, snapshot: snapshot, index: index);
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd.show();
    _interstitialAd = null;
  }

  void ShowLoadingPopUp(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void pointDeductionPopup(BuildContext context, int points, String gameName,
      PlaySectionData snapshot, int index, String gameToken) {
    switch (gameName) {
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
                        Image.asset(
                          "assets/popups/game_popups/speed-over-water/ready.png",
                          fit: BoxFit.scaleDown,
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: MediaQuery.of(context).size.width * 0.15,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) => WebGameView(
                                            gameData: snapshot.body[index],
                                            callBack: () => {setState(() {})},
                                            coinBalanceController:
                                                coinBalanceController,
                                            gameUrl:
                                                "${snapshot.body[index].gameUrl}?game_token=$gameToken&base_url=$baseUrl&score_divide_by=${snapshot.body[index].scoreEqualsTo}",
                                            //  webviewcontroller: firstGameController,
                                          )),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: Image.asset(
                                    "assets/popups/game_popups/speed-over-water/yes.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: Image.asset(
                                    "assets/popups/game_popups/speed-over-water/No.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
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
                        Image.asset(
                          "assets/popups/game_popups/space-hero/EnterPointDeductionPopup.png",
                          fit: BoxFit.scaleDown,
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: MediaQuery.of(context).size.width * 0.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) => WebGameView(
                                            gameData: snapshot.body[index],
                                            callBack: () => {setState(() {})},
                                            coinBalanceController:
                                                coinBalanceController,
                                            gameUrl:
                                                "${snapshot.body[index].gameUrl}?game_token=$gameToken&base_url=$baseUrl&score_divide_by=${snapshot.body[index].scoreEqualsTo}",
                                          )),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: Image.asset(
                                    "assets/popups/game_popups/space-hero/yes.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: Image.asset(
                                    "assets/popups/game_popups/space-hero/No.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
    }
  }

  void _notEnoughPointzDialog(
      BuildContext context, int points, String gameName) {
    switch (gameName) {
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
                        Image.asset(
                          "assets/popups/game_popups/cat_3_match/notEnough.png",
                          fit: BoxFit.scaleDown,
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.28,
                          right: MediaQuery.of(context).size.width * 0.28,
                          //top: MediaQuery.of(context).size.width * 0.7,
                          bottom: MediaQuery.of(context).size.width * 0.2,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () async {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: SizedBox(
                              child: Image.asset(
                                "assets/popups/game_popups/cat_3_match/close.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
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
                        Image.asset(
                          "assets/popups/game_popups/speed-over-water/Group 1 copy.png",
                          fit: BoxFit.scaleDown,
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.25,
                          right: MediaQuery.of(context).size.width * 0.25,
                          //top: MediaQuery.of(context).size.width * 0.7,
                          bottom: MediaQuery.of(context).size.width * 0.1,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () async {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: SizedBox(
                              child: Image.asset(
                                "assets/popups/game_popups/speed-over-water/04.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
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
                        Image.asset(
                          "assets/popups/game_popups/game1/notEnoughpointz.png",
                          fit: BoxFit.scaleDown,
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.3,
                          right: MediaQuery.of(context).size.width * 0.3,
                          top: MediaQuery.of(context).size.width * 0.7,
                          bottom: MediaQuery.of(context).size.width * 0.18,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () async {
                              Navigator.pop(context);
                            },
                            child: SizedBox(
                              child: Image.asset(
                                "assets/popups/game_popups/game1/closebutton.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
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
                        Image.asset(
                          "assets/popups/game_popups/space-hero/space copy.png",
                          fit: BoxFit.scaleDown,
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.25,
                          right: MediaQuery.of(context).size.width * 0.25,
                          //top: MediaQuery.of(context).size.width * 0.7,
                          bottom: MediaQuery.of(context).size.width * 0.1,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () async {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: SizedBox(
                              child: Image.asset(
                                "assets/popups/game_popups/space-hero/02.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
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

  void getPlaySectionData() async {
    PlaySectionData response = await Api().getNewPlaySectionData(context);
    if (response.done && response.body != null) {
      setState(() {
        _playSectionData = response;
      });
    }
  }

  void InterstitialAdResponse(
      {BuildContext context, PlaySectionData snapshot, int index}) async {
    if (snapshot.body[index].type == "quiz") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: ((context) => QuizGames())),
          (route) => false);
    } else {
      GameToken response = await Api()
          .getGameToken(snapshot.body[index].id, snapshot.body[index].type);
      if (response != null) {
        if (response.done) {
          setState(() {
            snapshot.body[index].loading = false;
            buttonLoading = false;
          });
          String token = response.body.token;
          snapshot.body[index].type == "Level"
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => WebGameView(
                          gameData: snapshot.body[index],
                          callBack: () => {setState(() {})},
                          coinBalanceController: coinBalanceController,
                          gameUrl:
                              "${snapshot.body[index].gameUrl}?game_token=$token&base_url=$baseUrl",
                        )),
                  ),
                )
              : snapshot.body[index].type == "Score"
                  ? pointDeductionPopup(context, response.body.points,
                      snapshot.body[index].name, snapshot, index, token)
                  : () {};
        } else {
          setState(() {
            buttonLoading = false;
            snapshot.body[index].loading = false;
          });
          _notEnoughPointzDialog(context, 0, snapshot.body[index].name);
        }
      }
    }
  }

  Widget gameQuizButton(
      BuildContext context, PlaySectionData snapshot, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
          onTap: () async {
            if (adFailedToLoad) {
              ShowLoadingPopUp(context);
              InterstitialAdResponse(
                  context: context, snapshot: snapshot, index: index);
            } else {
              _showInterstitialAd(
                  context: context, snapshot: snapshot, index: index);
            }
            setState(() {
              !snapshot.body[index].loading
                  ? snapshot.body[index].loading = true
                  : null;
            });
          },
          child: Opacity(
            opacity: adLoaded || adFailedToLoad ? 1.0 : 0.5,
            child: Image(
                image: AssetImage(snapshot.body[index].name ==
                        "Super Sugar Hallucination"
                    ? "assets/new_play_section/game_01_super_sugar.png"
                    : snapshot.body[index].name == "Space Hero"
                        ? "assets/new_play_section/space_hero.png"
                        : snapshot.body[index].type == "quiz"
                            ? "assets/new_play_section/quizGames.png"
                            : snapshot.body[index].name == "Speed Over Water"
                                ? "assets/new_play_section/speed_over_water.png"
                                : snapshot.body[index].name == "Cat 3 Match"
                                    ? "assets/new_play_section/cat3match.png"
                                    : ""),
                fit: BoxFit.fill),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: userController.currentUser.value != null
            ? !userController.currentUser.value.is_brand_acc
                ? _playSectionData != null
                    ? _playSectionData.done
                        ? Stack(
                            children: [
                              Column(
                                children: [
                                  // InkWell(
                                  //   onTap: () {
                                  //     Navigator.push(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //           builder: (context) =>
                                  //               MainClassRoom(),
                                  //         ));
                                  //   },
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.all(8.0),
                                  //     child: Container(
                                  //       decoration: BoxDecoration(
                                  //         borderRadius:
                                  //             BorderRadius.circular(10),
                                  //         color: Colors.white,
                                  //       ),
                                  //       child: Center(
                                  //         child: Row(
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.center,
                                  //           children: [
                                  //             Icon(
                                  //               Icons.auto_stories_rounded,
                                  //               size: 50,
                                  //               color: Colors.black,
                                  //             ),
                                  //             SizedBox(
                                  //               width: 20,
                                  //             ),
                                  //             Text(
                                  //               "My Class Room",
                                  //               style: TextStyle(
                                  //                   fontSize: 35,
                                  //                   color: Colors.white,
                                  //                   fontWeight:
                                  //                       FontWeight.w700),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //       height: 110,
                                  //       width: double.infinity,
                                  //     ),
                                  //   ),
                                  // ),

                                  Consumer<PlayMartProvider>(
                                    builder: (context, value, child) {
                                      return StreamBuilder<QuerySnapshot>(
                                        stream: PlayMartController()
                                            .getItems("123"),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Container(); // Show a loading indicator
                                          }

                                          if (snapshot.hasError) {
                                            print('Error: ${snapshot.error}');
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          }

                                          // if (!snapshot.hasData ||
                                          //     snapshot.data.docs.isEmpty) {
                                          //   return PrivacyMessage(); // Show a message when no data is available
                                          // }

                                          // Process data from the snapshot
                                          List<PlayMartModel> _list = snapshot
                                              .data.docs
                                              .map((doc) =>
                                                  PlayMartModel.fromJson(doc
                                                          .data()
                                                      as Map<String, dynamic>))
                                              .toList();

                                          // Now you can use ListView.builder to display the list of items
                                          return Expanded(
                                            flex: 6,
                                            child: ListView.builder(
                                              itemCount: 1,
                                              shrinkWrap: false,
                                              // controller: scrollcontrller,
                                              itemBuilder: (context, index) =>
                                                  index == 1
                                                      ? Container(
                                                          height: 120,
                                                          color: Colors.red,
                                                        )
                                                      : Column(
                                                          children: [
                                                            /////////////////////////////////////////////////////////////////Lisna Gha/////////////////////////////////////////////////////////
                                                            _list[0].ItemNameList[
                                                                        4] ==
                                                                    ""
                                                                ? Container()
                                                                : InkWell(
                                                                    onTap: () {
                                                                      WebViewController
                                                                          controller =
                                                                          WebViewController()
                                                                            ..setJavaScriptMode(JavaScriptMode.unrestricted)
                                                                            ..setBackgroundColor(const Color(0x00000000))
                                                                            ..setNavigationDelegate(
                                                                              NavigationDelegate(
                                                                                onProgress: (int progress) {
                                                                                  // Update loading bar.
                                                                                },
                                                                                onPageStarted: (String url) {},
                                                                                onPageFinished: (String url) {},
                                                                                onWebResourceError: (WebResourceError error) {},
                                                                                onNavigationRequest: (NavigationRequest request) {
                                                                                  if (request.url.startsWith(_list[0].ItemNameList[4])) {
                                                                                    return NavigationDecision.prevent;
                                                                                  }
                                                                                  return NavigationDecision.navigate;
                                                                                },
                                                                              ),
                                                                            )
                                                                            ..loadRequest(Uri.parse(_list[0].ItemNameList[4]));
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                TreeClimb(
                                                                              Backgroundimage: _list[0].ItemNameList[8],
                                                                              controller: controller,
                                                                            ),
                                                                          ));
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          child:
                                                                              CachedNetworkImage(
                                                                            imageUrl:
                                                                                _list[0].ItemNameList[7], // Replace with your image URL
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            placeholder: (context, url) =>
                                                                                Center(child: CircularProgressIndicator()), // Optional placeholder widget while loading
                                                                            errorWidget: (context, url, error) =>
                                                                                Icon(Icons.error), // Optional error widget to display on image load failure
                                                                          ),
                                                                        ),
                                                                        height:
                                                                            120,
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),

                                                            //Awurudu Kumara
                                                            _list[0].ItemNameList[
                                                                        2] ==
                                                                    ""
                                                                ? Container()
                                                                : InkWell(
                                                                    onTap: () {
                                                                      WebViewController
                                                                          controller =
                                                                          WebViewController()
                                                                            ..setJavaScriptMode(JavaScriptMode.unrestricted)
                                                                            ..setBackgroundColor(const Color(0x00000000))
                                                                            ..setNavigationDelegate(
                                                                              NavigationDelegate(
                                                                                onProgress: (int progress) {
                                                                                  // Update loading bar.
                                                                                },
                                                                                onPageStarted: (String url) {},
                                                                                onPageFinished: (String url) {},
                                                                                onWebResourceError: (WebResourceError error) {},
                                                                                onNavigationRequest: (NavigationRequest request) {
                                                                                  if (request.url.startsWith(_list[0].ItemNameList[2])) {
                                                                                    return NavigationDecision.prevent;
                                                                                  }
                                                                                  return NavigationDecision.navigate;
                                                                                },
                                                                              ),
                                                                            )
                                                                            ..loadRequest(Uri.parse(_list[0].ItemNameList[2]));

                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => WebViewWidget(
                                                                                    controller: controller,
                                                                                  )));
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          child:
                                                                              CachedNetworkImage(
                                                                            imageUrl:
                                                                                _list[0].ItemNameList[5], // Replace with your image URL
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            placeholder: (context, url) =>
                                                                                Center(child: CircularProgressIndicator()), // Optional placeholder widget while loading
                                                                            errorWidget: (context, url, error) =>
                                                                                Icon(Icons.error), // Optional error widget to display on image load failure
                                                                          ),
                                                                        ),
                                                                        height:
                                                                            120,
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),

                                                            //Awurudu Kumariya

                                                            _list[0].ItemNameList[
                                                                        3] ==
                                                                    ""
                                                                ? Container()
                                                                : InkWell(
                                                                    onTap: () {
                                                                      WebViewController
                                                                          controller =
                                                                          WebViewController()
                                                                            ..setJavaScriptMode(JavaScriptMode.unrestricted)
                                                                            ..setBackgroundColor(const Color(0x00000000))
                                                                            ..setNavigationDelegate(
                                                                              NavigationDelegate(
                                                                                onProgress: (int progress) {
                                                                                  // Update loading bar.
                                                                                },
                                                                                onPageStarted: (String url) {},
                                                                                onPageFinished: (String url) {},
                                                                                onWebResourceError: (WebResourceError error) {},
                                                                                onNavigationRequest: (NavigationRequest request) {
                                                                                  if (request.url.startsWith(_list[0].ItemNameList[3])) {
                                                                                    return NavigationDecision.prevent;
                                                                                  }
                                                                                  return NavigationDecision.navigate;
                                                                                },
                                                                              ),
                                                                            )
                                                                            ..loadRequest(Uri.parse(_list[0].ItemNameList[3]));

                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => WebViewWidget(
                                                                                    controller: controller,
                                                                                  )));
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          child:
                                                                              CachedNetworkImage(
                                                                            imageUrl:
                                                                                _list[0].ItemNameList[6], // Replace with your image URL
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            placeholder: (context, url) =>
                                                                                Center(child: CircularProgressIndicator()), // Optional placeholder widget while loading
                                                                            errorWidget: (context, url, error) =>
                                                                                Icon(Icons.error), // Optional error widget to display on image load failure
                                                                          ),
                                                                        ),
                                                                        height:
                                                                            120,
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),

                                                            // Spinner Wheel

                                                            // InkWell(
                                                            //   onTap: () {
                                                            //     Navigator.push(
                                                            //         context,
                                                            //         MaterialPageRoute(
                                                            //             builder:
                                                            //                 (context) =>
                                                            //                     SpinnerGame()));
                                                            //   },
                                                            //   child: Padding(
                                                            //     padding:
                                                            //         const EdgeInsets
                                                            //                 .all(
                                                            //             8.0),
                                                            //     child:
                                                            //         Container(
                                                            //       child:
                                                            //           ClipRRect(
                                                            //         borderRadius:
                                                            //             BorderRadius.circular(
                                                            //                 10),
                                                            //         child:
                                                            //             CachedNetworkImage(
                                                            //           imageUrl:
                                                            //               _list[0]
                                                            //                   .ItemNameList[6], // Replace with your image URL
                                                            //           fit: BoxFit
                                                            //               .cover,
                                                            //           placeholder: (context,
                                                            //                   url) =>
                                                            //               Center(
                                                            //                   child: CircularProgressIndicator()), // Optional placeholder widget while loading
                                                            //           errorWidget: (context,
                                                            //                   url,
                                                            //                   error) =>
                                                            //               Icon(Icons
                                                            //                   .error), // Optional error widget to display on image load failure
                                                            //         ),
                                                            //       ),
                                                            //       height: 120,
                                                            //       width: MediaQuery.of(
                                                            //               context)
                                                            //           .size
                                                            //           .width,
                                                            //       decoration:
                                                            //           BoxDecoration(
                                                            //         borderRadius:
                                                            //             BorderRadius.circular(
                                                            //                 10),
                                                            //         color: Colors
                                                            //             .red,
                                                            //       ),
                                                            //     ),
                                                            //   ),
                                                            // ),
                                                          ],
                                                        ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  // Expanded(
                                  //   flex: 5,
                                  //   child: ListView.builder(
                                  //       // controller: scrollcontrller,
                                  //       primary: false,
                                  //       shrinkWrap: false,
                                  //       itemCount: _playSectionData.body.length,
                                  //       itemBuilder:
                                  //           (BuildContext context, index) {
                                  //         if (_playSectionData
                                  //                 .body[index].type ==
                                  //             "Level") {
                                  //           return gameQuizButton(context,
                                  //               _playSectionData, index);
                                  //         } else if (_playSectionData
                                  //                 .body[index].type ==
                                  //             "Score") {
                                  //           return gameQuizButton(context,
                                  //               _playSectionData, index);
                                  //         } else if (_playSectionData
                                  //                 .body[index].type ==
                                  //             "normalAd") {
                                  //           return StoreBannerAD();
                                  //         } else if (_playSectionData
                                  //                 .body[index].type ==
                                  //             "googleAd") {
                                  //           return Padding(
                                  //             padding:
                                  //                 const EdgeInsets.symmetric(
                                  //                     horizontal: 12,
                                  //                     vertical: 8),
                                  //             child: InlineAdaptiveBannerAds(
                                  //               bannerWidth: 320,
                                  //               bannerHeight: 100,
                                  //             ),
                                  //           );
                                  //         } else if (_playSectionData
                                  //                 .body[index].type ==
                                  //             "quiz") {
                                  //           return gameQuizButton(context,
                                  //               _playSectionData, index);
                                  //         } else {
                                  //           return null;
                                  //         }
                                  //       }),
                                  // ),
                                ],
                              ),
                              Visibility(
                                visible: buttonLoading,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 18, horizontal: 8),
                                  child: Container(
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.transparent,
                                  ),
                                ),
                              )
                            ],
                          )
                        : Center(child: Text("No posts Available"))
                    : Center(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 6,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ShimmerWidget(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width,
                              isCircle: false,
                            ),
                          ),
                        ),
                      )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            SizedBox(
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 30, right: 20, bottom: 20, left: 20),
                                child: Text(
                                  'You don\'t have access for this section',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 253, 118, 3),
                                      fontSize: 16),
                                ),
                                width: MediaQuery.of(context).size.width - 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: Color.fromARGB(255, 253, 118, 3),
                                        width: 1.2)),
                              ),
                            ),
                            Positioned(
                              child: SizedBox(
                                height: 40,
                                width: 20,
                                child: Image.asset(
                                  'assets/bg/infobg.png',
                                ),
                              ),
                              right: 0,
                              left: 0,
                              top: -20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
            : Center(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 6,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ShimmerWidget(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width,
                      isCircle: false,
                    ),
                  ),
                ),
              ));
  }
}
