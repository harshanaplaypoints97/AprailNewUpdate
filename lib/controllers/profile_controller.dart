import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_pointz/Api/ApiV2/api_V2.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/models/NewModelsV2/feed/anouncement_model.dart';
import 'package:play_pointz/models/notificaitons/announce_comment_model.dart';
import 'package:play_pointz/models/notificaitons/announce_like_model.dart';
import 'package:play_pointz/models/post/comment_model.dart';
import 'package:play_pointz/models/post/like_model.dart';
import 'package:play_pointz/models/post/post_model.dart';

class ProfileController extends GetxController {
  /*  final String userId;
  ProfileController(this.userId); */
  UserController userController = Get.put(UserController());
  RxList<Map<String, dynamic>> profileFeed = RxList([]);
  set setFeed(Map<String, dynamic> feedData) => profileFeed.add(feedData);
  RxBool dataloading = RxBool(false);
  int allPostsCount = 0;

  @override
  void onInit() {
    // profileFeed.clear();
    // GetProfileFeed(id: userId).then((value) => update());
    super.onInit();
  }

  @override
  void dispose() {
    profileFeed.clear();
    super.dispose();
  }

  Future<bool> GetProfileFeed({int offset, String userId}) async {
    try {
      // profileFeed.clear();
      dataloading.value = true;
      Map response = await ApiV2().getProfileFeed(
          offSet: offset,
          limit: 10,
          id: userId,
          type: userId == userController.currentUser.value.id
              ? "player"
              : "friend");
      if (response["done"]) {
        offset == 0 ? profileFeed.clear() : () {};
        List result = response["body"]["posts"];
        allPostsCount = response["body"]["count"];

        if (result.isEmpty) {
          dataloading.value = false;
          return true;
        }
        // profileFeed.clear();
        for (Map addData in result) {
          ProfileFeedManager(addData);
        }
      }
      dataloading.value = false;
      return false;
    } catch (e) {
      debugPrint("feed controller fetch data failed $e");
      dataloading.value = false;
      return false;
    }
  }

  void ProfileFeedManager(Map addData) {
    switch (addData["type"]) {
      case "post":
        PostModel postModel = PostModel.fromMap(addData);

        Map<String, dynamic> data = {
          "type": "post",
          "model": postModel,
        };

        setFeed = data;
        break;
      case "announcement":
        Map data = addData;
        AnouncementModel a = AnouncementModel(
            campaignType: data["campaign_type"],
            id: data["id"],
            playerId: data["player_id"],
            dateCreated: data["date_created"],
            dateUpdated: data["date_updated"],
            description: data["description"],
            endDate: data["end_date"],
            media: data["media"],
            mediaType: data["media_type"],
            mediaUrl: data["media_url"],
            name: data["name"],
            placement: data["placement"],
            redirectUrl: data["redirect_url"],
            startDate: data["start_date"],
            text: data["text"],
            type: data["type"],
            commentsCount: data["comments_count"],
            likesCount: data["likes_count"],
            isliked: data["is_liked"],
            playerImage: data["player_image"],
            PlayerName: data["player_name"],
            ItemName: data["item_name"],
            announcement_comments: data["announcement_comments"] != null
                ? (data["announcement_comments"] as List)
                    .map((e) => AnnounceCommentModel.fromMap(e))
                    .toList()
                    .reversed
                    .toList()
                : [],
            announcement_likes: data["announcement_likes"] != null
                ? (data["announcement_likes"] as List)
                    .map((e) => AnnounceLikeModel.fromMap(e))
                    .toList()
                : []);
        Map<String, dynamic> d = {
          "type": "announcement",
          "model": a,
        };
        setFeed = d;
        break;
      default:
    }
  }

  void addComment(int index, CommentModel comment, bool loadmore) {
    CommentModel addComment = comment;
    addComment.sub_comment_count = comment.sub_comment_count ?? 0;

    try {
      PostModel postModel = PostModel(
          id: profileFeed[index]["model"].id,
          player_name: profileFeed[index]["model"].player_name,
          player_image: profileFeed[index]["model"].player_image,
          player_id: profileFeed[index]["model"].player_id,
          type: profileFeed[index]["model"].type,
          date_created: profileFeed[index]["model"].date_created,
          date_updated: profileFeed[index]["model"].date_updated,
          description: profileFeed[index]["model"].description,
          media_type: profileFeed[index]["model"].media_type,
          media_url: profileFeed[index]["model"].media_url,
          quiz: profileFeed[index]["model"].quiz,
          quiz_answers: profileFeed[index]["model"].quiz_answers,
          quiz_category: profileFeed[index]["model"].quiz_category,
          quiz_level_id: profileFeed[index]["model"].quiz_level_id,
          quiz_status: profileFeed[index]["model"].quiz_status,
          end_time: profileFeed[index]["model"].end_time,
          pointz: profileFeed[index]["model"].pointz,
          minus_pointz: profileFeed[index]["model"].minus_pointz,
          post_comments:
              profileFeed[index]["model"].post_comments + [addComment],
          isLike: profileFeed[index]["model"].isLike,
          is_brand_verified: profileFeed[index]["model"].is_brand_verified,
          is_brand_acc: profileFeed[index]["model"].is_brand_acc,
          follow_status: profileFeed[index]["model"].follow_status,
          like_id: profileFeed[index]["model"].like_id,
          comments_count: loadmore
              ? profileFeed[index]["model"].comments_count
              : profileFeed[index]["model"].comments_count + 1,
          likes_count: profileFeed[index]["model"].likes_count);

      profileFeed[index]["model"] = postModel;
      update();
    } catch (e) {
      debugPrint("Error is $e");
    }
  }

  void addReplyComment(int index, int index2, Comments comment) {
    try {
      CommentModel commentModel = CommentModel(
        id: profileFeed[index]["model"].post_comments[index2].id,
        player_id: profileFeed[index]["model"].post_comments[index2].player_id,
        post_id: profileFeed[index]["model"].post_comments[index2].post_id,
        comment_id:
            profileFeed[index]["model"].post_comments[index2].comment_id,
        comment: profileFeed[index]["model"].post_comments[index2].comment,
        date_created:
            profileFeed[index]["model"].post_comments[index2].date_created,
        player_name:
            profileFeed[index]["model"].post_comments[index2].player_name,
        player_image:
            profileFeed[index]["model"].post_comments[index2].player_image,
        is_brand_verified:
            profileFeed[index]["model"].post_comments[index2].is_brand_verified,
        comments: profileFeed[index]["model"].post_comments[index2].comments +
            [comment],
        sub_comment_count:
            profileFeed[index]["model"].post_comments[index2].sub_comment_count,
      );

      profileFeed[index]["model"].post_comments[index2] = commentModel;
      debugPrint("post is ${profileFeed[index]["model"]}");
      update();
    } catch (e) {}
  }

  void addLike(int index, PostLikeModel like) {
    try {
      PostModel postModel = PostModel(
        id: profileFeed[index]["model"].id,
        player_name: profileFeed[index]["model"].player_name,
        player_image: profileFeed[index]["model"].player_image,
        player_id: profileFeed[index]["model"].player_id,
        type: profileFeed[index]["model"].type,
        date_created: profileFeed[index]["model"].date_created,
        date_updated: profileFeed[index]["model"].date_updated,
        description: profileFeed[index]["model"].description,
        media_type: profileFeed[index]["model"].media_type,
        media_url: profileFeed[index]["model"].media_url,
        quiz: profileFeed[index]["model"].quiz,
        quiz_answers: profileFeed[index]["model"].quiz_answers,
        quiz_category: profileFeed[index]["model"].quiz_category,
        quiz_level_id: profileFeed[index]["model"].quiz_level_id,
        quiz_status: profileFeed[index]["model"].quiz_status,
        end_time: profileFeed[index]["model"].end_time,
        pointz: profileFeed[index]["model"].pointz,
        minus_pointz: profileFeed[index]["model"].minus_pointz,
        post_comments: profileFeed[index]["model"].post_comments,
        is_brand_verified: profileFeed[index]["model"].is_brand_verified,
        is_brand_acc: profileFeed[index]["model"].is_brand_acc,
        follow_status: profileFeed[index]["model"].follow_status,
        comments_count: profileFeed[index]["model"].comments_count,
        likes_count: profileFeed[index]["model"].likes_count + 1,
        like_id: like.id,
        isLike: true,
      );

      profileFeed[index]["model"] = postModel;

      update();
    } catch (e) {}
  }

  void removeLike(
    int index,
  ) {
    try {
      PostModel postModel = PostModel(
        id: profileFeed[index]["model"].id,
        player_name: profileFeed[index]["model"].player_name,
        player_image: profileFeed[index]["model"].player_image,
        player_id: profileFeed[index]["model"].player_id,
        type: profileFeed[index]["model"].type,
        date_created: profileFeed[index]["model"].date_created,
        date_updated: profileFeed[index]["model"].date_updated,
        description: profileFeed[index]["model"].description,
        media_type: profileFeed[index]["model"].media_type,
        media_url: profileFeed[index]["model"].media_url,
        quiz: profileFeed[index]["model"].quiz,
        quiz_answers: profileFeed[index]["model"].quiz_answers,
        quiz_category: profileFeed[index]["model"].quiz_category,
        quiz_level_id: profileFeed[index]["model"].quiz_level_id,
        quiz_status: profileFeed[index]["model"].quiz_status,
        end_time: profileFeed[index]["model"].end_time,
        pointz: profileFeed[index]["model"].pointz,
        minus_pointz: profileFeed[index]["model"].minus_pointz,
        post_comments: profileFeed[index]["model"].post_comments,
        is_brand_verified: profileFeed[index]["model"].is_brand_verified,
        is_brand_acc: profileFeed[index]["model"].is_brand_acc,
        follow_status: profileFeed[index]["model"].follow_status,
        comments_count: profileFeed[index]["model"].comments_count,
        likes_count: profileFeed[index]["model"].likes_count - 1,
        like_id: "",
        isLike: false,
      );
      profileFeed[index]["model"] = postModel;
      debugPrint("remove like from controller done ");
      update();
    } catch (e) {}
  }

  void removeComment(int index, int feedIndex) {
    try {
      debugPrint("feed index is $feedIndex comment index is $index");
      List<CommentModel> comments = profileFeed[index]["model"].post_comments;
      comments.removeAt(feedIndex);

      PostModel postModel = PostModel(
        id: profileFeed[index]["model"].id,
        player_name: profileFeed[index]["model"].player_name,
        player_image: profileFeed[index]["model"].player_image,
        player_id: profileFeed[index]["model"].player_id,
        type: profileFeed[index]["model"].type,
        date_created: profileFeed[index]["model"].date_created,
        date_updated: profileFeed[index]["model"].date_updated,
        description: profileFeed[index]["model"].description,
        media_type: profileFeed[index]["model"].media_type,
        media_url: profileFeed[index]["model"].media_url,
        quiz: profileFeed[index]["model"].quiz,
        quiz_answers: profileFeed[index]["model"].quiz_answers,
        quiz_category: profileFeed[index]["model"].quiz_category,
        quiz_level_id: profileFeed[index]["model"].quiz_level_id,
        quiz_status: profileFeed[index]["model"].quiz_status,
        end_time: profileFeed[index]["model"].end_time,
        pointz: profileFeed[index]["model"].pointz,
        minus_pointz: profileFeed[index]["model"].minus_pointz,
        post_comments: comments,
        is_brand_verified: profileFeed[index]["model"].is_brand_verified,
        is_brand_acc: profileFeed[index]["model"].is_brand_acc,
        follow_status: profileFeed[index]["model"].follow_status,
        comments_count: profileFeed[index]["model"].comments_count - 1,
        likes_count: profileFeed[index]["model"].likes_count,
        like_id: profileFeed[index]["model"].like_id,
        isLike: false,
      );
      profileFeed[index]["model"] = postModel;
      debugPrint("comments removed success ");
      update();
    } catch (e) {
      print(e);
    }
  }

  void removeReplyComment(
      int index, int mainCommentIndex, int subCommentIndex) {
    try {
      debugPrint("feed index is $subCommentIndex comment index is $index");
      List<CommentModel> comments = profileFeed[index]["model"].post_comments;
      comments[mainCommentIndex].sub_comment_count - 1;
      comments[mainCommentIndex].comments.removeAt(subCommentIndex);

      PostModel postModel = PostModel(
        id: profileFeed[index]["model"].id,
        player_name: profileFeed[index]["model"].player_name,
        player_image: profileFeed[index]["model"].player_image,
        player_id: profileFeed[index]["model"].player_id,
        type: profileFeed[index]["model"].type,
        date_created: profileFeed[index]["model"].date_created,
        date_updated: profileFeed[index]["model"].date_updated,
        description: profileFeed[index]["model"].description,
        media_type: profileFeed[index]["model"].media_type,
        media_url: profileFeed[index]["model"].media_url,
        quiz: profileFeed[index]["model"].quiz,
        quiz_answers: profileFeed[index]["model"].quiz_answers,
        quiz_category: profileFeed[index]["model"].quiz_category,
        quiz_level_id: profileFeed[index]["model"].quiz_level_id,
        quiz_status: profileFeed[index]["model"].quiz_status,
        end_time: profileFeed[index]["model"].end_time,
        pointz: profileFeed[index]["model"].pointz,
        minus_pointz: profileFeed[index]["model"].minus_pointz,
        is_brand_verified: profileFeed[index]["model"].is_brand_verified,
        is_brand_acc: profileFeed[index]["model"].is_brand_acc,
        follow_status: profileFeed[index]["model"].follow_status,
        comments_count: profileFeed[index]["model"].comments_count - 1,
        likes_count: profileFeed[index]["model"].likes_count,
        like_id: profileFeed[index]["model"].like_id,
        post_comments: comments,
        isLike: false,
      );
      profileFeed[index]["model"] = postModel;
      debugPrint("comments removed success ");
      update();
    } catch (e) {}
  }

  void addAnnounceComment(
      int index, AnnounceCommentModel comment, bool loadmore) {
    try {
      AnouncementModel postModel = AnouncementModel(
          campaignType: profileFeed[index]["model"].campaignType,
          id: profileFeed[index]["model"].id,
          playerId: profileFeed[index]["model"].playerId,
          dateCreated: profileFeed[index]["model"].dateCreated,
          dateUpdated: profileFeed[index]["model"].dateUpdated,
          description: profileFeed[index]["model"].description,
          endDate: profileFeed[index]["model"].endDate,
          media: profileFeed[index]["model"].media,
          mediaType: profileFeed[index]["model"].mediaType,
          mediaUrl: profileFeed[index]["model"].mediaUrl,
          name: profileFeed[index]["model"].name,
          placement: profileFeed[index]["model"].placement,
          redirectUrl: profileFeed[index]["model"].redirectUrl,
          startDate: profileFeed[index]["model"].startDate,
          text: profileFeed[index]["model"].text,
          type: profileFeed[index]["model"].type,
          commentsCount: loadmore
              ? profileFeed[index]["model"].commentsCount
              : profileFeed[index]["model"].commentsCount + 1,
          likesCount: profileFeed[index]["model"].likesCount,
          isliked: profileFeed[index]["model"].isliked,
          playerImage: profileFeed[index]["model"].playerImage,
          PlayerName: profileFeed[index]["model"].PlayerName,
          ItemName: profileFeed[index]["model"].ItemName,
          announcement_comments:
              profileFeed[index]["model"].announcement_comments + [comment],
          announcement_likes: profileFeed[index]["model"].announcement_likes);

      profileFeed[index]["model"] = postModel;
      debugPrint("post is ${profileFeed[index]["model"]}");
      update();
    } catch (e) {
      print(e);
    }
  }

  void addReplyAnnounceComment(
      int index, int index2, AnnounceComments comment, bool loadmore) {
    try {
      AnnounceCommentModel commentModel = AnnounceCommentModel(
        id: profileFeed[index]["model"].announcement_comments[index2].id,
        subCommentCount: loadmore
            ? profileFeed[index]["model"]
                .announcement_comments[index2]
                .subCommentCount
            : profileFeed[index]["model"]
                    .announcement_comments[index2]
                    .subCommentCount +
                1,
        player_id:
            profileFeed[index]["model"].announcement_comments[index2].player_id,
        announcement_id: profileFeed[index]["model"]
            .announcement_comments[index2]
            .announcement_id,
        comment_id: profileFeed[index]["model"]
            .announcement_comments[index2]
            .comment_id,
        comment:
            profileFeed[index]["model"].announcement_comments[index2].comment,
        date_created: profileFeed[index]["model"]
            .announcement_comments[index2]
            .date_created,
        player_name: profileFeed[index]["model"]
            .announcement_comments[index2]
            .player_name,
        player_image: profileFeed[index]["model"]
            .announcement_comments[index2]
            .player_image,
        is_brand_verified: profileFeed[index]["model"]
            .announcement_comments[index2]
            .is_brand_verified,
        comments:
            profileFeed[index]["model"].announcement_comments[index2].comments +
                [comment],
      );

      profileFeed[index]["model"].announcement_comments[index2] = commentModel;
      debugPrint("post is ${profileFeed[index]["model"]}");
      update();
    } catch (e) {
      print(e);
    }
  }

  void removeAnnounceComment(int index, int feedIndex) {
    try {
      debugPrint("feed index is $feedIndex comment index is $index");
      List<AnnounceCommentModel> comments =
          profileFeed[index]["model"].announcement_comments;
      comments.removeAt(feedIndex);

      AnouncementModel announceModel = AnouncementModel(
          campaignType: profileFeed[index]["model"].campaignType,
          id: profileFeed[index]["model"].id,
          playerId: profileFeed[index]["model"].playerId,
          dateCreated: profileFeed[index]["model"].dateCreated,
          dateUpdated: profileFeed[index]["model"].dateUpdated,
          description: profileFeed[index]["model"].description,
          endDate: profileFeed[index]["model"].endDate,
          media: profileFeed[index]["model"].media,
          mediaType: profileFeed[index]["model"].mediaType,
          mediaUrl: profileFeed[index]["model"].mediaUrl,
          name: profileFeed[index]["model"].name,
          placement: profileFeed[index]["model"].placement,
          redirectUrl: profileFeed[index]["model"].redirectUrl,
          startDate: profileFeed[index]["model"].startDate,
          text: profileFeed[index]["model"].text,
          type: profileFeed[index]["model"].type,
          commentsCount: profileFeed[index]["model"].commentsCount - 1,
          likesCount: profileFeed[index]["model"].likesCount,
          isliked: profileFeed[index]["model"].isliked,
          playerImage: profileFeed[index]["model"].playerImage,
          PlayerName: profileFeed[index]["model"].PlayerName,
          ItemName: profileFeed[index]["model"].ItemName,
          announcement_comments: comments,
          announcement_likes: profileFeed[index]["model"].announcement_likes);
      profileFeed[index]["model"] = announceModel;
      debugPrint("comments removed success ");
      update();
    } catch (e) {}
  }

  void removeReplyAnnounceComment(
      int index, int mainCommentIndex, int subCommentIndex) {
    try {
      debugPrint("feed index is $subCommentIndex comment index is $index");
      List<AnnounceCommentModel> comments =
          profileFeed[index]["model"].announcement_comments;
      comments[mainCommentIndex].subCommentCount -= 1;
      comments[mainCommentIndex].comments.removeAt(subCommentIndex);

      AnouncementModel announceModel = AnouncementModel(
          campaignType: profileFeed[index]["model"].campaignType,
          id: profileFeed[index]["model"].id,
          playerId: profileFeed[index]["model"].playerId,
          dateCreated: profileFeed[index]["model"].dateCreated,
          dateUpdated: profileFeed[index]["model"].dateUpdated,
          description: profileFeed[index]["model"].description,
          endDate: profileFeed[index]["model"].endDate,
          media: profileFeed[index]["model"].media,
          mediaType: profileFeed[index]["model"].mediaType,
          mediaUrl: profileFeed[index]["model"].mediaUrl,
          name: profileFeed[index]["model"].name,
          placement: profileFeed[index]["model"].placement,
          redirectUrl: profileFeed[index]["model"].redirectUrl,
          startDate: profileFeed[index]["model"].startDate,
          text: profileFeed[index]["model"].text,
          type: profileFeed[index]["model"].type,
          commentsCount: profileFeed[index]["model"].commentsCount,
          likesCount: profileFeed[index]["model"].likesCount,
          isliked: profileFeed[index]["model"].isliked,
          playerImage: profileFeed[index]["model"].playerImage,
          PlayerName: profileFeed[index]["model"].PlayerName,
          ItemName: profileFeed[index]["model"].ItemName,
          announcement_comments: comments,
          announcement_likes: profileFeed[index]["model"].announcement_likes);
      profileFeed[index]["model"] = announceModel;
      debugPrint("comments removed success ");
      update();
    } catch (e) {
      print(e);
    }
  }
}
