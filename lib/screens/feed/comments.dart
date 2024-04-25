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
import 'package:play_pointz/controllers/profile_controller.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/models/feed/post_comment.dart';
import 'package:play_pointz/models/feed/post_sub_comment.dart';
import 'package:play_pointz/models/post/post_model.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/profile/profile.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:play_pointz/models/post/comment_model.dart';

import '../../Api/ApiV2/api_V2.dart';

class CommentPage extends StatefulWidget {
  final String postId;
  final int allComentCount;
  List<CommentModel> comments;
  PostModel postModel;
  final int index;
  final fromNotification;
  // ProfileController profileController;
  bool fromFeed;

  CommentPage(
      {Key key,
      this.postId,
      this.index,
      this.allComentCount,
      this.postModel,
      this.comments,
      // this.profileController,
      this.fromFeed,
      this.fromNotification})
      : super(key: key);

  @override
  State<CommentPage> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<CommentPage> {
  bool isLoading = false;
  bool isCommenting = false;
  bool _isCommenting = false;
  List<CommentModel> comments = [];
  int offset = 1;
  static int limit = 10;
  int commentCount = 1;

  final TextEditingController commentController = TextEditingController();
  final TextEditingController replyController = TextEditingController();
  final userController = Get.put(UserController());

  final postController = Get.put(FeedController());
  final profileController = Get.put(ProfileController());
  final listScrollController = ScrollController();
  String repId = '';
  String subCommenting = '';
  int repIndex;
  bool isFinished = true;
  bool loadingMoreData = false;
  Map<String, int> subcommentOffset = {};
  Map<String, int> subcommentcount = {};

  final _formKey = GlobalKey<FormState>();
  Future<void> submitComment() async {
    if (commentController.text != "" && _formKey.currentState.validate()) {
      final result = await Api().createComment(
          postId: widget.postId,
          comment: commentController.text,
          commentId: null);

      if (result.done) {
        CommentModel comment = CommentModel(
            sub_comment_count: 0,
            id: result.body.commentId,
            player_id: userController.currentUser.value.id,
            post_id: widget.postId,
            comment: commentController.text,
            comment_id: result.body.commentId,
            date_created: result.body.dateCreated ?? DateTime.now().toString(),
            player_image: userController.currentUser.value.profileImage ??
                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
            player_name: userController.currentUser.value.fullName ?? "No Name",
            is_brand_verified:
                userController.currentUser.value.page_verified ?? false,
            comments: []);
        if (widget.fromFeed) {
          postController.addComment(widget.index, comment, false);
          comments = postController.feeds[widget.index]["model"].post_comments;
        } else if (widget.fromNotification) {
          setState(() {
            comments.add(comment);
            widget.postModel.comments_count += 1;
          });
          //  comments = widget.postModel.post_comments;
        } else {
          profileController.addComment(widget.index, comment, false);
          comments = profileController
              .profileFeed[widget.index]["model"].post_comments;
        }

        debugPrint("comment created succesfully");
        setState(() {
          commentController.clear();
          isCommenting = false;
          _isCommenting = false;
        });
        FocusManager.instance.primaryFocus?.unfocus();
        listScrollController.animateTo(
          listScrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500),
        );
      }
    } else {
      print("form not validated");
    }
  }

  @override
  void initState() {
    comments = widget.postModel.post_comments;
    /* comments =
        profileController.profileFeed[widget.index]["model"].post_comments; */
    genarateIntVariables();
    listScrollController.addListener(scrollListner);
    widget.postModel.post_comments.length < widget.postModel.comments_count
        ? loadMoreComments()
        : () {};
    super.initState();
  }

  void genarateIntVariables() {
    for (int i = 0; i <= widget.allComentCount; i++) {
      int variableKey = i + 1;

      setState(() {
        subcommentOffset[(variableKey - 1).toString()] = 3;
        subcommentcount[(variableKey - 1).toString()] = 3;
      });
    }
  }

  void scrollListner() {
    if (!loadingMoreData) {
      if (listScrollController.offset >
          listScrollController.position.maxScrollExtent - 10) {
        if (!isFinished) {
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
    PostCommentsModel commentsData = await ApiV2().GetPostComments(
        id: widget.postId,
        offset: offset,
        limit: limit,
        commentCount: commentCount);
    if (commentsData != null) {
      setState(() {
        commentsData.body.comments.forEach((element) {
          //  postController.addComment(widget.index, element, true);
          comments.add(element);
        });
        isFinished = commentsData.body.isCompleted;
        offset = limit + offset;
        commentCount = commentsData.body.commentCount;
        loadingMoreData = false;
      });
    }
  }

  Future<void> submitReplyComment() async {
    if (replyController.text != "") {
      final result = await Api().createComment(
          postId: widget.postId,
          comment: replyController.text,
          commentId: repId);

      if (result.done) {
        Comments subComment = Comments(
          id: result.body.commentId,
          playerId: userController.currentUser.value.id,
          postId: widget.postId,
          comment: replyController.text,
          commentId: result.body.commentId,
          dateCreated: result.body.dateCreated ?? DateTime.now().toString(),
          playerImage: userController.currentUser.value.profileImage ??
              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
          playerName: userController.currentUser.value.fullName ?? "No Name",
          is_brand_verified:
              userController.currentUser.value.page_verified ?? false,
        );

        if (widget.fromFeed) {
          postController.addReplyComment(widget.index, repIndex, subComment);
        } else if (widget.fromNotification) {
          setState(() {
            comments[repIndex].comments.add(subComment);
            widget.postModel.post_comments[repIndex].sub_comment_count += 1;
          });
        } else {
          profileController.addReplyComment(widget.index, repIndex, subComment);
        }
        debugPrint("comment created succesfully");
        setState(() {
          replyController.clear();
          isCommenting = false;
          subCommenting = '';
          repId = '';
        });
      }
    } else {
      print("form not validated");
    }
  }

  void stateChanger() async {
    await postController.onInit();
    setState(() {});
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
          iconTheme: IconThemeData(
            color: Color(0xff536471), // Set your desired icon color here
          ),
          elevation: 0,
          title: Text(
            "Comments",
            style: TextStyle(color: Color(0xff536471)),
          ),
          centerTitle: true,
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
                  child: comments.length < 0
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          controller: listScrollController,
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          itemCount: comments.length + 1,
                          // ignore: missing_return
                          itemBuilder: (context, index) {
                            if (index < comments.length) {
                              return comments[index].comment != ""
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                                      if (comments[index]
                                                              .player_id !=
                                                          userController
                                                              .currentUser
                                                              .value
                                                              .id) {
                                                        DefaultRouter
                                                            .defaultRouter(
                                                          Profile(
                                                            id: comments[index]
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
                                                            id: comments[index]
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
                                                        imageUrl:
                                                            comments[index]
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
                                                                    comments[index].player_name.toString().length <
                                                                            17
                                                                        ? comments[index]
                                                                            .player_name
                                                                            .toString()
                                                                        : comments[index]
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
                                                                  comments[index]
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
                                                                  comments[index]
                                                                              .date_created !=
                                                                          null
                                                                      ? DateTime.parse(
                                                                          comments[index]
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
                                                            comments[index]
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
                                                  if (comments[index]
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
                                                                  debugPrint(
                                                                      comments[
                                                                              index]
                                                                          .id);

                                                                  ApiV2 apiV2 =
                                                                      ApiV2();
                                                                  Map res = await apiV2
                                                                      .deleteComment(
                                                                          comments[index]
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
                                                                              .removeComment(
                                                                            widget.index,
                                                                            index,
                                                                          );
                                                                        } else if (widget
                                                                            .fromNotification) {
                                                                          comments
                                                                              .removeAt(index);
                                                                        } else {
                                                                          profileController
                                                                              .removeComment(
                                                                            widget.index,
                                                                            index,
                                                                          );
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
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        for (int i = 0;
                                            i < comments[index].comments.length;
                                            i++)
                                          newCommentCard2(
                                              index,
                                              comments[index].comments[i],
                                              i,
                                              stateChanger,
                                              widget.index,
                                              postController,
                                              () {},
                                              repId),
                                        comments[index].id == repId &&
                                                !isCommenting
                                            ?
                                            //Reply Text Filed
                                            Container(
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
                                                                subCommenting =
                                                                    comments[
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
                                        comments[index].id == subCommenting
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
                                            comments[index].sub_comment_count >
                                                    0
                                                ? comments[index]
                                                            .sub_comment_count >
                                                        comments[index]
                                                            .comments
                                                            .length
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 8,
                                                                bottom: 16,
                                                                left: 19),
                                                        child: InkWell(
                                                            onTap: () async {
                                                              if (!isLoading) {
                                                                setState(() {
                                                                  isLoading =
                                                                      true;
                                                                });
                                                                PostSubCommentsModel subComments = await ApiV2().GetPostSubComments(
                                                                    id: comments[
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
                                                                  setState(() {
                                                                    subComments
                                                                        .body
                                                                        .comments
                                                                        .forEach(
                                                                            (element) {
                                                                      if (widget
                                                                          .fromFeed) {
                                                                        postController.addReplyComment(
                                                                            widget.index,
                                                                            index,
                                                                            element);
                                                                      } else {
                                                                        profileController.addReplyComment(
                                                                            widget.index,
                                                                            index,
                                                                            element);
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
                                                              "Load more...",
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .PRIMARY_COLOR_LIGHT,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            )),
                                                      )
                                                    : Container()
                                                : Container(),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      40,
                                                ),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15),
                                                    child: Image.asset(
                                                      "assets/bg/replyicon.png",
                                                      width: 15,
                                                      height: 15,
                                                    )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10, left: 15),
                                                  child: Container(
                                                    child: InkWell(
                                                        onTap: () async {
                                                          setState(() {
                                                            repId =
                                                                comments[index]
                                                                    .id;
                                                            repIndex = index;
                                                          });
                                                        },
                                                        child: const Text(
                                                          "Reply",
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .PRIMARY_COLOR_LIGHT,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                        )
                  /*  },
                ), */
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
                              icon: Icon(Icons.send),
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
      Comments comment,
      int index,
      Function stateChange,
      int feedIndex,
      FeedController feedController,
      VoidCallback callback,
      String replyId) {
    bool reply = false;
    var cid = comment.playerId;
    var uid = userController.currentUser.value.id;
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
          ),
          Container(
            margin: widget.index.isEven
                ? const EdgeInsets.symmetric(vertical: 0)
                : EdgeInsets.zero,
            decoration: BoxDecoration(color: AppColors.scaffoldBackGroundColor),
            padding: EdgeInsets.only(
              left: 16,
            ),
            width: MediaQuery.of(context).size.width - 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        if (comment.playerId !=
                            userController.currentUser.value.id) {
                          DefaultRouter.defaultRouter(
                            Profile(
                              id: comment.playerId,
                              myProfile: false,
                              // postId: widget.postModel.id,
                            ),
                            context,
                          );
                        } else {
                          DefaultRouter.defaultRouter(
                            Profile(
                              id: comment.playerId,
                              myProfile: true,
                              // postId: widget.postModel.id,
                            ),
                            context,
                          );
                        }
                      },
                      child: ClipOval(
                        child: CachedNetworkImage(
                          cacheManager: CustomCacheManager.instance,
                          imageUrl: comment.playerImage,
                          width: 40.w,
                          height: 40.w,
                          fit: BoxFit.fill,
                          fadeInDuration: const Duration(milliseconds: 600),
                          fadeOutDuration: const Duration(milliseconds: 600),
                          errorWidget: (a, b, c) {
                            return CachedNetworkImage(
                              fit: BoxFit.cover,
                              cacheManager: CustomCacheManager.instance,
                              imageUrl:
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.width / 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      comment.playerName.toString().length < 16
                                          ? comment.playerName.toString()
                                          : comment.playerName.substring(0, 16),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff0F1419),
                                      ),
                                    ),
                                    comment.is_brand_verified
                                        ? Container(
                                            margin:
                                                const EdgeInsets.only(left: 2),
                                            child: Icon(
                                              Icons.verified,
                                              size: 11,
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
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.3,
                            child: Text(
                              comment.comment,
                              maxLines: 20,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
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
                                    Map res =
                                        await apiV2.deleteComment(comment.id);
                                    if (res.isNotEmpty) {
                                      if (res["done"]) {
                                        setState(() {
                                          if (widget.fromFeed) {
                                            feedController.removeReplyComment(
                                              widget.index,
                                              mainComnnetIndex,
                                              index,
                                            );
                                          } else if (widget.fromNotification) {
                                            comments[mainComnnetIndex]
                                                .comments
                                                .removeAt(index);
                                            comments[mainComnnetIndex]
                                                .sub_comment_count -= 1;
                                          } else {
                                            profileController
                                                .removeReplyComment(
                                              widget.index,
                                              mainComnnetIndex,
                                              index,
                                            );
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
