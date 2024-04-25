// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:get/get.dart";
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/controllers/feed_controller.dart';
import 'package:play_pointz/models/NewModelsV2/feed/single_announcement2.dart';
import 'package:play_pointz/models/notificaitons/announce_like_model.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/feed/components/description_container.dart';
import 'package:play_pointz/screens/feed/components/heart_animation_widget.dart';
import 'package:play_pointz/screens/profile/prof_announce_new.dart';
import 'package:play_pointz/screens/profile/profile.dart';
import 'package:play_pointz/widgets/common/toast.dart';

import 'package:timeago/timeago.dart' as timeago;

class NotificationAnounceViewNew extends StatefulWidget {
  BodyOfSingleAnnouncement anounce;
  bool animating;
  bool animatingCongrats;
  // int index;
  NotificationAnounceViewNew(
      this.anounce, this.animating, this.animatingCongrats /* , this.index */);

  @override
  State<NotificationAnounceViewNew> createState() =>
      _NotificationAnounceViewNewState();
}

bool reacting = false;
bool updating = false;
bool congrats = false;
bool goodluck = false;
bool isHeartAnimating = false;
bool isHateAnimating = false;
AnimationController _animationControllerCongrats;
AnimationController _animationControllerGoodLuck;

class _NotificationAnounceViewNewState extends State<NotificationAnounceViewNew>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  TextEditingController commentController = TextEditingController();
  final commentFormFocusNode = FocusNode();
  bool isCommenting = false;

  @override
  void initState() {
    _animationControllerCongrats =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    _animationControllerGoodLuck =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    setState(() {
      reacted = widget.anounce.isLiked;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    setState(() {
      widget.animating = false;
      widget.animatingCongrats = false;
    });
    super.dispose();
  }

  bool reacted = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 8, right: 8),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            // color: Colors.yellow[700],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                //image: AssetImage("assets/logos/z.png"),
                                image: AssetImage(
                                    "assets/logos/Playpointz_icon.png")),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
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
                        Text(
                          timeago.format(
                              DateTime.parse(widget.anounce.dateUpdated)),
                          style: TextStyle(
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: DescriptionContaine(
                  MediaUrl: widget.anounce.mediaUrl,
                  descrition: widget.anounce.description ?? "",
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              winProductAnounce(
                widget.anounce.mediaUrl,
                widget.anounce.mediaUrl,
                "Purchase item",
                size,
              ),
              SizedBox(
                height: 16.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (!reacting) {
                            setState(() {
                              reacting = true;
                            });
                            if (reacted) {
                              Removelike(widget.anounce.id);
                            } else {
                              Submitlike(widget.anounce.id);
                            }
                          }
                        },
                        child: HeartAnimationWidget(
                          widget: Icon(
                            Icons.favorite,
                            color: reacted
                                ? Colors.red
                                : AppColors.normalTextColor,
                          ),
                          duration: const Duration(milliseconds: 800),
                          isAnimating: isHeartAnimating,
                          onEnd: () => (setState(() {
                            isHeartAnimating = false;
                          })),
                        ),
                      ),
                      SizedBox(
                        width: 6.w,
                      ),
                      Text(widget.anounce.likesCount + " likes",
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              if (widget.anounce.announcementComments.isNotEmpty)
                InkWell(
                  onTap: () {
                    Get.to(
                      () => ProfleAnnouncePageNew(
                        announcementId: widget.anounce.id,
                        index: 2,
                      ),
                    );
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(
                            widget.anounce.announcementComments.first
                                    .playerImage ??
                                "https://st3.depositphotos.com/4111759/13425/v/600/depositphotos_134255710-stock-illustration-avatar-vector-male-profile-gray.jpg",
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ExpandableText(
                                widget
                                    .anounce.announcementComments.first.comment,
                                expandText: 'see more',
                                collapseText: 'see less',
                                maxLines: 2,
                                linkColor: Colors.blue,
                              ),
                              Text(
                                timeago.format(
                                  DateTime.parse(
                                    widget.anounce.announcementComments.first
                                        .dateCreated,
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (int.parse(widget.anounce.commentsCount) > 1)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: InkWell(
                    onTap: () {
                      Get.to(
                        () => ProfleAnnouncePageNew(
                          announcementId: widget.anounce.id,
                          index: 2,
                        ),
                      );
                    },
                    child: Text(
                      "View all Wishes ...",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          widget.animating
              ? Lottie.asset(
                  "assets/lottie/cele4.json",
                  controller: _animationControllerCongrats,
                  repeat: false,
                )
              : Container(),
          widget.animatingCongrats
              ? Lottie.asset(
                  "assets/lottie/cele5.json",
                  controller: _animationControllerGoodLuck,
                  repeat: false,
                )
              : Container(),
        ],
      ),
    );
  }

  Widget winProductAnounce(
    String imgUrl,
    String winerProfileUrl,
    String name,
    Size size,
  ) {
    return InkWell(
      onTap: () {
        userController.currentUser.value.id != widget.anounce.playerId
            ? DefaultRouter.defaultRouter(
                Profile(
                  id: widget.anounce.playerId,
                  myProfile: false,
                  postId: "",
                ),
                /* PlayerProfieView(
                  playerId: widget.anounce.playerId,
                ), */
                context,
              )
            : null;
      },
      onDoubleTap: () {
        if (!reacting) {
          setState(() {
            reacting = true;
          });
          if (reacted) {
            Removelike(widget.anounce.id);
          } else {
            Submitlike(widget.anounce.id);
          }
        }
      },
      child: Stack(
        children: [
          Padding(
            padding:
                EdgeInsets.only(top: 30.sp, left: 0, right: 0, bottom: 60.sp),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.sp),
                child: Image.asset(
                  "assets/new/card1.png",
                  fit: BoxFit.fitWidth,
                )),
          ),
          SizedBox(
            width: size.width * 0.45,
            child: CachedNetworkImage(
              cacheManager: CustomCacheManager.instance,
              imageUrl: widget.anounce.mediaUrl,
              fit: BoxFit.fitWidth,
            ),
          ),

          Positioned(
            top: 0,
            right: size.width * 0.05,
            left: size.width * 0.45,
            bottom: 90,
            //right: MediaQuery.of(context).size.width * 0.00,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.09,
                    backgroundColor: Color(0xfffe7f2b),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: MediaQuery.of(context).size.width * 0.083,
                      backgroundImage: NetworkImage(
                        widget.anounce.playerImage ??
                            "https://st3.depositphotos.com/4111759/13425/v/600/depositphotos_134255710-stock-illustration-avatar-vector-male-profile-gray.jpg",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  SizedBox(
                    width: size.width * 0.45,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        "Congratulations!",
                        style: TextStyle(
                            fontFamily: "Arial",
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 22.sp),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    widget.anounce.playerName.split(" ").elementAt(0),
                    style: TextStyle(
                        fontFamily: "Arial",
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp),
                  ),
                  SizedBox(height: 12.sp),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "You Won",
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: "Arial",
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 8.sp,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 12.sp, right: 12.sp),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 8.sp, right: 8.sp, top: 4.sp, bottom: 4.sp),
                          child: Column(
                            children: [
                              SizedBox(
                                width: size.width * 0.35,
                                child: Text(
                                  /* widget.anounce.ItemName ?? */ "This Item",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "Arial",
                                    fontSize: 14.sp,
                                    color: Color(0xfffe7f2b),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width * 0.025,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if (!widget.animating) {
                      int i = int.parse(widget.anounce.commentsCount);
                      i++;
                      final audio = AudioPlayer();
                      audio.play(AssetSource("audio/goodluck.mp3"));
                      setState(() {
                        widget.animating = true;
                        widget.anounce.commentsCount = i.toString();
                        _animationControllerCongrats.repeat();
                        Future.delayed(Duration(seconds: 3), () {
                          setState(() {
                            _animationControllerCongrats.reset();
                            widget.animating = false;
                          });
                        });
                      });
                      SubmitWishes("congratulations", widget.anounce.id);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "Congratulations!",
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange[600]),
                            ),
                            SizedBox(
                              width: 6.sp,
                            ),
                            Image.asset(
                              "assets/new/confetti.png",
                              fit: BoxFit.fitWidth,
                              height: MediaQuery.of(context).size.width * 0.05,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (!widget.animatingCongrats && !widget.animating) {
                      int i = int.parse(widget.anounce.commentsCount);
                      i++;
                      final audio = AudioPlayer();
                      audio.play(AssetSource("audio/congratulation.mp3"));
                      setState(() {
                        widget.animating = true;
                        widget.animatingCongrats = true;
                        widget.anounce.commentsCount = i.toString();
                        _animationControllerGoodLuck.repeat();
                        Future.delayed(Duration(milliseconds: 2000), () {
                          setState(() {
                            _animationControllerGoodLuck.reset();
                            widget.animating = false;
                            widget.animatingCongrats = false;
                          });
                        });
                      });
                      SubmitWishes("Good luck", widget.anounce.id);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8.sp, 8.sp, 8.sp, 16.sp),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.sp),
                        child: Row(
                          children: [
                            Text("Good Luck!",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange[600])),
                            SizedBox(
                              width: 6.sp,
                            ),
                            Image.asset(
                              "assets/new/confetti.png",
                              fit: BoxFit.fitWidth,
                              height: MediaQuery.of(context).size.width * 0.05,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ), // Liked
          Positioned(
            top: 50,
            left: MediaQuery.of(context).size.width * 0.3,
            right: MediaQuery.of(context).size.width * 0.3,
            child: Opacity(
              opacity: isHeartAnimating ? 1 : 0,
              child: HeartAnimationWidget(
                widget: Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 80.sp,
                ),
                duration: const Duration(milliseconds: 800),
                isAnimating: isHeartAnimating,
                onEnd: () => (setState(() {
                  isHeartAnimating = false;
                })),
              ),
            ),
          ),
          // Dislike
          Positioned(
            top: 50,
            left: MediaQuery.of(context).size.width * 0.3,
            right: MediaQuery.of(context).size.width * 0.3,
            child: Opacity(
              opacity: isHateAnimating ? 1 : 0,
              child: HeartAnimationWidget(
                widget: Icon(
                  Icons.heart_broken,
                  color: Colors.white,
                  size: 80.sp,
                ),
                duration: const Duration(milliseconds: 800),
                isAnimating: isHateAnimating,
                onEnd: () => (setState(() {
                  isHateAnimating = false;
                })),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> SubmitWishes(String wish, String id) async {
    final result = await Api().createWish(announcementId: id, comment: wish);
    print(result);
  }

  final postController = Get.put(FeedController());

  Future<void> submitTypedWishes(String wish, String id) async {
    final result = await Api().createWish(announcementId: id, comment: wish);
    if (result.done) {}
    commentController.clear();

    print(result);
  }

  Future<void> Submitlike(String id) async {
    setState(() {
      isHeartAnimating = true;
    });
    AnnounceLikeModel like = await Api().announcementLike(announcementId: id);

    setState(() {
      try {
        widget.anounce.likeId = like.id;
        widget.anounce.likesCount =
            (int.parse(widget.anounce.likesCount) + 1).toString();
        reacted = true;
        reacting = false;
      } catch (e) {
        print(e);
      }
    });
  }

  Future<void> Removelike(String id) async {
    setState(() {
      isHateAnimating = true;
    });
    AnnounceLikeModel like =
        await Api().deleteAnnouncementLike(announcementId: id);

    setState(() {
      try {
        widget.anounce.likeId = "";
        widget.anounce.likesCount =
            (int.parse(widget.anounce.likesCount) - 1).toString();
        reacted = false;
        reacting = false;
      } catch (e) {
        print(e);
      }
    });
  }
}
