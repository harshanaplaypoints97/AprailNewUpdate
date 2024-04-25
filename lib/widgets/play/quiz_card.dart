import 'package:audioplayers/audioplayers.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/shimmers/shimmer_widget.dart';
import 'package:play_pointz/widgets/play/answer_btn.dart';
import 'package:play_pointz/widgets/play/widgets/quiz_result_card.dart';
import 'package:play_pointz/widgets/play/widgets/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ignore: must_be_immutable
class QuizCard extends StatefulWidget {
  final VoidCallback animationPlayCallback;
  final VoidCallback animationStopCallback;
  final AnimationController animationController;
  final ConfettiController confettiController;
  final NewQuizModel quiz;
  final VoidCallback callback;
  final CoinBalanceController controller;
  final bool fromFeed;
  final int index;

  QuizCard({
    Key key,
    this.callback,
    this.controller,
    this.fromFeed = false,
    this.quiz,
    this.index = -1,
    this.confettiController,
    this.animationController,
    this.animationPlayCallback,
    this.animationStopCallback,
  }) : super(key: key);

  @override
  _QuizCardState createState() => _QuizCardState();

  static void refreshFunction() async {}
}

class _QuizCardState extends State<QuizCard> {
  String selectedAnswer = '';
  bool shouldLoad = false;
  final quizController = Get.put(QuizController());
  final userController = Get.put(UserController());
  final feedcontroller = Get.put(FeedController());
  bool playlottie = false;
  CoinBalanceController coinsController;

  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'euQUgp5AY-Y',
    flags: YoutubePlayerFlags(
      autoPlay: false,
      mute: true,
    ),
  );

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
      SubmitAnswer result = await Api().submitAnswer(context,
          quizId: widget.quiz.id, answerId: selectedAnswer);
      if (result.done != null) {
        if (result.done) {
          quizController.submitAnswer(
            widget.quiz.id,
            result.body.status,
            fromFeed: widget.fromFeed,
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
                      //  widget.confettiController.stop();
                      //  widget.animationController.stop();
                      shouldAnimate = false;
                    }));
            coinsController.updateCoinBalance(
              (coinsController.coinBalance.value + widget.quiz.points) / 1.0,
            );
            coinsController.onInit();
            setState(() {});
          } else {
            final audio = AudioPlayer();
            audio.play(AssetSource("audio/lose1.wav"));
            coinsController.updateCoinBalance(
                (coinsController.coinBalance.value - widget.quiz.minusPoints) /
                    1.0);
            coinsController.onInit();
          }
        } else {
          if (result.body.status != null) {
            quizController.submitAnswer(
              widget.quiz.id,
              result.body.status,
              fromFeed: widget.fromFeed,
              i: widget.index,
            );
          }
          Get.snackbar("Hey, ${userController.currentUser.value.username}",
              result.message);
        }
      } else {
        Get.snackbar("Hey, ${userController.currentUser.value.username}",
            result.message);
      }
      widget.callback();
      setState(() {
        shouldLoad = false;
      });
    } else {
      Get.snackbar("Hey, ${userController.currentUser.value.username}",
          "Please select an Answer");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
            margin: !widget.fromFeed
                ? const EdgeInsets.symmetric(vertical: 6, horizontal: 12)
                : const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
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
                    if (widget.quiz.description != "")
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 12),
                        width: size.width,
                        child: Text(
                          // 'What is the highest mountain in the world?',
                          widget.quiz.description,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.normalTextColor.withOpacity(0.8),
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    widget.quiz.mediaUrl != null && widget.quiz.mediaUrl != ''
                        ? Container(
                            padding: const EdgeInsets.only(
                                left: 0, right: 0, top: 12, bottom: 12),
                            // margin: const EdgeInsets.all(10),
                            width: size.width,

                            child: widget.quiz.mediaUrl.endsWith(".mp4")
                                ? SizedBox(
                                    child:
                                        SamplePlayer(url: widget.quiz.mediaUrl))
                                : widget.quiz.mediaUrl.contains("youtube")
                                    ? Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child:
                                            // SamplePlayer(url: widget.quiz.mediaUrl))
                                            YoutubePlayer(
                                          controller: YoutubePlayerController(
                                            initialVideoId:
                                                YoutubePlayer.convertUrlToId(
                                                    widget.quiz.mediaUrl),
                                            flags: YoutubePlayerFlags(
                                              autoPlay: false,
                                              hideControls: false,
                                              mute: false,
                                            ),
                                          ),
                                          showVideoProgressIndicator: true,
                                          progressIndicatorColor: Colors.amber,
                                          bottomActions: [
                                            CurrentPosition(),
                                            ProgressBar(isExpanded: true),
                                            // TotalDuration(),
                                          ],
                                        ))
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: CachedNetworkImage(
                                          cacheManager:
                                              CustomCacheManager.instance,
                                          imageUrl: widget.quiz.mediaUrl,
                                          errorWidget: (context, url, error) =>
                                              SizedBox(),
                                          placeholder: (context, a) {
                                            return ShimmerWidget(
                                              isCircle: false,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.2,
                                              height: 240.h,
                                            );
                                          },
                                        ),
                                      ),
                          )
                        : Container(
                            height: 10,
                          ),

                    // Correct answer
                    widget.quiz.isCorrectAnswer != null
                        ? widget.quiz.isCorrectAnswer
                            ? QuizResultCard(
                                size: size,
                                result: true,
                                points: widget.quiz.points,
                                name:
                                    userController.currentUser.value.fullName ??
                                        '',
                              )
                            :

                            // Wrong answer

                            QuizResultCard(
                                size: size,
                                result: false,
                                points: widget.quiz.minusPoints,
                                name:
                                    userController.currentUser.value.fullName ??
                                        '',
                              )
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(const Radius.circular(20.0)),
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ],
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 6),
                            padding: const EdgeInsets.all(10),
                            // child: CustomRadio(),
                            child: Column(children: [
                              for (var k = 0;
                                  k < widget.quiz.quizAnswers.length;
                                  k++)
                                answerBtn(
                                    context: context,
                                    answer: widget.quiz.quizAnswers[k].answer,
                                    selected: selectedAnswer ==
                                            widget.quiz.quizAnswers[k].id
                                        ? true
                                        : false,
                                    function: () {
                                      setState(() {
                                        selectedAnswer =
                                            widget.quiz.quizAnswers[k].id;
                                      });
                                      // print('clicked ' + selectedAnswer);
                                    }),
                              SizedBox(
                                height: 12,
                              ),
                              shouldLoad
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.PRIMARY_COLOR,
                                      ),
                                    )
                                  : answerSubmitBtn(context, size: size,
                                      function: () {
                                      submitAnswer();
                                    }),
                            ]),
                          ),
                    widget.quiz.isCorrectAnswer != null
                        ? widget.quiz.isCorrectAnswer
                            ? Container()
                            : Container()
                        : Divider(
                            thickness: 1,
                            height: 1,
                            indent: 12,
                            endIndent: 12,
                          ),
                    if (widget.quiz.isCorrectAnswer == null)
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
                                      "+${widget.quiz.points} POINTZ",
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
                                      "-${widget.quiz.minusPoints} POINTZ",
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
