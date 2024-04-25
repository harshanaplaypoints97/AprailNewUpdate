import 'package:audioplayers/audioplayers.dart';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';

import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/style.dart';
import 'package:play_pointz/controllers/coin_balance_controller.dart';
import 'package:play_pointz/controllers/feed_controller.dart';

import 'package:play_pointz/controllers/quiz_controller.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/models/play/new_quiz_model.dart';
import 'package:play_pointz/models/play/submit_answer.dart';
import 'package:play_pointz/widgets/play/answer_btn.dart';
import 'package:play_pointz/widgets/play/widgets/mc_game_result_card.dart';

// ignore: must_be_immutable
class FindMissingCharacterCard extends StatefulWidget {
  final VoidCallback animationPlayCallback;
  final VoidCallback animationStopCallback;
  final AnimationController animationController;
  final ConfettiController confettiController;
  final UserController userController;
  final NewQuizModel mcGame;
  final VoidCallback callback;
  final CoinBalanceController controller;
  final bool fromFeed;
  final int index;

  FindMissingCharacterCard({
    Key key,
    this.callback,
    this.controller,
    this.fromFeed = false,
    this.mcGame,
    this.index = -1,
    this.confettiController,
    this.animationController,
    this.animationPlayCallback,
    this.animationStopCallback,
    this.userController,
  }) : super(key: key);

  @override
  _FindMissingCharacterCardState createState() =>
      _FindMissingCharacterCardState();

  static void refreshFunction() async {
    // FindMissingCharacterCard.widget.refreshPageFunc();
  }
}

class _FindMissingCharacterCardState extends State<FindMissingCharacterCard> {
  String selectedCharacter = "";
  String selectedAnswer = "";
  bool shouldLoad = false;
  final quizController = Get.put(QuizController());
  final userController = Get.put(UserController());
  final feedcontroller = Get.put(FeedController());
  bool playlottie = false;
  CoinBalanceController coinsController;

  bool shouldAnimate = false;
  @override
  void initState() {
    userController.setCurrentUser();
    setState(() {
      if (widget.controller == null) {
        coinsController = Get.put(
          CoinBalanceController(
            callback: widget.callback,
          ),
        );
      } else {
        coinsController = widget.controller;
      }
    });
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  Future<void> submitAnswer() async {
    // validateAndSave();
    if (selectedAnswer != '') {
      setState(() {
        shouldLoad = true;
      });
      SubmitAnswer result = await Api().submitMCGameAnswer(
          mcGameId: widget.mcGame.id, answerId: selectedAnswer);
      if (result.done != null) {
        if (result.done) {
          quizController.submitMCGameAnswer(
            quizId: widget.mcGame.id,
            isCorrect: result.body.status,
            isAnswered: true,
            type: widget.mcGame.type,
            i: widget.index,
          );
          if (result.body.status) {
            //feedcontroller.onInit();
            final audio = AudioPlayer();
            audio.play(AssetSource("audio/coins.mp3"));
            debugPrint("++++++++++++++++++++++++++ animation state called");
            setState(() {
              widget.animationPlayCallback();
              playlottie = true;
              shouldAnimate = true;
              Future.delayed(Duration(seconds: 3), () {
                setState(() {
                  playlottie = false;
                });
              });
            });
            Future.delayed(const Duration(milliseconds: 3000))
                .then((value) => setState(() {
                      widget.animationStopCallback();
                      shouldAnimate = false;
                    }));
            coinsController.updateCoinBalance(
              (coinsController.coinBalance.value + widget.mcGame.points) / 1.0,
            );
            coinsController.onInit();
            setState(() {});
            selectedAnswer = "";
            selectedCharacter = "";
          } else {
            final audio = AudioPlayer();
            audio.play(AssetSource("audio/lose1.wav"));
            coinsController.updateCoinBalance(
                (coinsController.coinBalance.value -
                        widget.mcGame.minusPoints) /
                    1.0);
            coinsController.onInit();
            selectedAnswer = "";
            selectedCharacter = "";
          }
          // messageToastGreen(result.message);
        } else {
          quizController.submitMCGameAnswer(
            isCorrect: result.body.status,
            isAnswered: true,
            quizId: widget.mcGame.id,
            type: widget.mcGame.type,
            i: widget.index,
          );
          coinsController.onInit();
          setState(() {});
          widget.callback();
          Get.snackbar(
              "Hey, ${widget.userController.currentUser.value.username}",
              result.message);
          setState(() {
            shouldLoad = false;
          });
        }
      } else {
        Get.snackbar("Hey, ${widget.userController.currentUser.value.username}",
            result.message);

        setState(() {
          shouldLoad = false;
        });
      }
      widget.callback();
      setState(() {
        shouldLoad = false;
      });
    } else {
      Get.snackbar("Hey, ${widget.userController.currentUser.value.username}",
          "please select an answer");
      setState(() {
        shouldLoad = false;
      });
    }

    setState(() {
      shouldLoad = false;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: /*  AppColors.PRIMARY_COLOR_LIGHT */ Colors.white,
                    width: 1),
                borderRadius: BorderRadius.all(const Radius.circular(12.0)),
                boxShadow: [AppStyles.boxShadow]),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          left: 12, right: 12, top: 12, bottom: 12),
                      child: Row(children: [
                        Container(
                          width: 36.0,
                          height: 36.0,
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                //image: AssetImage("assets/logos/z.png"),
                                image: AssetImage(
                                    "assets/logos/Playpointz_icon.png")),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.normalTextColor,
                                      fontWeight: FontWeight.w600),
                                  children: [
                                    TextSpan(
                                        text: 'PlayPointz ',
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            color: AppColors.normalTextColor,
                                            fontWeight: FontWeight.w600)),
                                    WidgetSpan(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                        child: Icon(
                                          Icons.verified_rounded,
                                          color: AppColors.BUTTON_BLUE_COLLOR,
                                          size: 16.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ]),
                    ),
                    widget.mcGame.isAnswered
                        ? widget.mcGame.isCorrect
                            ? MCGameResultCard(
                                answer:
                                    widget.mcGame.originalWord.toUpperCase(),
                                size: size,
                                result: true,
                                points: widget.mcGame.points,
                                name:
                                    userController.currentUser.value.fullName ??
                                        '',
                              )
                            :

                            // Wrong answer

                            MCGameResultCard(
                                answer:
                                    widget.mcGame.originalWord.toUpperCase(),
                                size: size,
                                result: false,
                                points: widget.mcGame.minusPoints,
                                name:
                                    userController.currentUser.value.fullName ??
                                        '',
                              )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Find the missing character",
                                  style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.PRIMARY_COLOR_LIGHT),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: RichText(
                                      text: TextSpan(
                                        text:
                                            // var wordParts = widget.mcGame.quiz.split('_');
                                            widget.mcGame.quiz
                                                .split('_')
                                                .elementAt(0),
                                        style: TextStyle(
                                            fontSize: 28.sp,
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w500),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: selectedCharacter == ""
                                                  ? " _ "
                                                  : selectedCharacter,
                                              style: TextStyle(
                                                  fontSize: 28.sp,
                                                  color: AppColors
                                                      .PRIMARY_COLOR_LIGHT,
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                            text: widget.mcGame.quiz
                                                .split('_')
                                                .elementAt(1),
                                            style: TextStyle(
                                                fontSize: 28.sp,
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 24),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      for (int i = 0; i < 4; i++)
                                        selectCharacterBtn(
                                            character: widget
                                                .mcGame.quizAnswers[i].answer,
                                            selected: selectedCharacter ==
                                                    widget.mcGame.quizAnswers[i]
                                                        .answer
                                                ? true
                                                : false,
                                            function: () {
                                              Vibrate.feedback(
                                                  FeedbackType.impact);
                                              setState(() {
                                                selectedCharacter = widget
                                                    .mcGame
                                                    .quizAnswers[i]
                                                    .answer;
                                                selectedAnswer = widget
                                                    .mcGame.quizAnswers[i].id;
                                              });
                                            }),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  child: shouldLoad
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.PRIMARY_COLOR,
                                          ),
                                        )
                                      : answerSubmitBtn(context, size: size,
                                          function: () {
                                          submitAnswer();
                                          // widget.confettiController.play();
                                        }),
                                ),
                              ],
                            ),
                          ),

                    //bottom part
                    Divider(
                      thickness: 1,
                      height: 1,
                      indent: 12,
                      endIndent: 12,
                    ),
                    DefaultTextStyle(
                      style: TextStyle(
                        color: AppColors.normalTextColor,
                        fontSize: MediaQuery.of(context).size.height / 45,
                        fontWeight: FontWeight.w600,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        height: kToolbarHeight,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/logos/z.png",
                                    height: kToolbarHeight / 2,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "+${widget.mcGame.points} POINTZ",
                                    style: TextStyle(fontSize: 16.sp),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/logos/z.png",
                                    height: kToolbarHeight / 2,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "-${widget.mcGame.minusPoints} POINTZ",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 16.sp),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )),
      ],
    );
  }
}
