// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:get/get.dart";
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/feed/feed_page.dart';

import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/controllers/feed_controller.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/models/post/comment_model.dart';
import 'package:play_pointz/models/post/like_model.dart';
import 'package:play_pointz/models/post/post_model.dart';
import 'package:play_pointz/screens/feed/comments.dart';
import 'package:play_pointz/screens/feed/components/description_container.dart';
import 'package:play_pointz/screens/feed/components/heart_animation_widget.dart';
import 'package:play_pointz/screens/profile/profile.dart';
import 'package:play_pointz/screens/shimmers/shimmer_widget.dart';
import 'package:play_pointz/services/image_cropper/image_cropper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:social_share/social_share.dart';

import 'package:timeago/timeago.dart' as timeago;

import '../../../../Shared Pref/player_pref.dart';
import '../../../../config.dart';
import '../../../../controllers/profile_controller.dart';

class PostCard extends StatefulWidget {
  PostModel postModel;
  int index;
  VoidCallback callbackAction;
  bool insideFreinds;
  bool isFromFeed;
  bool fromNotification;
  ProfileController profileController;
  Function updatePost;
  PostCard({
    Key key,
    this.postModel,
    this.index,
    this.callbackAction,
    this.insideFreinds = false,
    this.isFromFeed,
    this.profileController,
    this.fromNotification,
    this.updatePost,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  IconData icons_unlike = Icons.thumb_up_alt_outlined;
  Color icon_unlike_Clor = AppColors.normalTextColor;
  getShortForm(int number) {
    var shortForm = "";
    if (number != null) {
      if (number < 1000) {
        shortForm = number.toString();
      } else if (number >= 1000 && number < 1000000) {
        shortForm = (number / 1000).toStringAsFixed(1) + "K";
      } else if (number >= 1000000 && number < 1000000000) {
        shortForm = (number / 1000000).toStringAsFixed(1) + "M";
      } else if (number >= 1000000000 && number < 1000000000000) {
        shortForm = (number / 1000000000).toStringAsFixed(1) + "B";
      }
    }
    return shortForm;
  }

  bool loadingdata = false;
  String refarrallink = "";
  var data;
  getRefarralLink() async {
    setState(() {
      loadingdata = true;
    });
    data = await getPlayerPref(key: "playerProfileDetails");

    setState(() {
      refarrallink = "$baseUrl/invite/${data['invite_token']}";

      loadingdata = false;
    });
  }

  bool isProcessing = false;

  bool isWhatsappProcessing = false;

  bool isCommentPressed = false;
  bool updating = false;
  bool isHeartAnimating = false;
  bool isHateAnimating = false;
  int activeIndex = 0;
  final descriptionController = TextEditingController();
  bool isCommenting = false;
  String base64Image;
  final pageController = PageController();
  List<CommentModel> mainComments = [];
  List<Widget> get repostPostWidget => [
        reportElementContainer(),
        submitContainer(),
      ];
  TextEditingController commentController = TextEditingController();
  final commentFormFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final profileController = Get.put(ProfileController());

  Future<void> submitComment() async {
    if (commentController.text != "" && _formKey.currentState.validate()) {
      debugPrint("comment submit called");
      final result = await Api().createComment(
          postId: widget.postModel.id,
          comment: commentController.text,
          commentId: null);

      if (result.done) {
        CommentModel comment = CommentModel(
            sub_comment_count: 0,
            id: result.body.commentId,
            player_id: userController.currentUser.value.id,
            post_id: widget.postModel.id,
            comment: commentController.text,
            comment_id: result.body.commentId,
            date_created: DateTime.now().toString(),
            player_image: userController.currentUser.value.profileImage ??
                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
            player_name: userController.currentUser.value.fullName ?? "No Name",
            is_brand_verified:
                userController.currentUser.value.page_verified ?? false,
            comments: []);
        if (widget.isFromFeed) {
          postController.addComment(widget.index, comment, false);
          widget.postModel = postController.feeds[widget.index]["model"];
        } else if (widget.fromNotification) {
          setState(() {
            widget.postModel.post_comments.add(comment);
            widget.postModel.comments_count += 1;
          });
        } else {
          profileController.addComment(widget.index, comment, false);
          widget.postModel =
              profileController.profileFeed[widget.index]["model"];
        }
        /* widget.isFromFeed
            ? postController.addComment(widget.index, comment, false)
            : profileController.addComment(widget.index, comment, false); */
        debugPrint("comment created succesfully");
        FocusManager.instance.primaryFocus?.unfocus();
        setState(() {
          commentController.clear();
          isCommenting = false;
        });
        widget.callbackAction();
      }
    }
  }

  final postController = Get.put(FeedController());
  final userController = Get.put(UserController());
  bool get checkLiked {
    return widget.postModel.isLike;
  }

  void keyboardHandler() {}
  DefaultCacheManager cacheManager = DefaultCacheManager();

  Future<void> updateFriendStatus() async {
    try {
      postController.followPage(widget.index);

      await Api().addFriends(widget.postModel.player_id);
    } catch (e) {
      debugPrint("update friend status failed from front end side $e");
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    commentFormFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (userController.currentUser.value == null) {
      userController.setCurrentUser();
      setState(() {});
    }
    setState(() {
      mainComments = widget.postModel.post_comments;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.postModel.post_comments.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      if (userController.currentUser.value.id !=
                          widget.postModel.post_comments.last.player_id) {
                        !widget.isFromFeed
                            ? () {}
                            : DefaultRouter.defaultRouter(
                                Profile(
                                    id: widget
                                        .postModel.post_comments.last.player_id,
                                    myProfile: false,
                                    postId: ""),
                                context,
                              );
                      }
                    },
                    child: Text(
                      widget.postModel.post_comments.last.player_name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(" commented"),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ShimmerWidget(
                      width: MediaQuery.of(context).size.width / 10,
                      height: MediaQuery.of(context).size.width / 10,
                      isCircle: true,
                    ),
                    InkWell(
                      onTap: () async {
                        if (!widget.insideFreinds) {
                          if (userController.currentUser.value != null) {
                            if (userController.currentUser.value.id !=
                                widget.postModel.player_id) {
                              !widget.isFromFeed
                                  ? () {}
                                  : DefaultRouter.defaultRouter(
                                      Profile(
                                        id: widget.postModel.player_id,
                                        postId: widget.postModel.id,
                                        myProfile: false,
                                      ),
                                      /* PlayerProfieView(
                                  playerId: widget.postModel.player_id,
                                  postId: widget.postModel.id,
                                ), */
                                      context,
                                    );
                            }
                          } else {
                            await userController.setCurrentUser();
                            if (userController.currentUser.value.id !=
                                widget.postModel.player_id) {
                              !widget.isFromFeed
                                  ? () {}
                                  : DefaultRouter.defaultRouter(
                                      Profile(
                                        id: widget.postModel.player_id,
                                        postId: widget.postModel.id,
                                        myProfile: false,
                                      ),
                                      /*  PlayerProfieView(
                                  playerId: widget.postModel.player_id,
                                  postId: widget.postModel.id,
                                ), */
                                      context,
                                    );
                            }
                          }
                        }
                      },
                      child: Hero(
                        tag: widget.postModel.id,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            cacheManager: CustomCacheManager.instance,
                            imageUrl: widget.postModel.player_image,
                            width: MediaQuery.of(context).size.width / 10,
                            height: MediaQuery.of(context).size.width / 10,
                            fit: BoxFit.fill,
                            fadeInDuration: const Duration(milliseconds: 600),
                            fadeInCurve: Curves.fastOutSlowIn,
                            errorWidget: (a, b, c) {
                              return Image.network(
                                "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg",
                                width: MediaQuery.of(context).size.width / 15,
                                height: MediaQuery.of(context).size.width / 15,
                                fit: BoxFit.fill,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (!widget.insideFreinds) {
                          if (userController.currentUser.value != null) {
                            if (userController.currentUser.value.id !=
                                widget.postModel.player_id) {
                              !widget.isFromFeed
                                  ? () {}
                                  : DefaultRouter.defaultRouter(
                                      Profile(
                                        id: widget.postModel.player_id,
                                        postId: widget.postModel.id,
                                        myProfile: false,
                                      ),
                                      /* PlayerProfieView(
                                  playerId: widget.postModel.player_id,
                                  postId: widget.postModel.id,
                                ), */
                                      context,
                                    );
                            }
                          } else {
                            await userController.setCurrentUser();
                            if (userController.currentUser.value.id !=
                                widget.postModel.player_id) {
                              !widget.isFromFeed
                                  ? () {}
                                  : DefaultRouter.defaultRouter(
                                      Profile(
                                        id: widget.postModel.player_id,
                                        postId: widget.postModel.id,
                                        myProfile: false,
                                      ),
                                      /*  PlayerProfieView(
                                  playerId: widget.postModel.player_id,
                                  postId: widget.postModel.id,
                                ), */
                                      context,
                                    );
                            }
                          }
                        }
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 190,
                        child: RichText(
                            strutStyle: StrutStyle(height: 1.5),
                            textAlign: TextAlign.start,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: toBeginningOfSentenceCase(
                                          widget.postModel.player_name) +
                                      ' ',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey[900],
                                    fontWeight: FontWeight.w600,
                                  )),
                              if (widget.postModel.is_brand_verified)
                                WidgetSpan(
                                  child: Icon(
                                    Icons.verified,
                                    size: 15,
                                    color: AppColors.BUTTON_BLUE_COLLOR,
                                  ),
                                ),
                            ])),
                      ),
                    ),
                    Text(
                      timeago.format(
                          DateTime.parse(widget.postModel.date_updated)),
                      style: TextStyle(
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
                userController.currentUser.value != null
                    ? widget.postModel.player_id !=
                            userController.currentUser.value.id
                        ? widget.postModel.follow_status == 'not follow' &&
                                widget.postModel.is_brand_acc
                            ? InkWell(
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        width: 2,
                                        color: AppColors.PRIMARY_COLOR_LIGHT,
                                      ),
                                    ),
                                    child: Text(
                                      'Follow',
                                      style: TextStyle(
                                          color: AppColors.PRIMARY_COLOR_LIGHT,
                                          fontSize: 10),
                                    )),
                                onTap: () {
                                  updateFriendStatus();
                                },
                              )
                            : SizedBox(
                                width: 25,
                              )
                        : SizedBox(
                            width: 25,
                          )
                    : SizedBox(
                        width: 25,
                      ),
                PopupMenuButton(
                    icon: Container(
                      child: Text(
                        '...',
                        style: TextStyle(
                            color: Color(0xFF536471),
                            fontSize: 30,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    itemBuilder: (context) {
                      return [
                        if (widget.postModel.player_id !=
                            userController.currentUser.value.id)
                          PopupMenuItem(
                            onTap: () {
                              Future.delayed(const Duration(milliseconds: 500))
                                  .then((value) {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) => SizedBox(
                                    height: 500.h,
                                    child: PageView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        controller: pageController,
                                        itemCount: 2,
                                        allowImplicitScrolling: false,
                                        itemBuilder: (context, index) {
                                          return repostPostWidget[index];
                                        }),
                                  ),
                                );
                              });
                            },
                            value: 1,
                            // row has two child icon and text.
                            child: Row(
                              children: [
                                Icon(
                                  Icons.report,
                                  size: 18.sp,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Report",
                                  style: TextStyle(fontSize: 14.sp),
                                )
                              ],
                            ),
                          ),
                        if (widget.postModel.player_id ==
                            userController.currentUser.value.id)
                          PopupMenuItem(
                            onTap: () {
                              updatePost();
                            },
                            value: 1,
                            // row has two child icon and text.
                            child: Row(
                              children: [
                                Icon(Icons.edit),
                                SizedBox(
                                  // sized box with width 10
                                  width: 10,
                                ),
                                Text("Edit")
                              ],
                            ),
                          ),
                        if (widget.postModel.player_id ==
                            userController.currentUser.value.id)
                          PopupMenuItem(
                            onTap: () {
                              //Navigator.pop(context);
                              ValueNotifier<bool> shouldLoad =
                                  ValueNotifier(false);
                              Future.delayed(const Duration(milliseconds: 200))
                                  .then((value) {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => ValueListenableBuilder(
                                      valueListenable: shouldLoad,
                                      builder: (context, bool value, _) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: value
                                              ? []
                                              : [
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  value
                                                      ? const Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                          color: AppColors
                                                              .PRIMARY_COLOR,
                                                        ))
                                                      : Text(
                                                          "Do you want to delete this post ?",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      const SizedBox(
                                                        width: 32,
                                                      ),
                                                      MaterialButton(
                                                        elevation: 0,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                        ),
                                                        color: AppColors
                                                            .PRIMARY_COLOR,
                                                        onPressed: () async {
                                                          setState(() {
                                                            shouldLoad.value =
                                                                true;
                                                          });
                                                          await Api()
                                                              .deletePost(widget
                                                                  .postModel
                                                                  .id);

                                                          if (widget
                                                              .isFromFeed) {
                                                            postController.feeds
                                                                .removeAt(widget
                                                                    .index);
                                                          } else {
                                                            await postController
                                                                .fetchDataFromApi();
                                                            profileController
                                                                .profileFeed
                                                                .removeAt(widget
                                                                    .index);
                                                          }

                                                          Get.back();
                                                          setState(() {
                                                            shouldLoad.value =
                                                                false;
                                                          });
                                                        },
                                                        child: Text(
                                                          "Yes",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      MaterialButton(
                                                        elevation: 0,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                        ),
                                                        color: AppColors
                                                            .PRIMARY_COLOR,
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: Text(
                                                          "No",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 32,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                ],
                                        );
                                      }),
                                );
                              });
                            },
                            value: 1,
                            // row has two child icon and text.
                            child: Row(
                              children: [
                                Icon(Icons.delete),
                                SizedBox(
                                  // sized box with width 10
                                  width: 10,
                                ),
                                Text("Delete")
                              ],
                            ),
                          ),
                      ];
                    })
              ],
            ),
            if (widget.postModel.description != "")
             DescriptionContaine (descrition: widget.postModel.description, MediaUrl: widget.postModel.media_url),
            if (widget.postModel.media_url != null &&
                widget.postModel.media_url != "")
              if (widget.postModel.media_type.toLowerCase() == "image")
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: InkWell(
                        onDoubleTap: !updating
                            ? postReact
                            : () {
                                print("called");
                              },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CachedNetworkImage(
                              cacheManager: CustomCacheManager.instance,
                              imageUrl: widget.postModel.media_url,
                              placeholder: (context, url) => ShimmerWidget(
                                height: MediaQuery.of(context).size.width,
                                width: MediaQuery.of(context).size.width,
                                isCircle: false,
                              ),
                              errorWidget: (context, url, error) =>
                                  ShimmerWidget(
                                height: MediaQuery.of(context).size.width,
                                width: MediaQuery.of(context).size.width,
                                isCircle: false,
                              ),
                            ),
                            // Opacity(
                            //   opacity: isHeartAnimating ? 1 : 0,
                            //   child: HeartAnimationWidget(
                            //     widget: Icon(
                            //       Icons.favorite,
                            //       color: Colors.white,
                            //       size: 80.sp,
                            //     ),
                            //     duration: const Duration(milliseconds: 800),
                            //     isAnimating: isHeartAnimating,
                            //     onEnd: () => (setState(() {
                            //       isHeartAnimating = false;
                            //     })),
                            //   ),
                            // ),
                            // // Dislike
                            // Opacity(
                            //   opacity: isHateAnimating ? 1 : 0,
                            //   child: HeartAnimationWidget(
                            //     widget: Icon(
                            //       Icons.heart_broken,
                            //       color: Colors.white,
                            //       size: 80.sp,
                            //     ),
                            //     duration: const Duration(milliseconds: 800),
                            //     isAnimating: isHateAnimating,
                            //     onEnd: () => (setState(() {
                            //       isHateAnimating = false;
                            //     })),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            const SizedBox(
              height: 16,
            ),
            // Text(
            //   "${widget.postModel.likes_count} likes",
            //   style: TextStyle(
            //     fontWeight: FontWeight.w600,
            //     fontSize: 14.sp,
            //     color: AppColors.normalTextColor,
            //   ),
            // ),
            const SizedBox(
              height: 16,
            ),
            Row(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: !updating ? postReact : null,
                      child: HeartAnimationWidget(
                        widget: Icon(
                          checkLiked
                              ? Icons.thumb_up
                              : Icons.thumb_up_alt_outlined,
                          color: checkLiked
                              ? Colors.blue
                              : AppColors.normalTextColor,
                          size: 19,
                        ),
                        duration: const Duration(milliseconds: 800),
                        isAnimating: isHeartAnimating,
                        onEnd: () => (setState(() {
                          isHeartAnimating = false;
                        })),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    InkWell(
                      onTap: !updating ? postReact : null,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2.5),
                        child: Text(
                          getShortForm(widget.postModel.likes_count) + " Likes",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            color: AppColors.normalTextColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(
                          () => CommentPage(
                            allComentCount: widget.postModel.comments_count,
                            postId: widget.postModel.id,
                            index: widget.index,
                            comments: mainComments,
                            postModel: widget.postModel,
                            // profileController: widget.profileController,
                            fromFeed: widget.isFromFeed,
                            fromNotification: widget.fromNotification,
                          ),
                        );
                      },
                      child: Icon(
                        FontAwesomeIcons.comment,
                        color: AppColors.normalTextColor,
                        size: 19,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(
                          () => CommentPage(
                            allComentCount: widget.postModel.comments_count,
                            postId: widget.postModel.id,
                            index: widget.index,
                            comments: mainComments,
                            postModel: widget.postModel,
                            // profileController: widget.profileController,
                            fromFeed: widget.isFromFeed,
                            fromNotification: widget.fromNotification,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2.5),
                        child: Text(
                          "${widget.postModel.comments_count} Comments",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            color: AppColors.normalTextColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    widget.postModel.media_url == ""
                        ? GestureDetector(
                            onTap: () async {
                              getRefarralLink();
                              setState(() {
                                isProcessing = true;
                              });

                              // Introduce a delay (e.g., 2 seconds)
                              await Future.delayed(Duration(seconds: 2));

                              final downloadlink =
                                  'https://play.google.com/store/apps/details?id=com.avanux.playpointz&hl=en&gl=US';
                              await Share.share(widget.postModel.description +
                                  '\n\n' +
                                  widget.postModel.media_url.toString() +
                                  '\n\n' +
                                  'Download Link => $refarrallink');

                              setState(() {
                                // Reset the flag to indicate that the process is completed
                                isProcessing = false;
                              });
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Your regular GestureDetector child goes here
                                isProcessing
                                    ? Center(
                                        child: Container(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            )),
                                      )
                                    : Icon(
                                        FontAwesomeIcons.share,
                                        color: AppColors.normalTextColor
                                            .withOpacity(0.8),
                                        size: 19,
                                      ),

                                // Show circular progress indicator when isProcessing is true
                              ],
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              getRefarralLink();
                              setState(() {
                                isProcessing = true;
                              });

                              // Introduce a delay (e.g., 2 seconds)
                              await Future.delayed(Duration(seconds: 2));

                              final downloadlink =
                                  'https://play.google.com/store/apps/details?id=com.avanux.playpointz&hl=en&gl=US';
                              final urlImage = widget.postModel.media_url;
                              final response =
                                  await http.get(Uri.parse(urlImage));
                              final bytes = response.bodyBytes;
                              final temp = await getTemporaryDirectory();
                              final path = '${temp.path}/image.jpg';
                              Io.File(path).writeAsBytesSync(bytes);

                              // Share the files
                              await Share.shareFiles([path],
                                  text:
                                      widget.postModel.description.toString() +
                                          '\n\n' +
                                          'Download Link => $refarrallink');

                              // Hide the circular progress indicator
                              setState(() {
                                // Reset the flag to indicate that the process is completed
                                isProcessing = false;
                              });
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                isProcessing
                                    ? Center(
                                        child: Container(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            )),
                                      )
                                    : Icon(
                                        FontAwesomeIcons.share,
                                        color: AppColors.normalTextColor
                                            .withOpacity(0.8),
                                        size: 19,
                                      ),
                              ],
                            ),
                          ),
                    widget.postModel.media_url == ""
                        ? GestureDetector(
                            onTap: () async {
                              getRefarralLink();
                              setState(() {
                                isProcessing = true;
                              });
                              final downloadlink =
                                  'https://play.google.com/store/apps/details?id=com.avanux.playpointz&hl=en&gl=US';

                              await Future.delayed(Duration(seconds: 2));

                              await Share.share(widget.postModel.description +
                                  '\n\n' +
                                  widget.postModel.media_url.toString() +
                                  '\n\n' +
                                  'Download Link => $refarrallink');

                              setState(() {
                                isProcessing = false;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2.5, left: 8),
                              child: Text(
                                isProcessing ? "" : "Share",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                  color: AppColors.normalTextColor,
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              getRefarralLink();
                              setState(() {
                                isProcessing = true;
                              });

                              // Introduce a delay (e.g., 2 seconds)
                              await Future.delayed(Duration(seconds: 2));

                              final downloadlink =
                                  'https://play.google.com/store/apps/details?id=com.avanux.playpointz&hl=en&gl=US';
                              final urlImage = widget.postModel.media_url;
                              final response =
                                  await http.get(Uri.parse(urlImage));
                              final bytes = response.bodyBytes;
                              final temp = await getTemporaryDirectory();
                              final path = '${temp.path}/image.jpg';
                              File(path).writeAsBytesSync(bytes);

                              // Share the files
                              await Share.shareFiles([path],
                                  text:
                                      widget.postModel.description.toString() +
                                          '\n\n' +
                                          'Download Link => $refarrallink');

                              // Hide the circular progress indicator
                              setState(() {
                                // Reset the flag to indicate that the process is completed
                                isProcessing = false;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2.5, left: 8),
                              child: Text(
                                isProcessing ? "" : "Share",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                  color: AppColors.normalTextColor,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),

                ///Whats app Share ////////////////////////////////////////////////////////////////////////////////////////////
                Row(
                  children: [
                    widget.postModel.media_url == ""
                        ? GestureDetector(
                            onTap: () async {
                              getRefarralLink();
                              setState(() {
                                isWhatsappProcessing = true;
                              });
                              final downloadlink =
                                  'https://play.google.com/store/apps/details?id=com.avanux.playpointz&hl=en&gl=US';

                              await Future.delayed(Duration(seconds: 2));

                              await SocialShare.shareWhatsapp(
                                  widget.postModel.description +
                                      '\n\n' +
                                      widget.postModel.media_url.toString() +
                                      '\n\n' +
                                      'Download Link => $refarrallink');

                              setState(() {
                                isWhatsappProcessing = false;
                              });
                            },
                            child: isWhatsappProcessing
                                ? Center(
                                    child: Container(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        )),
                                  )
                                : Icon(
                                    FontAwesomeIcons.whatsapp,
                                    color: AppColors.normalTextColor
                                        .withOpacity(0.8),
                                    size: 20,
                                  ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              getRefarralLink();
                              setState(() {
                                isWhatsappProcessing = true;
                              });

                              // Introduce a delay (e.g., 2 seconds)
                              await Future.delayed(Duration(seconds: 2));

                              final downloadlink =
                                  'https://play.google.com/store/apps/details?id=com.avanux.playpointz&hl=en&gl=US';
                              final urlImage = widget.postModel.media_url;
                              final response =
                                  await http.get(Uri.parse(urlImage));
                              final bytes = response.bodyBytes;
                              final temp = await getTemporaryDirectory();
                              final path = '${temp.path}/image.jpg';
                              File(path).writeAsBytesSync(bytes);

                              // Share the files
                              await SocialShare.shareWhatsapp(
                                  widget.postModel.description.toString() +
                                      '\n\n' +
                                      widget.postModel.media_url.toString() +
                                      '\n\n' +
                                      'Download Link => $refarrallink');

                              // Hide the circular progress indicator
                              setState(() {
                                // Reset the flag to indicate that the process is completed
                                isWhatsappProcessing = false;
                              });
                            },
                            child: isWhatsappProcessing
                                ? Center(
                                    child: Container(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        )),
                                  )
                                : Icon(
                                    FontAwesomeIcons.whatsapp,
                                    color: AppColors.normalTextColor
                                        .withOpacity(0.8),
                                    size: 20,
                                  ),
                          ),
                    widget.postModel.media_url == ""
                        ? GestureDetector(
                            onTap: () async {
                              getRefarralLink();
                              setState(() {
                                isWhatsappProcessing = true;
                              });
                              final downloadlink =
                                  'https://play.google.com/store/apps/details?id=com.avanux.playpointz&hl=en&gl=US';

                              await Future.delayed(Duration(seconds: 2));

                              await SocialShare.shareWhatsapp(
                                  widget.postModel.description +
                                      '\n\n' +
                                      widget.postModel.media_url.toString() +
                                      '\n\n' +
                                      'Download Link => $refarrallink');

                              setState(() {
                                isWhatsappProcessing = false;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2.5, left: 8),
                              child: Text(
                                isWhatsappProcessing ? "" : "Send",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                  color: AppColors.normalTextColor,
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              getRefarralLink();
                              setState(() {
                                isWhatsappProcessing = true;
                              });

                              // Introduce a delay (e.g., 2 seconds)
                              await Future.delayed(Duration(seconds: 2));

                              final downloadlink =
                                  'https://play.google.com/store/apps/details?id=com.avanux.playpointz&hl=en&gl=US';
                              final urlImage = widget.postModel.media_url;
                              final response =
                                  await http.get(Uri.parse(urlImage));
                              final bytes = response.bodyBytes;
                              final temp = await getTemporaryDirectory();
                              final path = '${temp.path}/image.jpg';
                              File(path).writeAsBytesSync(bytes);

                              // Share the files
                              await SocialShare.shareWhatsapp(
                                  widget.postModel.media_url.toString() +
                                      '\n\n' +
                                      widget.postModel.description.toString() +
                                      '\n\n' +
                                      'Download Link => $refarrallink');

                              // Hide the circular progress indicator
                              setState(() {
                                // Reset the flag to indicate that the process is completed
                                isWhatsappProcessing = false;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2.5, left: 8),
                              child: Text(
                                isWhatsappProcessing ? "" : "Send",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                  color: AppColors.normalTextColor,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
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
                        ? "Enter a comment"
                        : null
                    : null,
                onFieldSubmitted: (value) async {
                  await submitComment();
                },
                maxLength: 100,
                buildCounter: (BuildContext context,
                        {int currentLength, int maxLength, bool isFocused}) =>
                    null,
                decoration: InputDecoration(
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                            await submitComment();
                            setState(() {
                              isCommenting = false;
                            });
                          },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: widget.postModel.post_comments.isNotEmpty ? 16 : 4,
            ),
            if (widget.postModel.post_comments.isNotEmpty)
              InkWell(
                onTap: () {
                  Get.to(
                    () => CommentPage(
                      allComentCount: widget.postModel.comments_count,
                      postId: widget.postModel.id,
                      index: widget.index,
                      comments: mainComments,
                      postModel: widget.postModel,
                      fromFeed: widget.isFromFeed,
                      fromNotification: widget.fromNotification,
                      //profileController: widget.profileController,
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
                          widget.postModel.post_comments.first.player_image ??
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
                              widget.postModel.post_comments.first.comment,
                              expandText: 'see more',
                              collapseText: 'see less',
                              maxLines: 2,
                              linkColor: Colors.blue,
                            ),
                            Text(
                              timeago.format(
                                DateTime.parse(
                                  widget.postModel.post_comments.first
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
            SizedBox(
              height: widget.postModel.post_comments.isNotEmpty ? 8 : 2,
            ),
            if (widget.postModel.comments_count > 1)
              InkWell(
                onTap: () {
                  Get.to(
                    () => CommentPage(
                      allComentCount: widget.postModel.comments_count,
                      postId: widget.postModel.id,
                      index: widget.index,
                      comments: mainComments,
                      postModel: widget.postModel,
                      fromNotification: widget.fromNotification,
                      //profileController: widget.profileController,
                      fromFeed: widget.isFromFeed,
                    ),
                  );
                },
                child: Text(
                  "View all ${widget.postModel.comments_count} comments ...",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  ValueNotifier<bool> shouldLoad = ValueNotifier(false);
  String reason = "";

  Container submitContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      height: 100.h,
      width: MediaQuery.of(context).size.width / 1.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            height: 16,
          ),
          Text(
            "Report Post",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Divider(
              color: AppColors.normalTextColor,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Expanded(
            child: Lottie.asset("assets/lottie/report.json"),
          ),
          Text(
            "Reason : $reason",
            style: TextStyle(
              fontSize: 16.sp,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          ValueListenableBuilder<bool>(
              valueListenable: shouldLoad,
              builder: (context, bool value, _) {
                return InkWell(
                  onTap: () async {
                    if (!value) {
                      setState(() {
                        shouldLoad.value = true;
                      });
                      await Api().reportPost(widget.postModel.id, reason);
                      setState(() {
                        shouldLoad.value = false;
                      });
                      Navigator.pop(context);
                      Get.snackbar(
                          "Hey ${userController.currentUser.value.fullName}",
                          "Post reported succesfully");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: kToolbarHeight,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: !value
                        ? Text(
                            "Report",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.sp,
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  Container reportElementContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      height: 100.h,
      width: MediaQuery.of(context).size.width / 1.3,
      child: ListView(
        // mainAxisSize: MainAxisSize.min,
        children: [
          reportReasonElement("It's a spam"),
          Divider(),
          reportReasonElement("Nudity or sexual activity"),
          Divider(),
          reportReasonElement("Hate speech or symbols"),
          Divider(),
          reportReasonElement("Violence or dangerous organizations"),
          Divider(),
          reportReasonElement("Sale or illegal regulated goods"),
          Divider(),
          reportReasonElement("Bullying or harassment"),
          Divider(),
          reportReasonElement("Intellectual property violation"),
          Divider(),
          reportReasonElement("Suicide or self injury"),
        ],
      ),
    );
  }

  ListTile reportReasonElement(String value) {
    return ListTile(
      onTap: () {
        setState(() {
          activeIndex = 1;
          reason = value;
        });
        pageController.animateToPage(activeIndex,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInCubic);
      },
      title: Text(value),
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }

  ValueNotifier<bool> uploadLoad = ValueNotifier(false);
  ValueNotifier<Io.File> pFile = ValueNotifier(null);
  void updatePost() {
    setState(() {
      descriptionController.text = widget.postModel.description;
    });
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      return showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) => updatePostWidget());
    });
  }

  Widget updatePostWidget() => Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width / 1.2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: kToolbarHeight,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.cancel),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Center(
                      child: Text(
                        "Update Post",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ValueListenableBuilder(
                              valueListenable: uploadLoad,
                              builder: (context, bool value, _) {
                                return value
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.PRIMARY_COLOR,
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: MaterialButton(
                                          elevation: 0,
                                          minWidth: kToolbarHeight,
                                          color: AppColors.PRIMARY_COLOR,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          onPressed: () async {
                                            setState(() {
                                              uploadLoad.value = true;
                                            });
                                            await Api().updatePost(
                                              postID: widget.postModel.id,
                                              image: base64Image,
                                              description:
                                                  descriptionController.text,
                                              mediaUrl:
                                                  widget.postModel.media_url,
                                              originalUrl:
                                                  widget.postModel.original_url,
                                            );
                                            if (widget.isFromFeed) {
                                              await postController
                                                  .fetchDataFromApi();
                                            } else {
                                              await postController
                                                  .fetchDataFromApi();
                                              widget.updatePost();
                                            }

                                            Navigator.pop(context);
                                            setState(() {
                                              uploadLoad.value = false;
                                              pFile.value = null;
                                              descriptionController.clear();
                                              base64Image = null;
                                              imageFile = null;
                                              base64Image2 = null;
                                            });
                                          },
                                          child: Text(
                                            "Update",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ));
                              }),
                        ],
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                maxLines: 5,
                minLines: 1,
                controller: descriptionController,
                decoration: InputDecoration(
                  fillColor: AppColors.scaffoldBackGroundColor,
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            ValueListenableBuilder(
                valueListenable: pFile,
                builder: (context, Io.File value, _) {
                  return SizedBox(
                    height: 200.h,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      child: value == null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: CachedNetworkImage(
                                cacheManager: CustomCacheManager.instance,
                                imageUrl: widget.postModel.media_url,
                                height: MediaQuery.of(context).size.height / 8,
                                placeholder: (context, url) => ShimmerWidget(
                                  width: double.infinity,
                                  height: 180.h,
                                  isCircle: false,
                                ),
                                fit: BoxFit.fitWidth,
                                width: double.infinity,
                                errorWidget: (a, b, c) {
                                  return SizedBox(width: 0, height: 0);
                                },
                              ),
                            )
                          : Stack(
                              children: [
                                Image.file(
                                  value,
                                  // height:
                                  //  MediaQuery.of(context).size.height / 8,
                                  fit: BoxFit.fitHeight,
                                  width: double.infinity,
                                ),
                              ],
                            ),
                    ),
                  );
                }),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32),
              child: MaterialButton(
                minWidth: double.infinity,
                height: kToolbarHeight,
                elevation: 0,
                onPressed: () async {
                  await updateImage(context);
                },
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: BorderSide(
                    color: AppColors.PRIMARY_COLOR,
                  ),
                ),
                child: Text("Update Image"),
              ),
            ),
          ],
        ),
      );

  Future<void> updateImage(BuildContext context) async {
    try {
      _showChoiceDialog(context);
    } catch (e) {
      debugPrint("update image failed $e");
    }
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
                    },
                    title: const Text("Gallery"),
                    leading: const Icon(
                      Icons.account_box,
                      color: Colors.blue,
                    ),
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                    },
                    title: Text("Camera"),
                    leading: const Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  var bytes;

  void _openGallery(BuildContext context) async {
    try {
      final pickedFile = await ImageCropperService.pickMedia(
        cropImage: ImageCropperService.cropFreeSizeImage,
        isGallery: true,
        isProfilePicure: true,
      );
      if (pickedFile != null) {
        bytes = await Io.File(pickedFile.path).readAsBytes();

        setState(() {
          imageFile = PickedFile(pickedFile.path);
          base64Image = base64Encode(bytes);
          pFile.value = Io.File(imageFile.path);
        });
        debugPrint("---------------- picked file is set succesfullly");
      } else {
        debugPrint("---------------- picked file is null");
      }
      Navigator.pop(context);
    } catch (e) {
      debugPrint("------------------------------open gallery failed $e");
    }
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    bytes = await Io.File(pickedFile.path).readAsBytes();

    setState(() {
      imageFile = PickedFile(pickedFile.path);
      base64Image = base64Encode(bytes);
      pFile.value = Io.File(imageFile.path);
    });
    Navigator.pop(context);
  }

  void postReact() async {
    if (userController.currentUser.value == null) {
      await userController.setCurrentUser();
      setState(() {});
    }

    if (!updating) {
      print("=========-----------incheck liked :$checkLiked");
      if (checkLiked) {
        setState(() {
          updating = true;
          isHateAnimating = true;
        });

        try {
          await Api().removeLike(postId: widget.postModel.like_id);
          if (widget.isFromFeed) {
            postController.removeLike(
              widget.index,
            );
          } else if (widget.fromNotification) {
            setState(() {
              widget.postModel.likes_count -= 1;
              widget.postModel.isLike = false;
            });
          } else {
            profileController.removeLike(widget.index);
            widget.postModel =
                profileController.profileFeed[widget.index]["model"];
          }

          debugPrint("Remove liked");
          setState(() {
            updating = false;
            print("=========-----------unliked$updating");
          });
        } catch (err) {
          debugPrint("remove like api response failed $err");
        }
      } else {
        debugPrint("liked");
        setState(() {
          updating = true;
          isHeartAnimating = true;
        });

        PostLikeModel like = await Api().postLike(postId: widget.postModel.id);
        if (widget.isFromFeed) {
          postController.addLike(widget.index, like);
        } else if (widget.fromNotification) {
          setState(() {
            widget.postModel.isLike = true;
            widget.postModel.likes_count += 1;
          });
        } else {
          profileController.addLike(widget.index, like);
          widget.postModel =
              profileController.profileFeed[widget.index]["model"];
        }

        setState(() {
          updating = false;
          print("=========-----------liked$updating");
        });
      }
    }
  }
}
