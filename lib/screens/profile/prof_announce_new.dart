// ignore_for_file: unnecessary_const

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/controllers/feed_controller.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/models/NewModelsV2/feed/announcement_comments.dart';
import 'package:play_pointz/models/NewModelsV2/feed/announcement_sub_comments.dart';
import 'package:play_pointz/models/notificaitons/announce_comment_model.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:play_pointz/models/post/comment_model.dart';

import '../../Api/ApiV2/api_V2.dart';

class ProfleAnnouncePageNew extends StatefulWidget {
  final String announcementId;
  final int index;
  final VoidCallback callback;

  const ProfleAnnouncePageNew(
      {Key key, this.announcementId, this.index, this.callback})
      : super(key: key);

  @override
  State<ProfleAnnouncePageNew> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<ProfleAnnouncePageNew> {
  bool btnLoading = false;
  bool isLoading = false;
  bool isCommenting = false;
  final TextEditingController commentController = TextEditingController();
  final TextEditingController replyController = TextEditingController();
  final userController = Get.put(UserController());
  bool isFinished = false;
  int limit = 10;
  int offset = 0;
  int commentcount = 0;
  List<AnnounceCommentModel> proComments = [];
  Map<String, int> subcommentOffset = {};
  Map<String, int> subcommentcount = {};

  final listController = ScrollController();

  bool loadingMoreData = false;
  String repId = '';
  int repIndex;

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  Future<void> submitComment() async {
    if (commentController.text != "" && _formKey.currentState.validate()) {
      final result = await Api().createWish(
          announcementId: widget.announcementId,
          comment: commentController.text,
          commentId: null);

      if (result.done) {
        AnnounceCommentModel comment = AnnounceCommentModel(
            subCommentCount: 0,
            is_brand_verified: result.body.is_brand_verified,
            id: result.body.commentId,
            player_id: userController.currentUser.value.id,
            announcement_id: widget.announcementId,
            comment: commentController.text,
            comment_id: result.body.commentId,
            date_created: result.body.dateCreated ?? DateTime.now().toString(),
            player_image: userController.currentUser.value.profileImage ??
                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
            player_name: userController.currentUser.value.fullName ?? "No Name",
            comments: []);

        setState(() {
          proComments.add(comment);
          commentController.clear();
          isCommenting = false;
        });

        //stateChanger();
      }
    } else {
      print("form not validated");
    }
  }

  void genarateIntVariables(int allCommentsCount) {
    for (int i = 0; i <= allCommentsCount; i++) {
      // Use a unique key for each variable, for example, "variable1", "variable2", ...
      int variableKey = i + 1;

      // Set the default value as 3
      setState(() {
        subcommentOffset[(variableKey - 1).toString()] = 3;
        subcommentcount[(variableKey - 1).toString()] = 3;
      });
    }
  }

  void loadMoreComments() async {
    setState(() {
      loadingMoreData = true;
    });
    AnnouncementComments comments = await ApiV2().GetAnnouncementComments(
        id: widget.announcementId,
        offset: offset,
        limit: limit,
        commentCount: commentcount);
    if (comments != null) {
      setState(() {
        proComments.addAll(comments.body.comments);
        isFinished = comments.body.isCompleted;
        offset = limit + offset;
        commentcount += comments.body.commentCount;
        loadingMoreData = false;
        genarateIntVariables(comments.body.commentCount);
        // stateChanger();
      });
    }
  }

  Future<void> submitReplyComment(int index) async {
    if (replyController.text != "") {
      final result = await Api().createWish(
          announcementId: widget.announcementId,
          comment: replyController.text,
          commentId: repId);

      if (result.done) {
        AnnounceComments subComment = AnnounceComments(
            is_brand_verified: result.body.is_brand_verified,
            id: result.body.id,
            playerId: userController.currentUser.value.id,
            announceId: widget.announcementId,
            comment: replyController.text,
            commentId: result.body.commentId,
            dateCreated: result.body.dateCreated ?? DateTime.now().toString(),
            playerImage: userController.currentUser.value.profileImage ??
                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
            playerName: userController.currentUser.value.fullName ?? "No Name");
        setState(() {
          proComments[index].comments.add(subComment);
          replyController.clear();
          isCommenting = false;
        });

        //stateChanger();
      }
    } else {
      print("form not validated");
    }
  }

  void stateChanger() async {
    proComments = [];
    loadMoreComments();

    setState(() {});
  }

  @override
  void initState() {
    loadMoreComments();
    listController.addListener(scrollListner);
    super.initState();
  }

  void scrollListner() {
    if (!loadingMoreData) {
      if (listController.offset >
          listController.position.maxScrollExtent - 10) {
        if (!isFinished) {
          loadMoreComments();
          offset = limit + offset;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackGroundColor,
      appBar: AppBar(
        title: Text("Wishes"),
        leading: BackButton(),
        backgroundColor: Colors.white,
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
              child: ListView.builder(
                  controller: listController,
                  //  reverse: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: proComments.length,
                  itemBuilder: (context, index) {
                    return proComments[index].comment != ""
                        ? Column(
                            children: [
                              Container(
                                margin: widget.index.isEven
                                    ? const EdgeInsets.symmetric(vertical: 0)
                                    : EdgeInsets.zero,
                                decoration: BoxDecoration(color: Colors.white),
                                padding: EdgeInsets.only(
                                    left: 16, top: 8, bottom: 8),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ClipOval(
                                          child: CachedNetworkImage(
                                            cacheManager:
                                                CustomCacheManager.instance,
                                            imageUrl:
                                                proComments[index].player_image,
                                            width: 40.w,
                                            height: 40.w,
                                            fit: BoxFit.fill,
                                            fadeInDuration: const Duration(
                                                milliseconds: 600),
                                            fadeOutDuration: const Duration(
                                                milliseconds: 600),
                                            errorWidget: (a, b, c) {
                                              return CachedNetworkImage(
                                                cacheManager:
                                                    CustomCacheManager.instance,
                                                imageUrl:
                                                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 20.h,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      proComments[index]
                                                          .player_name,
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.grey[800],
                                                      ),
                                                    ),
                                                    proComments[index]
                                                            .is_brand_verified
                                                        ? Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 2),
                                                            child: Icon(
                                                              Icons.verified,
                                                              size: 12,
                                                              color: AppColors
                                                                  .BUTTON_BLUE_COLLOR,
                                                            ))
                                                        : Container(),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Container(
                                                      width: 1,
                                                      height: 16.h,
                                                      color: Colors.grey[500],
                                                    ),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      timeago.format(
                                                        proComments[index]
                                                                    .date_created !=
                                                                null
                                                            ? DateTime.parse(
                                                                proComments[
                                                                        index]
                                                                    .date_created)
                                                            : DateTime.now(),
                                                      ),
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
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
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.3,
                                                child: Text(
                                                  proComments[index].comment,
                                                  maxLines: 20,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (proComments[index].player_id ==
                                            userController.currentUser.value.id)
                                          PopupMenuButton(
                                              padding: EdgeInsets.zero,
                                              iconSize: 24,
                                              itemBuilder: (context) {
                                                return [
                                                  PopupMenuItem(
                                                      height:
                                                          kToolbarHeight * 0.75,
                                                      padding: EdgeInsets.zero,
                                                      onTap: () async {
                                                        ApiV2 apiV2 = ApiV2();
                                                        Map res = await apiV2
                                                            .deleteAnounceComment(
                                                                proComments[
                                                                        index]
                                                                    .id);
                                                        if (res.isNotEmpty) {
                                                          if (res["done"]) {
                                                            setState(() {
                                                              proComments
                                                                  .removeAt(
                                                                      index);
                                                            });

                                                            //  stateChanger();
                                                          }
                                                          // stateChanger();
                                                        }
                                                      },
                                                      value: 1,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
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
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              for (int i = 0;
                                  i < proComments[index].comments.length;
                                  i++)
                                newCommentCard3(
                                    proComments[index].comments[i],
                                    i,
                                    stateChanger,
                                    widget.index,
                                    () {},
                                    repId,
                                    index),
                              proComments[index].id == repId
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: AppColors.PRIMARY_COLOR_LIGHT,
                                        ),
                                      ),
                                      margin: const EdgeInsets.only(left: 60),
                                      child: TextFormField(
                                        maxLength: 100,
                                        buildCounter: (BuildContext context,
                                                {int currentLength,
                                                int maxLength,
                                                bool isFocused}) =>
                                            null,
                                        controller: replyController,
                                        textInputAction: TextInputAction.next,
                                        keyboardType:
                                            TextInputType.streetAddress,
                                        validator: (val) => val != null
                                            ? val.isEmpty
                                                ? "Enter a comment"
                                                : null
                                            : null,
                                        onFieldSubmitted: (value) async {
                                          await submitComment();
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 4, horizontal: 8),
                                          fillColor:
                                              AppColors.scaffoldBackGroundColor,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          hintText: "Type your reply here...",
                                          hintStyle: TextStyle(fontSize: 14.sp),
                                          suffixIcon: InkWell(
                                            child: Icon(Icons.send),
                                            onTap: isCommenting
                                                ? () {}
                                                : () async {
                                                    setState(() {
                                                      isCommenting = true;
                                                    });
                                                    await submitReplyComment(
                                                        index);
                                                  },
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 60,
                                  ),
                                  proComments[index].subCommentCount > 3
                                      ? proComments[index].subCommentCount >
                                              proComments[index].comments.length
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 0, bottom: 8, left: 8),
                                              child: InkWell(
                                                  onTap: () async {
                                                    if (!isLoading) {
                                                      setState(() {
                                                        isLoading = true;
                                                      });
                                                      AnnouncementSubComments
                                                          subComments =
                                                          await ApiV2().GetAnnouncementSubComments(
                                                              id: proComments[
                                                                      index]
                                                                  .id,
                                                              limit: 10,
                                                              offset: subcommentOffset[
                                                                  index
                                                                      .toString()],
                                                              commentCount:
                                                                  subcommentcount[
                                                                      index
                                                                          .toString()]);
                                                      if (subComments.done) {
                                                        setState(() {
                                                          for (var element
                                                              in subComments
                                                                  .body
                                                                  .comments) {
                                                            proComments[index]
                                                                .comments
                                                                .add(element);
                                                          }
                                                          subcommentOffset[index
                                                              .toString()] += 10;
                                                          subcommentcount[index
                                                                  .toString()] +=
                                                              subComments.body
                                                                  .commentCount;
                                                          isLoading = false;
                                                        });
                                                      }
                                                    }
                                                  },
                                                  child: const Text(
                                                    "Load More.",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .PRIMARY_COLOR_LIGHT,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )),
                                            )
                                          : Container()
                                      : Container(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0, bottom: 8, left: 8),
                                    child: TextButton(
                                        onPressed: () async {
                                          setState(() {
                                            repId = proComments[index].id;
                                            repIndex = index;
                                          });
                                        },
                                        child: const Text(
                                          "Reply",
                                          style: TextStyle(
                                              color:
                                                  AppColors.PRIMARY_COLOR_LIGHT,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          )
                        : Container();
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
                        controller: commentController,
                        maxLength: 100,
                        buildCounter: (BuildContext context,
                                {int currentLength,
                                int maxLength,
                                bool isFocused}) =>
                            null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Write comment here ...",
                          hintStyle: TextStyle(fontSize: 16.sp),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: isCommenting
                                ? () {}
                                : () async {
                                    if (commentController.text != "") {
                                      setState(() {
                                        isCommenting = true;
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
    );
  }

  Widget newCommentCard2(
      Comments comment,
      int index,
      Function stateChange,
      int feedIndex,
      FeedController feedController,
      VoidCallback callback,
      String replyId) {
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
            decoration: BoxDecoration(color: Colors.white),
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
                                          size: 12,
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
                                        feedController.removeComment(
                                          widget.index,
                                          feedIndex,
                                        );
                                        stateChanger();
                                      }
                                      stateChanger();
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

  Widget newCommentCard3(
    AnnounceComments comment,
    int index,
    Function stateChange,
    int feedIndex,
    // FeedController feedController,
    VoidCallback callback,
    String replyId,
    int mainCommentIndex,
  ) {
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
            decoration: BoxDecoration(color: Colors.white),
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
                                          proComments[mainCommentIndex]
                                              .comments
                                              .removeAt(index);
                                        });
                                        // proComments[index].comments.remove(value)
                                        // feedController.removeComment(
                                        //   widget.index,
                                        //   feedIndex,
                                        // );
                                        // print(proComments);
                                        //stateChanger();
                                      }
                                      //stateChanger();
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
