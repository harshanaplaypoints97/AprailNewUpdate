import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/controllers/feed_controller.dart';
import 'package:play_pointz/controllers/profile_controller.dart';
import 'package:play_pointz/models/notificaitons/announce_comment_model.dart';
import 'package:play_pointz/models/notificaitons/announce_like_model.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/feed/announcement_comment.dart';
import 'package:play_pointz/screens/feed/components/description_container.dart';
import 'package:play_pointz/screens/feed/components/heart_animation_widget.dart';
import 'package:play_pointz/screens/home/home_page.dart';
import 'package:play_pointz/screens/profile/profile.dart';
import 'package:play_pointz/screens/register/terms_conditions.dart';
import 'package:play_pointz/widgets/common/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/NewModelsV2/feed/anouncement_model.dart';
import '../../../widgets/play/widgets/video_player.dart';
import '../../shimmers/shimmer_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Anouncement extends StatefulWidget {
  AnouncementModel anounce;
  bool animating;
  bool animatingCongrats;
  int index;
  bool isFromFeed;
  // ProfileController profileController;
  Anouncement({
    this.anounce,
    this.animating,
    this.animatingCongrats,
    this.index,
    this.isFromFeed,
    // this.profileController,
  });

  @override
  State<Anouncement> createState() => _AnouncementState();
}

bool updating = false;
bool congrats = false;
bool goodluck = false;
bool isHeartAnimating = false;
bool isHateAnimating = false;

AnimationController _animationControllerCongrats;
AnimationController _animationControllerGoodLuck;

class _AnouncementState extends State<Anouncement>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  TextEditingController commentController = TextEditingController();
  final commentFormFocusNode = FocusNode();
  final profileController = Get.put(ProfileController());
  bool isCommenting = false;

  @override
  void initState() {
    _animationControllerCongrats =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    _animationControllerGoodLuck =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    setState(() {
      reacted = widget.anounce.isliked;
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.animating = false;
    widget.animatingCongrats = false;

    super.dispose();
  }

  redirectPage(String redirectUrl) async {
    String url =
        redirectUrl.contains("http") ? redirectUrl : "https://${redirectUrl}";
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {}
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
              widget.anounce.name != "Purchase item"
                  ? nomalAnouncement()
                  : winProductAnounce(
                      widget.anounce.mediaUrl,
                      widget.anounce.mediaUrl,
                      widget.anounce.name,
                      size,
                    ),
              SizedBox(
                height: 16.h,
              ),
              widget.anounce.name != "Purchase item"
                  ? Container()
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (!updating) {
                                    setState(() {
                                      updating = true;
                                    });
                                    if (reacted) {
                                      Removelike(
                                          announcementId: widget.anounce.id);
                                      setState(() {
                                        reacted = false;
                                        isHateAnimating = true;
                                        updating = false;
                                      });
                                    } else {
                                      Submitlike(widget.anounce.id);
                                      setState(() {
                                        reacted = true;
                                        isHeartAnimating = true;
                                        updating = false;
                                      });
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
                              Text(
                                  widget.anounce.likesCount.toString() +
                                      " likes",
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(
                                () => AnnounceCommentPage(
                                  announcetId: widget.anounce.id,
                                  index: widget.index,
                                  allCommentCount: widget.anounce.commentsCount,
                                  announce: widget.anounce,
                                  fromFeed: widget.isFromFeed,
                                  //  profileController: widget.profileController,
                                ),
                              );
                            },
                            child: Text(
                                widget.anounce.commentsCount.toString() +
                                    " Wishes",
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500)),
                          )
                        ],
                      ),
                    ),
              widget.anounce.name != "Purchase item"
                  ? Container()
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: commentController,
                            focusNode: commentFormFocusNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.streetAddress,
                            validator: (val) => val != null
                                ? val.isEmpty
                                    ? "Comment here..."
                                    : null
                                : null,
                            onFieldSubmitted: (value) async {
                              setState(() {
                                isCommenting = true;
                              });
                              await submitTypedWishes(
                                  commentController.text, widget.anounce.id);
                              setState(() {
                                isCommenting = false;
                              });
                            },
                            maxLength: 100,
                            buildCounter: (BuildContext context,
                                    {int currentLength,
                                    int maxLength,
                                    bool isFocused}) =>
                                null,
                            decoration: InputDecoration(
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              fillColor: AppColors.scaffoldBackGroundColor,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText: "Comment here ...",
                              hintStyle: TextStyle(fontSize: 14.sp),
                              suffixIcon: InkWell(
                                child: Icon(
                                  Icons.send,
                                  color: isCommenting
                                      ? Colors.grey
                                      : AppColors.PRIMARY_COLOR_LIGHT,
                                ),
                                onTap: isCommenting
                                    ? () {}
                                    : () async {
                                        setState(() {
                                          isCommenting = true;
                                        });
                                        await submitTypedWishes(
                                            commentController.text,
                                            widget.anounce.id);

                                        setState(() {
                                          isCommenting = false;
                                        });
                                      },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ]),
                    ),
              if (widget.anounce.announcement_comments.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    onTap: () {
                      Get.to(
                        () => AnnounceCommentPage(
                          announcetId: widget.anounce.id,
                          index: widget.index,
                          allCommentCount: widget.anounce.commentsCount,
                          announce: widget.anounce,
                          fromFeed: widget.isFromFeed,
                          //  profileController: widget.profileController,
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
                              widget.anounce.announcement_comments.first
                                      .player_image ??
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
                                  widget.anounce.announcement_comments.first
                                      .comment,
                                  expandText: 'see more',
                                  collapseText: 'see less',
                                  maxLines: 2,
                                  linkColor: Colors.blue,
                                ),
                                Text(
                                  timeago.format(
                                    DateTime.parse(
                                      widget.anounce.announcement_comments.first
                                          .date_created,
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
                ),
              if (widget.anounce.announcement_comments.length > 1)
                SizedBox(
                  height: 8,
                ),
              if (widget.anounce.commentsCount > 1)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: InkWell(
                    onTap: () {
                      Get.to(
                        () => AnnounceCommentPage(
                          announcetId: widget.anounce.id,
                          index: widget.index,
                          allCommentCount: widget.anounce.commentsCount,
                          announce: widget.anounce,
                          fromFeed: widget.isFromFeed,
                          //profileController: widget.profileController,
                        ),
                      );
                    },
                    child: Text(
                      "View all ${widget.anounce.commentsCount} Wishes ...",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              widget.anounce.redirectUrl == 'PLAY' ||
                      widget.anounce.redirectUrl == 'STORE' ||
                      widget.anounce.redirectUrl == 'TERMS_AND_CONDITIONS' ||
                      widget.anounce.redirectUrl == 'CONNECT' ||
                      widget.anounce.redirectUrl.toString().contains("http")
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Spacer(),
                          widget.anounce.redirectUrl == '' ||
                                  widget.anounce.redirectUrl == null ||
                                  widget.anounce.redirectUrl == 'undefined'
                              ? Container()
                              : InkWell(
                                  onTap: () async {
                                    /*  widget.anounce.redirectUrl == "PLAY" ||
                                            widget.anounce.redirectUrl == "PLAY"
                                        ? socket.off('new-popup-banners')
                                        : null; */
                                    widget.anounce.redirectUrl == 'PLAY'
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) => HomePage(
                                                      activeIndex: 1,
                                                    ))))
                                        : widget.anounce.redirectUrl == 'STORE'
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        HomePage(
                                                          activeIndex: 2,
                                                        ))))
                                            : widget.anounce.redirectUrl ==
                                                    'CONNECT'
                                                ? Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: ((context) =>
                                                            HomePage(
                                                              activeIndex: 3,
                                                            ))))
                                                : widget.anounce.redirectUrl ==
                                                        'TERMS_AND_CONDITIONS'
                                                    ? DefaultRouter
                                                        .defaultRouter(
                                                            TermsConditions(),
                                                            context)
                                                    : widget.anounce.redirectUrl
                                                            .contains('http')
                                                        ? redirectPage(widget
                                                            .anounce
                                                            .redirectUrl)
                                                        : null;
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: Colors.grey[300],
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      widget.anounce.redirectUrl
                                              .contains('http')
                                          ? "Learn More"
                                          : "Go to Page",
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    )
                  : Container(),
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

  Widget nomalAnouncement() {
    return Container(
      child: widget.anounce.mediaType == "Video"
          ? SizedBox(
              child: widget.anounce.mediaUrl != null
                  ? SamplePlayer(url: widget.anounce.mediaUrl)
                  : const SizedBox(),
            )
          : widget.anounce.mediaType == "Youtube"
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: YoutubePlayer(
                    // controller: _controller,
                    controller: YoutubePlayerController(
                      initialVideoId:
                          YoutubePlayer.convertUrlToId(widget.anounce.mediaUrl),
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
              : widget.anounce.mediaType != "Text"
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedNetworkImage(
                        cacheManager: CustomCacheManager.instance,
                        imageUrl: widget.anounce.mediaUrl,
                        width: MediaQuery.of(context).size.width,
                        imageBuilder: (context, url) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Image(image: url),
                            ],
                          );
                        },
                        placeholder: (a, b) {
                          return ShimmerWidget(
                            width: MediaQuery.of(context).size.width,
                            height: 200.h,
                            isCircle: false,
                          );
                        },
                        fit: BoxFit.fitWidth,
                        errorWidget: (a, b, c) {
                          return SizedBox(
                            width: 10.w,
                            height: 10.h,
                          );
                        },
                      ),
                    )
                  : null,
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
            ? !widget.isFromFeed
                ? () {}
                : DefaultRouter.defaultRouter(
                    Profile(
                      id: widget.anounce.playerId,
                      myProfile: false,
                      postId: "",
                    ),
                    /*  PlayerProfieView(
                  playerId: widget.anounce.playerId,
                ), */
                    context,
                  )
            : null;
      },
      onDoubleTap: () {
        if (!updating) {
          setState(() {
            updating = true;
          });
          if (reacted) {
            Removelike(announcementId: widget.anounce.id);
            setState(() {
              reacted = false;
              isHateAnimating = true;
              updating = false;
            });
          } else {
            Submitlike(widget.anounce.id);
            setState(() {
              reacted = true;
              isHeartAnimating = true;
              updating = false;
            });
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
            // height: size.height*0.24,
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
                    widget.anounce.PlayerName.split(" ").elementAt(0),
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
                                  widget.anounce.ItemName ?? "This Item",
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    if (!widget.animating) {
                      final audio = AudioPlayer();
                      audio.play(AssetSource("audio/goodluck.mp3"));
                      setState(() {
                        widget.animating = true;
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
                      final audio = AudioPlayer();
                      audio.play(AssetSource("audio/congratulation.mp3"));
                      setState(() {
                        widget.animating = true;
                        widget.animatingCongrats = true;
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
          //Lottie.asset("assets/lottie/cele.json"),
        ],
      ),
    );
  }

  Future<void> SubmitWishes(String wish, String id) async {
    final result = await Api().createWish(announcementId: id, comment: wish);
    if (result.done) {
      AnnounceCommentModel comment = AnnounceCommentModel(
          subCommentCount: 0,
          id: result.body.id,
          player_id: userController.currentUser.value.id,
          announcement_id: id,
          comment: wish,
          comment_id: result.body.commentId,
          date_created: result.body.dateCreated ?? DateTime.now().toString(),
          player_image: userController.currentUser.value.profileImage ??
              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
          player_name: userController.currentUser.value.fullName ?? "No Name",
          is_brand_verified:
              userController.currentUser.value.page_verified ?? false,
          comments: []);

      if (widget.isFromFeed) {
        postController.addAnnounceComment(widget.index, comment, false);
        widget.anounce = postController.feeds[widget.index]["model"];
      } else {
        profileController.addAnnounceComment(widget.index, comment, false);
        widget.anounce = profileController.profileFeed[widget.index]["model"];
      }
    }
  }

  final postController = Get.put(FeedController());

  Future<void> submitTypedWishes(String wish, String id) async {
    final result = await Api().createWish(announcementId: id, comment: wish);
    if (result.done) {
      AnnounceCommentModel comment = AnnounceCommentModel(
          subCommentCount: 0,
          id: result.body.id,
          player_id: userController.currentUser.value.id,
          announcement_id: id,
          comment: commentController.text,
          comment_id: result.body.commentId,
          date_created: result.body.dateCreated ?? DateTime.now().toString(),
          player_image: userController.currentUser.value.profileImage ??
              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
          player_name: userController.currentUser.value.fullName ?? "No Name",
          is_brand_verified:
              userController.currentUser.value.page_verified ?? false,
          comments: []);
      if (widget.isFromFeed) {
        postController.addAnnounceComment(widget.index, comment, false);
        widget.anounce = postController.feeds[widget.index]["model"];
      } else {
        profileController.addAnnounceComment(widget.index, comment, false);
        widget.anounce = profileController.profileFeed[widget.index]["model"];
      }

      setState(() {
        commentController.clear();
        widget.anounce.commentsCount++;
      });
    }
  }

  Future<void> Submitlike(String id) async {
    AnnounceLikeModel like = await Api().announcementLike(announcementId: id);

    setState(() {
      if (widget.isFromFeed) {
        postController.feeds[widget.index]["model"].likesCount += 1;
      } else {
        profileController.profileFeed[widget.index]["model"].likesCount += 1;
      }
      // widget.anounce.likesCount += 1;
    });
  }

  Future<void> Removelike({String announcementId}) async {
    AnnounceLikeModel like =
        await Api().deleteAnnouncementLike(announcementId: announcementId);
    setState(() {
      if (widget.isFromFeed) {
        postController.feeds[widget.index]["model"].likesCount -= 1;
      } else {
        profileController.profileFeed[widget.index]["model"].likesCount -= 1;
      }
      // widget.anounce.likesCount -= 1;
    });
  }
}
