// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/controllers/notification_controller.dart';
import 'package:play_pointz/screens/google_ads/inline_adaptive_banner_ads.dart';
import 'package:play_pointz/screens/home/notifications.dart';
import 'package:screen_protector/screen_protector.dart';

import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/controllers/coin_balance_controller.dart';
import 'package:play_pointz/controllers/quiz_controller.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/models/home/popup_banner.dart';
import 'package:play_pointz/screens/google_ads/banner_ad.dart';
import 'package:play_pointz/screens/home/home_page.dart';
import 'package:play_pointz/screens/shimmers/quiz_card_shimmer.dart';
import 'package:play_pointz/widgets/common/popup.dart';
import 'package:play_pointz/widgets/play/find_missing_character_card.dart';
import 'package:play_pointz/widgets/play/quiz_card.dart';
import 'package:play_pointz/widgets/play/word_correction.dart';

class QuizGames extends StatefulWidget {
  final VoidCallback cointBalanceUpdater;
  const QuizGames({
    Key key,
    this.cointBalanceUpdater,
  }) : super(key: key);

  @override
  State<QuizGames> createState() => _QuizGamesState();
}

class _QuizGamesState extends State<QuizGames> {
  bool isLoading = false;
  String playerName;
  var profileData;
  QuizController quizController;
  final userController = Get.put(UserController());
  bool img = true;
  CoinBalanceController coinBalanceController;
  var controller = ConfettiController();
  bool coinThrow = false;
  String selectedAnswer = '';
  String selectedCharacter = '';

  String unReadNotificationCount = '';

  Future<void> secureScreen() async {
    await ScreenProtector.preventScreenshotOn();
  }

  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  void initState() {
    ScreenProtector.preventScreenshotOn();
    coinBalanceController = Get.put(CoinBalanceController(callback: () {
      debugPrint(
          "+++++++++++++++++++++++++ controller from paly widget called");
      setState(() {});
    }));
    setState(() {
      quizController = Get.put(QuizController(
        callback: () {
          setState(() {});
        },
      ));
    });

    getNotificationCount();
    super.initState();
    showLatePopup();
  }

  void getNotificationCount() {
    final li = notificationController.notifications
        .where((element) => !element.is_read)
        .toList();
    unReadNotificationCount = li.length.toString();
  }

  void loadQuiz() async {
    setState(() {
      isLoading = true;
    });
    await quizController.setList().then((value) => setState(() {}));
    setState(() {
      isLoading = false;
    });
  }

  getcurrent() async {
    const oneSec = Duration(seconds: 3);
    Timer.periodic(oneSec, (Timer t) => setState(() {}));
  }

  showLatePopup() async {
    PopUpData data = await Api().getlatePopUp();
    if (data.done) {
      if (data.body != null) {
        loadPopup(data.body.image_url, data.body.id);
      }
    }
  }

  loadPopup(String imgUrl, String id) {
    try {
      var _image = NetworkImage(imgUrl);

      _image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener(
          (info, call) {
            showPopupBanner(imgUrl, id, context);
          },
        ),
      );
    } catch (e) {}
  }

  Stack notificationButton(String) {
    return Stack(
      children: [
        IconButton(
          // elevation: 1,
          onPressed: () {
            DefaultRouter.defaultRouter(Notifications(), context);
          },
          // backgroundColor: Colors.white,
          icon: FaIcon(
            FontAwesomeIcons.solidBell,
            color: Color(0xff606770),
            size: 20.0,
          ),
        ),
        if (unReadNotificationCount != "" && unReadNotificationCount != "0")
          Positioned(
            left: 27,
            top: 3,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.PRIMARY_COLOR,
              ),
              child: Center(
                  child: Text(
                unReadNotificationCount,
                style: TextStyle(color: Colors.white, fontSize: 12),
              )),
            ),
          )
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    ScreenProtector.preventScreenshotOff();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: kToolbarHeight * appBarHeightMultiPlier,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            activeIndex: 1,
                          )),
                  (Route<dynamic> route) => false);
              socket.disconnect();
            },
            icon: Icon(Icons.arrow_back_ios)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        actions: [
          userController.currentUser.value != null
              ? !userController.currentUser.value.is_brand_acc
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 26,
                          width: 26,
                          child: Image(
                            image: AssetImage("assets/logos/z.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 4),
                        Obx(() {
                          return Countup(
                            begin: coinBalanceController.previousBalance.value,
                            end: coinBalanceController.coinBalance.value,
                            duration: Duration(milliseconds: 1500),
                            separator: ',',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff52616B),
                            ),
                          );
                        }),
                        SizedBox(width: 38),
                      ],
                    )
                  : Row(
                      children: [
                        SizedBox(width: 30),
                      ],
                    )
              : Row(
                  children: [
                    SizedBox(width: 30),
                  ],
                )
        ],
      ),
      body: Stack(
        children: [
          userController.currentUser.value != null
              ? !userController.currentUser.value.is_brand_acc
                  ? Obx(
                      () {
                        return quizController.quiz.isEmpty
                            ? ListView.builder(
                                itemCount: 4,
                                itemBuilder: (context, index) {
                                  return PlayCardShimmer();
                                },
                              )
                            : RefreshIndicator(
                                onRefresh: refersher,
                                child: ListView(
                                  children: [
                                    for (int index = 0;
                                        index < quizController.quiz.length;
                                        index++)
                                      quizController.quiz[index].type == "quiz"
                                          ? QuizCard(
                                              confettiController: controller,
                                              controller: coinBalanceController,
                                              quiz: quizController.quiz[index],
                                              callback: () => {setState(() {})},
                                              animationPlayCallback: () =>
                                                  setState(() {
                                                coinThrow = true;
                                                controller.play();
                                              }),
                                              animationStopCallback: () =>
                                                  setState(() {
                                                coinThrow = false;
                                                controller.stop();
                                              }),
                                            )
                                          : quizController.quiz[index].type ==
                                                  "normalAd"
                                              ? BannerAD()
                                              : quizController
                                                          .quiz[index].type ==
                                                      "googleAd"
                                                  ? Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 8),
                                                      child:
                                                          InlineAdaptiveBannerAds(
                                                        bannerWidth: 300,
                                                        bannerHeight: 250,
                                                      ),
                                                    )
                                                  : quizController.quiz[index]
                                                              .type ==
                                                          "wc_game"
                                                      ? WordCorrectionCard(
                                                          userController:
                                                              userController,
                                                          confettiController:
                                                              controller,
                                                          controller:
                                                              coinBalanceController,
                                                          callback: () =>
                                                              {setState(() {})},
                                                          animationPlayCallback:
                                                              () =>
                                                                  setState(() {
                                                            coinThrow = true;
                                                            controller.play();
                                                          }),
                                                          animationStopCallback:
                                                              () =>
                                                                  setState(() {
                                                            coinThrow = false;
                                                            controller.stop();
                                                          }),
                                                          wcGame: quizController
                                                              .quiz[index],
                                                        )
                                                      : quizController
                                                                  .quiz[index]
                                                                  .type ==
                                                              "mc_game"
                                                          ? FindMissingCharacterCard(
                                                              userController:
                                                                  userController,
                                                              confettiController:
                                                                  controller,
                                                              controller:
                                                                  coinBalanceController,
                                                              callback: () => {
                                                                setState(() {})
                                                              },
                                                              animationPlayCallback:
                                                                  () =>
                                                                      setState(
                                                                          () {
                                                                coinThrow =
                                                                    true;
                                                                controller
                                                                    .play();
                                                              }),
                                                              animationStopCallback:
                                                                  () =>
                                                                      setState(
                                                                          () {
                                                                coinThrow =
                                                                    false;
                                                                controller
                                                                    .stop();
                                                              }),
                                                              mcGame:
                                                                  quizController
                                                                          .quiz[
                                                                      index],
                                                            )
                                                          : Container()
                                  ],
                                ),
                              );
                      },
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
                                  // color: Colors.amber,
                                  // height: 150,
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color:
                                              Color.fromARGB(255, 253, 118, 3),
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
              : ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return PlayCardShimmer();
                  },
                ),
          coinThrow
              ? Center(
                  child: Lottie.asset(
                    "assets/lottie/s2.json",
                    fit: BoxFit.fitWidth,
                    repeat: false,
                  ),
                )
              : Container(),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            left: 0,
            child: ConfettiWidget(
              blastDirection: pi * 1.75,
              shouldLoop: false,
              confettiController: controller,
              blastDirectionality: BlastDirectionality.directional,
              emissionFrequency: 0,
              numberOfParticles: 50,
              minBlastForce: 1,
              maxBlastForce: 20,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            right: 0,
            child: ConfettiWidget(
              blastDirection: pi * 1.25,
              shouldLoop: false,
              confettiController: controller,
              blastDirectionality: BlastDirectionality.directional,
              emissionFrequency: 0,
              numberOfParticles: 50,
              minBlastForce: 1,
              maxBlastForce: 20,
            ),
          )
        ],
      ),
    );
  }

  Future<void> refersher() async {
    await quizController.setList();
    setState(() {});
  }
}
