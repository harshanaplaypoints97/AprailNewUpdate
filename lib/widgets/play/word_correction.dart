import 'package:audioplayers/audioplayers.dart';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

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
class WordCorrectionCard extends StatefulWidget {
  final VoidCallback animationPlayCallback;
  final VoidCallback animationStopCallback;
  final AnimationController animationController;
  final ConfettiController confettiController;
  final UserController userController;
  final NewQuizModel wcGame;
  final VoidCallback callback;
  final CoinBalanceController controller;
  final bool fromFeed;
  final int index;

  WordCorrectionCard({
    Key key,
    this.callback,
    this.controller,
    this.fromFeed = false,
    this.wcGame,
    this.index = -1,
    this.confettiController,
    this.animationController,
    this.animationPlayCallback,
    this.animationStopCallback,
    this.userController,
  }) : super(key: key);

  @override
  _WordCorrectionCardState createState() => _WordCorrectionCardState();

  static void refreshFunction() async {
    // WordCorrectionCard.widget.refreshPageFunc();
  }
}

class _WordCorrectionCardState extends State<WordCorrectionCard> {
  //String selectedAnswer = '';
  TextEditingController answer = TextEditingController();
  bool shouldLoad = false;
  final quizController = Get.put(QuizController());
  final userController = Get.put(UserController());
  final feedcontroller = Get.put(FeedController());
  bool playlottie = false;
  CoinBalanceController coinsController;
  String unorderdText = "MODYANYUYU";

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
    if (answer.length == widget.wcGame.quiz.length) {
      setState(() {
        shouldLoad = true;
      });
      SubmitAnswer result = await Api()
          .submitWCGameAnswer(wcGameId: widget.wcGame.id, answer: answer.text);
      if (result.done != null) {
        if (result.done) {
          answer.clear();
          quizController.submitWCGameAnswer(
            quizId: widget.wcGame.id,
            isCorrect: result.body.status,
            isAnswered: true,
            type: widget.wcGame.type,
            i: widget.index,
          );
          if (result.body.status) {
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
              (coinsController.coinBalance.value + widget.wcGame.points) / 1.0,
            );
            coinsController.onInit();
            setState(() {});
          } else {
            quizController.submitMCGameAnswer(
              isCorrect: result.body.status,
              isAnswered: true,
              quizId: widget.wcGame.id,
              type: widget.wcGame.type,
              i: widget.index,
            );
            final audio = AudioPlayer();
            audio.play(AssetSource("audio/lose1.wav"));
            coinsController.updateCoinBalance(
                (coinsController.coinBalance.value -
                        widget.wcGame.minusPoints) /
                    1.0);
            coinsController.onInit();
            setState(() {});
          }
          // messageToastGreen(result.message);
        } else {
          answer.clear();
          quizController.submitMCGameAnswer(
            isCorrect: result.body.status,
            isAnswered: true,
            quizId: widget.wcGame.id,
            type: widget.wcGame.type,
            i: widget.index,
          );
          Get.snackbar(
              "Hey, ${widget.userController.currentUser.value.username}",
              result.message);
        }
      } else {
        Get.snackbar("Hey, ${widget.userController.currentUser.value.username}",
            result.message);
      }
      widget.callback();
      setState(() {
        shouldLoad = false;
      });
    } else {
      Get.snackbar("Hey, ${widget.userController.currentUser.value.username}",
          "please enter the word");
      setState(() {
        shouldLoad = false;
      });
    }
    setState(() {});
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: GoogleFonts.poppins(
        fontSize: 22, fontWeight: FontWeight.w500, color: Colors.grey.shade800),
    decoration: const BoxDecoration(),
  );
  final disablePinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: GoogleFonts.poppins(
        fontSize: 22, fontWeight: FontWeight.w500, color: Colors.grey.shade800),
    decoration: const BoxDecoration(),
  );

  final preFilledWidget = Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        margin: const EdgeInsets.only(bottom: 12),
        width: 56,
        height: 2,
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ],
  );
  final cursor = Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        margin: const EdgeInsets.only(bottom: 12),
        width: 56,
        height: 2,
        decoration: BoxDecoration(
          color: Colors.grey.shade600,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ],
  );
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
                color: Colors.white,
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

                    widget.wcGame.isAnswered
                        ? widget.wcGame.isCorrect
                            ? MCGameResultCard(
                                answer:
                                    widget.wcGame.originalWord.toUpperCase(),
                                size: size,
                                result: true,
                                points: widget.wcGame.points,
                                name:
                                    userController.currentUser.value.fullName ??
                                        '',
                              )
                            :

                            // Wrong answer

                            MCGameResultCard(
                                answer:
                                    widget.wcGame.originalWord.toUpperCase(),
                                size: size,
                                result: false,
                                points: widget.wcGame.minusPoints,
                                name:
                                    userController.currentUser.value.fullName ??
                                        '',
                              )
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Word Correction",
                                      style: TextStyle(
                                          fontSize: 26.sp,
                                          color: AppColors.PRIMARY_COLOR_LIGHT,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 3.h,
                                    ),
                                    Text(
                                      "Guess the hidden word",
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 12.h,
                                ),
                                Text(
                                  widget.wcGame.quiz,
                                  style: TextStyle(
                                      fontSize: 32.sp,
                                      color: Colors.grey.shade800,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 12.h,
                                ),
                                Form(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey.shade200),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: Pinput(
                                            controller: answer,
                                            showCursor: true,
                                            cursor: cursor,
                                            preFilledWidget: preFilledWidget,
                                            defaultPinTheme: defaultPinTheme,
                                            animationDuration:
                                                Duration(milliseconds: 400),
                                            animationCurve: Curves.easeInOut,
                                            isCursorAnimationEnabled: false,
                                            pinAnimationType:
                                                PinAnimationType.fade,
                                            keyboardType: TextInputType.text,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp("[A-Za-z]"))
                                            ],
                                            textCapitalization:
                                                TextCapitalization.characters,
                                            length: widget.wcGame.quiz.length,
                                          ),
                                        )),
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
                                    "+${widget.wcGame.points} POINTZ",
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
                                    "-${widget.wcGame.minusPoints} POINTZ",
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
