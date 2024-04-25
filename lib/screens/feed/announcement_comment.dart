// ignore_for_file: unnecessary_const

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/controllers/feed_controller.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/models/NewModelsV2/feed/announcement_comments.dart';
import 'package:play_pointz/models/NewModelsV2/feed/announcement_sub_comments.dart';
import 'package:play_pointz/models/NewModelsV2/feed/anouncement_model.dart';
import 'package:play_pointz/models/notificaitons/announce_comment_model.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/profile/profile.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../Api/ApiV2/api_V2.dart';
import '../../controllers/profile_controller.dart';

class AnnounceCommentPage extends StatefulWidget {
  AnouncementModel announce;
  final String announcetId;
  final int allCommentCount;
  final bool fromFeed;
  //ProfileController profileController;
  final int index;

  AnnounceCommentPage({
    Key key,
    this.announcetId,
    this.index,
    this.allCommentCount,
    this.announce,
    this.fromFeed,
    //this.profileController,
  }) : super(key: key);

  @override
  State<AnnounceCommentPage> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<AnnounceCommentPage> {
  bool btnLoading = false;
  bool isCommenting = false;
  bool _isCommenting = false;
  bool loadingMoreData = false;
  bool isLoading = false;
  bool isFinished = false;
  int limit = 10;
  int offset = 1;
  int commentcount = 1;
  Map<String, int> subcommentOffset = {};
  Map<String, int> subcommentcount = {};

  final TextEditingController commentController = TextEditingController();
  final TextEditingController replyController = TextEditingController();
  final profileController = Get.put(ProfileController());
  final userController = Get.put(UserController());

  final postController = Get.put(FeedController());

  final listController = ScrollController();

  String repId = '';
  String subCommenting = '';
  int repIndex;

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  Future<void> submitComment() async {
    if (commentController.text != "" && _formKey.currentState.validate()) {
      final result = await Api().createWish(
          announcementId: widget.announcetId,
          comment: commentController.text,
          commentId: null);

      if (result.done) {
        AnnounceCommentModel comment = AnnounceCommentModel(
            subCommentCount: 0,
            id: result.body.id,
            player_id: userController.currentUser.value.id,
            announcement_id: widget.announcetId,
            comment: commentController.text,
            comment_id: result.body.commentId,
            date_created: result.body.dateCreated ?? DateTime.now().toString(),
            player_image: userController.currentUser.value.profileImage ??
                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
            player_name: userController.currentUser.value.fullName ?? "No Name",
            is_brand_verified:
                userController.currentUser.value.page_verified ?? false,
            comments: []);
// change for annconce

        if (widget.fromFeed) {
          postController.addAnnounceComment(widget.index, comment, false);
          widget.announce = postController.feeds[widget.index]["model"];
        } else {
          profileController.addAnnounceComment(widget.index, comment, false);

          widget.announce =
              profileController.profileFeed[widget.index]["model"];
        }
        debugPrint("comment created succesfully");
        setState(() {
          commentController.clear();
          isCommenting = false;
          _isCommenting = false;
          offset += 1;
          commentcount += 1;
        });
        FocusManager.instance.primaryFocus?.unfocus();
        listController.animateTo(
          listController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500),
        );
      }
    } else {
      print("form not validated");
    }
  }

  Future<void> submitReplyComment() async {
    if (replyController.text != "") {
      final result = await Api().createWish(
          announcementId: widget.announcetId,
          comment: replyController.text,
          commentId: repId);

      if (result.done) {
        AnnounceComments subComment = AnnounceComments(
          id: result.body.id,
          playerId: userController.currentUser.value.id,
          announceId: widget.announcetId,
          comment: replyController.text,
          commentId: result.body.commentId,
          dateCreated: result.body.dateCreated ?? DateTime.now().toString(),
          playerImage: userController.currentUser.value.profileImage ??
              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
          playerName: userController.currentUser.value.fullName ?? "No Name",
          is_brand_verified:
              userController.currentUser.value.page_verified ?? false,
        );

// change to announce

        if (widget.fromFeed) {
          postController.addReplyAnnounceComment(
              widget.index, repIndex, subComment, false);
          widget.announce = postController.feeds[widget.index]["model"];
        } else {
          profileController.addReplyAnnounceComment(
              widget.index, repIndex, subComment, false);

          widget.announce =
              profileController.profileFeed[widget.index]["model"];
        }
        debugPrint("comment created succesfully");
        setState(() {
          replyController.clear();
          isCommenting = false;
          _isCommenting = false;
          subCommenting = '';
          repId = '';
        });
      }
    } else {
      print("form not validated");
    }
  }

  @override
  void initState() {
    genarateIntVariables();
    if (widget.announce.announcement_comments.length <
        widget.announce.commentsCount) {
      loadMoreComments();
    }

    listController.addListener(scrollListner);
    super.initState();
  }

  void genarateIntVariables() {
    for (int i = 0; i <= widget.allCommentCount; i++) {
      // Use a unique key for each variable, for example, "variable1", "variable2", ...
      int variableKey = i + 1;

      // Set the default value as 3
      setState(() {
        subcommentOffset[(variableKey - 1).toString()] = 3;
        subcommentcount[(variableKey - 1).toString()] = 3;
      });
    }
  }

  void stateChanger() async {
    await postController.onInit();
    setState(() {});
  }

  void scrollListner() {
    if (!loadingMoreData) {
      if (listController.offset >
          listController.position.maxScrollExtent - 10) {
        if (widget.announce.commentsCount >
            widget.announce.announcement_comments.length) {
          loadMoreComments();
          offset = limit + offset;
        }
      }
    }
  }

  void loadMoreComments() async {
    setState(() {
      loadingMoreData = true;
    });
    AnnouncementComments comments = await ApiV2().GetAnnouncementComments(
        id: widget.announcetId,
        offset: widget.announce.announcement_comments.length,
        limit: limit,
        commentCount: commentcount);
    if (comments != null) {
      setState(() {
        comments.body.comments.forEach((element) {
          if (widget.fromFeed) {
            postController.addAnnounceComment(widget.index, element, true);
            widget.announce = postController.feeds[widget.index]["model"];
          } else {
            profileController.addAnnounceComment(widget.index, element, true);

            widget.announce =
                profileController.profileFeed[widget.index]["model"];
          }
          // widget.announce.announcement_comments.add(element);
        });
        isFinished = comments.body.isCompleted;
        offset = limit + offset;
        commentcount += comments.body.commentCount;
        loadingMoreData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackGroundColor,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Wishes",
            style: TextStyle(color: Color(0xff536471)),
          ),
          leading: BackButton(),
          backgroundColor: AppColors.scaffoldBackGroundColor,
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: Obx(() {
                  return postController.feeds.isEmpty
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          controller: listController,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount:
                              widget.announce.announcement_comments.length + 1,
                          // ignore: missing_return
                          itemBuilder: (context, index) {
                            if (index <
                                widget.announce.announcement_comments.length) {
                              return widget
                                          .announce
                                          .announcement_comments[index]
                                          .comment !=
                                      ""
                                  ? Column(
                                      children: [
                                        Container(
                                          margin: widget.index.isEven
                                              ? const EdgeInsets.symmetric(
                                                  vertical: 0)
                                              : EdgeInsets.zero,
                                          decoration: BoxDecoration(
                                              color: AppColors
                                                  .scaffoldBackGroundColor),
                                          padding: EdgeInsets.only(
                                              left: 16, top: 8, bottom: 8),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      if (widget
                                                              .announce
                                                              .announcement_comments[
                                                                  index]
                                                              .player_id !=
                                                          userController
                                                              .currentUser
                                                              .value
                                                              .id) {
                                                        DefaultRouter
                                                            .defaultRouter(
                                                          Profile(
                                                            id: widget
                                                                .announce
                                                                .announcement_comments[
                                                                    index]
                                                                .player_id,
                                                            myProfile: false,
                                                            // postId: widget.postModel.id,
                                                          ),
                                                          context,
                                                        );
                                                      } else {
                                                        DefaultRouter
                                                            .defaultRouter(
                                                          Profile(
                                                            id: widget
                                                                .announce
                                                                .announcement_comments[
                                                                    index]
                                                                .player_id,
                                                            myProfile: true,
                                                            // postId: widget.postModel.id,
                                                          ),
                                                          context,
                                                        );
                                                      }
                                                    },
                                                    child: ClipOval(
                                                      child: CachedNetworkImage(
                                                        cacheManager:
                                                            CustomCacheManager
                                                                .instance,
                                                        imageUrl: widget
                                                            .announce
                                                            .announcement_comments[
                                                                index]
                                                            .player_image,
                                                        width: 40.w,
                                                        height: 40.w,
                                                        fit: BoxFit.fill,
                                                        fadeInDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    600),
                                                        fadeOutDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    600),
                                                        errorWidget: (a, b, c) {
                                                          return CachedNetworkImage(
                                                            cacheManager:
                                                                CustomCacheManager
                                                                    .instance,
                                                            imageUrl:
                                                                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 16,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              12,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    widget.announce.announcement_comments[index].player_name.toString().length <
                                                                            17
                                                                        ? widget
                                                                            .announce
                                                                            .announcement_comments[
                                                                                index]
                                                                            .player_name
                                                                            .toString()
                                                                        : widget
                                                                            .announce
                                                                            .announcement_comments[
                                                                                index]
                                                                            .player_name
                                                                            .substring(0,
                                                                                17),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Color(
                                                                          0xff0F1419),
                                                                    ),
                                                                  ),
                                                                  widget
                                                                          .announce
                                                                          .announcement_comments[
                                                                              index]
                                                                          .is_brand_verified
                                                                      ? Container(
                                                                          margin: const EdgeInsets.only(
                                                                              left:
                                                                                  2),
                                                                          child:
                                                                              Icon(
                                                                            Icons.verified,
                                                                            size:
                                                                                12,
                                                                            color:
                                                                                AppColors.BUTTON_BLUE_COLLOR,
                                                                          ))
                                                                      : Container(),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: 4,
                                                              ),
                                                              SizedBox(
                                                                width: 4,
                                                              ),
                                                              Text(
                                                                timeago.format(
                                                                  widget.announce.announcement_comments[index].date_created !=
                                                                          null
                                                                      ? DateTime.parse(widget
                                                                          .announce
                                                                          .announcement_comments[
                                                                              index]
                                                                          .date_created)
                                                                      : DateTime
                                                                          .now(),
                                                                ),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                ),
                                                              ),
                                                              Spacer(),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1.3,
                                                          child: Text(
                                                            widget
                                                                .announce
                                                                .announcement_comments[
                                                                    index]
                                                                .comment,
                                                            maxLines: 20,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xff272727),
                                                              fontSize: 13.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (widget
                                                          .announce
                                                          .announcement_comments[
                                                              index]
                                                          .player_id ==
                                                      userController
                                                          .currentUser.value.id)
                                                    PopupMenuButton(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        iconSize: 24,
                                                        itemBuilder: (context) {
                                                          return [
                                                            PopupMenuItem(
                                                                height:
                                                                    kToolbarHeight *
                                                                        0.75,
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                onTap:
                                                                    () async {
                                                                  debugPrint(widget
                                                                      .announce
                                                                      .announcement_comments[
                                                                          index]
                                                                      .id);

                                                                  ApiV2 apiV2 =
                                                                      ApiV2();
                                                                  Map res = await apiV2.deleteAnounceComment(widget
                                                                      .announce
                                                                      .announcement_comments[
                                                                          index]
                                                                      .id);
                                                                  if (res
                                                                      .isNotEmpty) {
                                                                    if (res[
                                                                        "done"]) {
                                                                      setState(
                                                                          () {
                                                                        if (widget
                                                                            .fromFeed) {
                                                                          postController
                                                                              .removeAnnounceComment(
                                                                            widget.index,
                                                                            index,
                                                                          );
                                                                          widget.announce =
                                                                              postController.feeds[widget.index]["model"];
                                                                        } else {
                                                                          profileController
                                                                              .removeAnnounceComment(
                                                                            widget.index,
                                                                            index,
                                                                          );
                                                                          widget.announce =
                                                                              profileController.profileFeed[widget.index]["model"];
                                                                        }
                                                                      });
                                                                    }
                                                                  }
                                                                },
                                                                value: 1,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .delete,
                                                                      size:
                                                                          18.sp,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      "Delete",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14.sp),
                                                                    )
                                                                  ],
                                                                ))
                                                          ];
                                                        })
                                                ],
                                              ),
                                            ],
                                          ),
                                          // ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        for (int i = 0;
                                            i <
                                                widget
                                                    .announce
                                                    .announcement_comments[
                                                        index]
                                                    .comments
                                                    .length;
                                            i++)
                                          newCommentCard2(
                                              index,
                                              widget
                                                  .announce
                                                  .announcement_comments[index]
                                                  .comments[i],
                                              i,
                                              widget.index,
                                              postController,
                                              () {},
                                              repId),
                                        widget
                                                        .announce
                                                        .announcement_comments[
                                                            index]
                                                        .id ==
                                                    repId &&
                                                !isCommenting
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: AppColors
                                                        .PRIMARY_COLOR_LIGHT,
                                                  ),
                                                ),
                                                margin: const EdgeInsets.only(
                                                    left: 60,
                                                    bottom: 5,
                                                    right: 5),
                                                child: TextFormField(
                                                  controller: replyController,
                                                  maxLength: 100,
                                                  buildCounter: (BuildContext
                                                              context,
                                                          {int currentLength,
                                                          int maxLength,
                                                          bool isFocused}) =>
                                                      null,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  keyboardType: TextInputType
                                                      .streetAddress,
                                                  validator: (val) => val !=
                                                          null
                                                      ? val.isEmpty
                                                          ? "Enter a comment"
                                                          : null
                                                      : null,
                                                  onFieldSubmitted:
                                                      (value) async {
                                                    await submitComment();
                                                  },
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            vertical: 4,
                                                            horizontal: 8),
                                                    fillColor: AppColors.WHITE,
                                                    border: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    hintText:
                                                        "Type your reply here...",
                                                    hintStyle: TextStyle(
                                                        fontSize: 14.sp),
                                                    suffixIcon: InkWell(
                                                      child: Icon(Icons.send),
                                                      onTap: isCommenting
                                                          ? () {}
                                                          : () async {
                                                              setState(() {
                                                                isCommenting =
                                                                    true;
                                                                subCommenting = widget
                                                                    .announce
                                                                    .announcement_comments[
                                                                        index]
                                                                    .id;
                                                                // repId='';
                                                              });
                                                              await submitReplyComment();
                                                            },
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        widget
                                                    .announce
                                                    .announcement_comments[
                                                        index]
                                                    .id ==
                                                subCommenting
                                            ? Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 5),
                                                child: SpinKitThreeBounce(
                                                  color: AppColors
                                                      .PRIMARY_COLOR_LIGHT,
                                                  size: 18.0,
                                                ),
                                              )
                                            : Container(),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 60,
                                            ),
                                            widget
                                                        .announce
                                                        .announcement_comments[
                                                            index]
                                                        .subCommentCount >
                                                    0
                                                ? widget
                                                            .announce
                                                            .announcement_comments[
                                                                index]
                                                            .subCommentCount >
                                                        widget
                                                            .announce
                                                            .announcement_comments[
                                                                index]
                                                            .comments
                                                            .length
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 8,
                                                                bottom: 16,
                                                                left: 19),
                                                        child: Container(
                                                          child: InkWell(
                                                              onTap: () async {
                                                                if (!isLoading) {
                                                                  setState(() {
                                                                    isLoading =
                                                                        true;
                                                                  });
                                                                  AnnouncementSubComments subComments = await ApiV2().GetAnnouncementSubComments(
                                                                      id: widget
                                                                          .announce
                                                                          .announcement_comments[
                                                                              index]
                                                                          .id,
                                                                      limit: 10,
                                                                      offset: subcommentOffset[
                                                                          index
                                                                              .toString()],
                                                                      commentCount:
                                                                          subcommentcount[
                                                                              index.toString()]);
                                                                  if (subComments
                                                                      .done) {
                                                                    setState(
                                                                        () {
                                                                      subComments
                                                                          .body
                                                                          .comments
                                                                          .forEach(
                                                                              (element) {
                                                                        if (widget
                                                                            .fromFeed) {
                                                                          postController.addReplyAnnounceComment(
                                                                              widget.index,
                                                                              index,
                                                                              element,
                                                                              true);
                                                                        } else {
                                                                          profileController.addReplyAnnounceComment(
                                                                              widget.index,
                                                                              index,
                                                                              element,
                                                                              true);
                                                                        }
                                                                      });
                                                                      subcommentOffset[
                                                                          index
                                                                              .toString()] += 10;
                                                                      subcommentcount[
                                                                          index
                                                                              .toString()] += subComments
                                                                          .body
                                                                          .commentCount;
                                                                      isLoading =
                                                                          false;
                                                                    });
                                                                  }
                                                                }
                                                              },
                                                              child: const Text(
                                                                "",
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .PRIMARY_COLOR_LIGHT,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              )),
                                                        ),
                                                      )
                                                    : Container()
                                                : Container(),
                                            // Row(
                                            //   crossAxisAlignment:
                                            //       CrossAxisAlignment.start,
                                            //   mainAxisAlignment:
                                            //       MainAxisAlignment.start,
                                            //   children: [
                                            //     SizedBox(
                                            //       width: MediaQuery.of(context)
                                            //               .size
                                            //               .width /
                                            //           40,
                                            //     ),
                                            //     Padding(
                                            //         padding:
                                            //             const EdgeInsets.only(
                                            //                 left: 15),
                                            //         child: Image.asset(
                                            //           "assets/bg/replyicon.png",
                                            //           width: 15,
                                            //           height: 15,
                                            //         )),
                                            //     Padding(
                                            //       padding:
                                            //           const EdgeInsets.only(
                                            //               bottom: 10, left: 15),
                                            //       child: Container(
                                            //         child: InkWell(
                                            //             onTap: () async {
                                            //               setState(() {
                                            //                 repId = widget
                                            //                     .announce
                                            //                     .announcement_comments[
                                            //                         index]
                                            //                     .id;
                                            //                 repIndex = index;
                                            //               });
                                            //             },
                                            //             child: const Text(
                                            //               "Reply",
                                            //               style: TextStyle(
                                            //                   color: AppColors
                                            //                       .PRIMARY_COLOR_LIGHT,
                                            //                   fontSize: 12,
                                            //                   fontWeight:
                                            //                       FontWeight
                                            //                           .w400),
                                            //             )),
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 2),
                                          child: Divider(
                                            color: Color(0xffDEDEDE),
                                            thickness: 1,
                                            height: 2,
                                          ),
                                        )
                                      ],
                                    )
                                  : SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: SpinKitThreeBounce(
                                        color: AppColors.PRIMARY_COLOR,
                                        size: 30.0,
                                      ),
                                    );
                            } else {
                              return Container(
                                child: _isCommenting || loadingMoreData
                                    ? SpinKitThreeBounce(
                                        color: AppColors.PRIMARY_COLOR_LIGHT,
                                        size: 25.0,
                                      )
                                    : SizedBox(),
                              );
                            }
                          },
                          // ),
                        );
                }),
              ),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                  color: Colors.white,
                  height: kBottomNavigationBarHeight * 1.5,
                  child: Row(
                    children: [
                      CircleAvatar(
                          backgroundImage: NetworkImage(userController
                                  .currentUser.value.profileImage ??
                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")),
                      Expanded(
                        child: TextFormField(
                          onFieldSubmitted: (val) async {
                            await submitComment();
                          },
                          validator: (val) => val != null
                              ? val.isEmpty
                                  ? "Enter comment"
                                  : null
                              : null,
                          maxLength: 100,
                          buildCounter: (BuildContext context,
                                  {int currentLength,
                                  int maxLength,
                                  bool isFocused}) =>
                              null,
                          controller: commentController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Write comment here ...",
                            hintStyle: TextStyle(fontSize: 16.sp),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.send,
                                color: isCommenting
                                    ? Colors.grey
                                    : AppColors.PRIMARY_COLOR_LIGHT,
                              ),
                              onPressed: isCommenting
                                  ? () {}
                                  : () async {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      if (commentController.text != "") {
                                        setState(() {
                                          isCommenting = true;
                                          _isCommenting = true;
                                        });
                                        await submitComment();
                                      }
                                    },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget newCommentCard2(
      int mainComnnetIndex,
      AnnounceComments comment,
      int index,
      int feedIndex,
      FeedController feedController,
      VoidCallback callback,
      String replyId) {
    bool reply = false;
    var cid = comment.playerId;
    var uid = userController.currentUser.value.id;
    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          SizedBox(
            width: 60,
          ),
          Container(
            margin: widget.index.isEven
                ? const EdgeInsets.symmetric(vertical: 0)
                : EdgeInsets.zero,
            decoration: BoxDecoration(color: Colors.white
                // color:
                //     index.isEven ? Colors.white : AppColors.scaffoldBackGroundColor,
                ),
            padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
            width: MediaQuery.of(context).size.width - 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        cacheManager: CustomCacheManager.instance,
                        imageUrl: comment.playerImage,
                        width: 32.w,
                        height: 32.w,
                        fit: BoxFit.fill,
                        fadeInDuration: const Duration(milliseconds: 600),
                        fadeOutDuration: const Duration(milliseconds: 600),
                        errorWidget: (a, b, c) {
                          return CachedNetworkImage(
                            cacheManager: CustomCacheManager.instance,
                            imageUrl:
                                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 18.h,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  comment.playerName,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                comment.is_brand_verified
                                    ? Container(
                                        margin: const EdgeInsets.only(left: 2),
                                        child: Icon(
                                          Icons.verified,
                                          size: 11,
                                          color: AppColors.BUTTON_BLUE_COLLOR,
                                        ))
                                    : Container(),
                                SizedBox(
                                  width: 4,
                                ),
                                Container(
                                  width: 1,
                                  height: 15.h,
                                  color: Colors.grey[500],
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  timeago.format(
                                    comment.dateCreated != null
                                        ? DateTime.parse(comment.dateCreated)
                                        : DateTime.now(),
                                  ),
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.3,
                            child: Text(
                              comment.comment,
                              maxLines: 20,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (cid == uid)
                      PopupMenuButton(
                          padding: EdgeInsets.zero,
                          iconSize: 24,
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                  height: kToolbarHeight * 0.75,
                                  padding: EdgeInsets.zero,
                                  onTap: () async {
                                    debugPrint(comment.id);

                                    ApiV2 apiV2 = ApiV2();
                                    Map res = await apiV2
                                        .deleteAnounceComment(comment.id);
                                    if (res.isNotEmpty) {
                                      if (res["done"]) {
                                        setState(() {
                                          if (widget.fromFeed) {
                                            feedController
                                                .removeReplyAnnounceComment(
                                              widget.index,
                                              mainComnnetIndex,
                                              index,
                                            );
                                            widget.announce = postController
                                                .feeds[widget.index]["model"];
                                          } else {
                                            profileController
                                                .removeReplyAnnounceComment(
                                              widget.index,
                                              mainComnnetIndex,
                                              index,
                                            );
                                            widget.announce = profileController
                                                    .profileFeed[widget.index]
                                                ["model"];
                                          }
                                        });
                                      }
                                    }
                                  },
                                  value: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        size: 18.sp,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Delete",
                                        style: TextStyle(fontSize: 14.sp),
                                      )
                                    ],
                                  ))
                            ];
                          })
                  ],
                ),
              ],
            ),
            // ),
          ),
        ],
      ),
    );
  }
}
