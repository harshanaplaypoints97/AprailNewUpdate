import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:play_pointz/Api/ApiV2/api_V2.dart';
import 'package:play_pointz/controllers/quiz_controller.dart';
import 'package:play_pointz/models/NewModelsV2/feed/anouncement_model.dart';
import 'package:play_pointz/models/NewModelsV2/feed/campings_models.dart';
import 'package:play_pointz/models/notificaitons/announce_comment_model.dart';
import 'package:play_pointz/models/notificaitons/announce_like_model.dart';
import 'package:play_pointz/models/post/comment_model.dart';
import 'package:play_pointz/models/post/like_model.dart';
import 'package:play_pointz/models/post/post_model.dart';
import 'package:play_pointz/models/store/upcomming_item_model.dart';

const String post = "post";
const String normalAd = "normalAd";
const String googleAd = "googleAd";
const String item = "item";
const String announcement = "announcement";
const String quiz = "quizz";

class FeedController extends GetxController {
  final QuizController quizController = Get.put(QuizController());

  RxList<Map<String, dynamic>> feeds = RxList([]);
  RxList<Map<String, dynamic>> comment = RxList([]);

  int postCount = 0;
  int remainCount = 0;
  bool isFineshed = false;

  set setFeed(Map<String, dynamic> feedData) => feeds.add(feedData);

  Future<bool> fetchDataFromApi({int offset = 0}) async {
    try {
      feeds.clear();
      Map response = await ApiV2().getHomeFeed(
          offSet: offset,
          limit: 10,
          count: postCount,
          remainCount: 0,
          isFinished: isFineshed);
      //  debugPrint("${response}");
      if (response["done"]) {
        List result = response["body"]["result"];
        postCount = response["body"]["post_count"];
        remainCount = response["body"]["remainCount"];
        isFineshed = response["body"]["is_finish_posts"];
        if (result.isEmpty) {
          return true;
        }
        feeds.clear();
        for (Map adData in result) {
          feedManager(adData);
        }
      }

      return false;
    } catch (e) {
      debugPrint("feed controller fetch data failed $e");
      return false;
    }
  }

  void feedManager(Map adData) {
    switch (adData["type"]) {
      case post:
        PostModel postModel = PostModel.fromMap(adData);

        Map<String, dynamic> data = {
          "type": post,
          "model": postModel,
        };

        setFeed = data;
        break;
      case normalAd:
        CampaignsModel campModel = CampaignsModel(
          id: adData["id"],
          campaignType: adData["campaign_type"],
          dateCreated: adData["date_created"],
          dateUpdated: adData["date_updated"],
          description: adData["description"],
          endDate: adData["id"],
          sponsorName: adData["sponsor_name"] ?? adData["name"],
          media: adData["media"],
          mediaType: adData["media_type"] ?? "",
          mediaUrl: adData["media_url"],
          name: adData["name"],
          placement: adData["placement"],
          redirectUrl: adData["redirect_url"],
          startDate: adData["start_date"],
          text: adData["text"],
          type: adData["type"] ?? "",
        );
        Map<String, dynamic> data = {
          "type": normalAd,
          "model": campModel,
        };
        setFeed = data;
        break;
      case googleAd:
        CampaignsModel campModel = CampaignsModel(
          id: adData["id"],
          campaignType: adData["campaign_type"],
          dateCreated: adData["date_created"],
          dateUpdated: adData["date_updated"],
          description: adData["description"],
          endDate: adData["id"],
          sponsorName: adData["sponsor_name"] ?? adData["name"],
          media: adData["media"],
          mediaType: adData["media_type"] ?? "",
          mediaUrl: adData["media_url"],
          name: adData["name"],
          placement: adData["placement"],
          redirectUrl: adData["redirect_url"],
          startDate: adData["start_date"],
          text: adData["text"],
          type: adData["type"] ?? "",
        );
        Map<String, dynamic> data = {
          "type": googleAd,
          "model": campModel,
        };
        setFeed = data;
        break;
      case item:
        Map data = adData;
        UpCommingItem itmModel = UpCommingItem(
          id: data["id"],
          itemCategoryId: data["item_category_id"],
          imageUrl: data["image_url"],
          stockAmount: data["stock_amount"],
          priceInPoints: data["price_in_points"],
          price: data["price"],
          name: data["name"],
          description: data["description"],
          dateCreated: data["date_created"],
          dateUpdated: data["date_updated"],
          startTime: data["start_time"],
          serverTime: data["server_time"],
          endTime: data["end_time"],
          eventId: data["event_id"],
          itemQuantity: data["item_quantity"],
          thumnailUrl: data["thumb_url"] ?? "",
          waiting_start_time: data["waiting_start_time"],
          waiting_end_time: data["waiting_end_time"],
        );
        Map<String, dynamic> d = {
          "type": item,
          "model": itmModel,
        };
        setFeed = d;
        break;
      case announcement:
        Map data = adData;
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
          "type": announcement,
          "model": a,
        };
        setFeed = d;
        break;
    }
  }

  Future<bool> feedReload(int offset) async {
    debugPrint("feed reload called offset is $offset");
    try {
      debugPrint("new feed is ${feeds.length}");

      //add new 10 elements to last 10
      Map response = await ApiV2().getHomeFeed(
          offSet: offset,
          limit: 10,
          count: postCount,
          remainCount: remainCount,
          isFinished: isFineshed);
      //  debugPrint("${response}");
      if (response["done"]) {
        List result = response["body"]["result"];
        postCount = response["body"]["post_count"];
        remainCount = response["body"]["remainCount"];
        isFineshed = response["body"]["is_finish_posts"];
        if (result.isEmpty) {
          return false;
        }
        //feeds.length > 15 ? feeds.removeRange(0, 10) : null;

        debugPrint(
            "Home feed controller feed list  length is ${result.length}");

        for (Map adData in result) {
          // debugPrint("result is ${adData["type"]} ${adData["id"]}");
          feedManager(adData);
        }
      }

      return true;
    } catch (e) {
      debugPrint("feed reload failed $e");
      return false;
    }
  }

  void addComment(int index, CommentModel comment, bool loadmore) {
    try {
      PostModel postModel = PostModel(
          id: feeds[index]["model"].id,
          player_name: feeds[index]["model"].player_name,
          player_image: feeds[index]["model"].player_image,
          player_id: feeds[index]["model"].player_id,
          type: feeds[index]["model"].type,
          date_created: feeds[index]["model"].date_created,
          date_updated: feeds[index]["model"].date_updated,
          description: feeds[index]["model"].description,
          media_type: feeds[index]["model"].media_type,
          media_url: feeds[index]["model"].media_url,
          quiz: feeds[index]["model"].quiz,
          quiz_answers: feeds[index]["model"].quiz_answers,
          quiz_category: feeds[index]["model"].quiz_category,
          quiz_level_id: feeds[index]["model"].quiz_level_id,
          quiz_status: feeds[index]["model"].quiz_status,
          end_time: feeds[index]["model"].end_time,
          pointz: feeds[index]["model"].pointz,
          minus_pointz: feeds[index]["model"].minus_pointz,
          post_comments: feeds[index]["model"].post_comments + [comment],
          isLike: feeds[index]["model"].isLike,
          is_brand_verified: feeds[index]["model"].is_brand_verified,
          is_brand_acc: feeds[index]["model"].is_brand_acc,
          follow_status: feeds[index]["model"].follow_status,
          like_id: feeds[index]["model"].like_id,
          comments_count: loadmore
              ? feeds[index]["model"].comments_count
              : feeds[index]["model"].comments_count += 1,
          likes_count: feeds[index]["model"].likes_count);

      feeds[index]["model"] = postModel;
      update();
    } catch (e) {
      debugPrint("Error is $e");
    }

    //debugPrint("post is ${feeds[index]["model"]}");
  }

  void followPage(int index) {
    try {
      for (var element in feeds) {
        if (element["type"] == "post") {
          if (element["model"].player_id == feeds[index]["model"].player_id) {
            element["model"].follow_status = 'follow';
          }
        }
      }
      // feeds[index]["model"] = postModel;
      debugPrint("post is ${feeds[index]["model"]}");
      update();
    } catch (e) {}
  }

  void addReplyComment(int index, int index2, Comments comment) {
    try {
      CommentModel commentModel = CommentModel(
        id: feeds[index]["model"].post_comments[index2].id,
        player_id: feeds[index]["model"].post_comments[index2].player_id,
        post_id: feeds[index]["model"].post_comments[index2].post_id,
        comment_id: feeds[index]["model"].post_comments[index2].comment_id,
        comment: feeds[index]["model"].post_comments[index2].comment,
        date_created: feeds[index]["model"].post_comments[index2].date_created,
        player_name: feeds[index]["model"].post_comments[index2].player_name,
        player_image: feeds[index]["model"].post_comments[index2].player_image,
        is_brand_verified:
            feeds[index]["model"].post_comments[index2].is_brand_verified,
        comments:
            feeds[index]["model"].post_comments[index2].comments += [comment],
        sub_comment_count:
            feeds[index]["model"].post_comments[index2].sub_comment_count,
      );

      feeds[index]["model"].post_comments[index2] = commentModel;
      debugPrint("post is ${feeds[index]["model"]}");
      update();
    } catch (e) {}
  }

  void addLike(int index, PostLikeModel like) {
    try {
      PostModel postModel = PostModel(
        id: feeds[index]["model"].id,
        player_name: feeds[index]["model"].player_name,
        player_image: feeds[index]["model"].player_image,
        player_id: feeds[index]["model"].player_id,
        type: feeds[index]["model"].type,
        date_created: feeds[index]["model"].date_created,
        date_updated: feeds[index]["model"].date_updated,
        description: feeds[index]["model"].description,
        media_type: feeds[index]["model"].media_type,
        media_url: feeds[index]["model"].media_url,
        quiz: feeds[index]["model"].quiz,
        quiz_answers: feeds[index]["model"].quiz_answers,
        quiz_category: feeds[index]["model"].quiz_category,
        quiz_level_id: feeds[index]["model"].quiz_level_id,
        quiz_status: feeds[index]["model"].quiz_status,
        end_time: feeds[index]["model"].end_time,
        pointz: feeds[index]["model"].pointz,
        minus_pointz: feeds[index]["model"].minus_pointz,
        post_comments: feeds[index]["model"].post_comments,
        is_brand_verified: feeds[index]["model"].is_brand_verified,
        is_brand_acc: feeds[index]["model"].is_brand_acc,
        follow_status: feeds[index]["model"].follow_status,
        comments_count: feeds[index]["model"].comments_count,
        likes_count: feeds[index]["model"].likes_count += 1,
        like_id: like.id,
        isLike: true,
      );

      feeds[index]["model"] = postModel;

      update();
    } catch (e) {}
  }

  void removeLike(
    int index,
  ) {
    try {
      PostModel postModel = PostModel(
        id: feeds[index]["model"].id,
        player_name: feeds[index]["model"].player_name,
        player_image: feeds[index]["model"].player_image,
        player_id: feeds[index]["model"].player_id,
        type: feeds[index]["model"].type,
        date_created: feeds[index]["model"].date_created,
        date_updated: feeds[index]["model"].date_updated,
        description: feeds[index]["model"].description,
        media_type: feeds[index]["model"].media_type,
        media_url: feeds[index]["model"].media_url,
        quiz: feeds[index]["model"].quiz,
        quiz_answers: feeds[index]["model"].quiz_answers,
        quiz_category: feeds[index]["model"].quiz_category,
        quiz_level_id: feeds[index]["model"].quiz_level_id,
        quiz_status: feeds[index]["model"].quiz_status,
        end_time: feeds[index]["model"].end_time,
        pointz: feeds[index]["model"].pointz,
        minus_pointz: feeds[index]["model"].minus_pointz,
        post_comments: feeds[index]["model"].post_comments,
        is_brand_verified: feeds[index]["model"].is_brand_verified,
        is_brand_acc: feeds[index]["model"].is_brand_acc,
        follow_status: feeds[index]["model"].follow_status,
        comments_count: feeds[index]["model"].comments_count,
        likes_count: feeds[index]["model"].likes_count -= 1,
        like_id: "",
        isLike: false,
      );
      feeds[index]["model"] = postModel;
      debugPrint("remove like from controller done ");
      update();
    } catch (e) {}
  }

  void removeComment(int index, int feedIndex) {
    try {
      debugPrint("feed index is $feedIndex comment index is $index");
      List<CommentModel> comments = feeds[index]["model"].post_comments;
      comments.removeAt(feedIndex);

      PostModel postModel = PostModel(
        id: feeds[index]["model"].id,
        player_name: feeds[index]["model"].player_name,
        player_image: feeds[index]["model"].player_image,
        player_id: feeds[index]["model"].player_id,
        type: feeds[index]["model"].type,
        date_created: feeds[index]["model"].date_created,
        date_updated: feeds[index]["model"].date_updated,
        description: feeds[index]["model"].description,
        media_type: feeds[index]["model"].media_type,
        media_url: feeds[index]["model"].media_url,
        quiz: feeds[index]["model"].quiz,
        quiz_answers: feeds[index]["model"].quiz_answers,
        quiz_category: feeds[index]["model"].quiz_category,
        quiz_level_id: feeds[index]["model"].quiz_level_id,
        quiz_status: feeds[index]["model"].quiz_status,
        end_time: feeds[index]["model"].end_time,
        pointz: feeds[index]["model"].pointz,
        minus_pointz: feeds[index]["model"].minus_pointz,
        post_comments: comments,
        is_brand_verified: feeds[index]["model"].is_brand_verified,
        is_brand_acc: feeds[index]["model"].is_brand_acc,
        follow_status: feeds[index]["model"].follow_status,
        comments_count: feeds[index]["model"].comments_count -= 1,
        likes_count: feeds[index]["model"].likes_count,
        like_id: feeds[index]["model"].like_id,
        isLike: false,
      );
      feeds[index]["model"] = postModel;
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
      List<CommentModel> comments = feeds[index]["model"].post_comments;
      comments[mainCommentIndex].sub_comment_count -= 1;
      // feeds[index]["model"].post_comments[index2].comments + [comment],
      comments[mainCommentIndex].comments.removeAt(subCommentIndex);
      //comments.removeAt(subCommentIndex);

      PostModel postModel = PostModel(
        id: feeds[index]["model"].id,
        player_name: feeds[index]["model"].player_name,
        player_image: feeds[index]["model"].player_image,
        player_id: feeds[index]["model"].player_id,
        type: feeds[index]["model"].type,
        date_created: feeds[index]["model"].date_created,
        date_updated: feeds[index]["model"].date_updated,
        description: feeds[index]["model"].description,
        media_type: feeds[index]["model"].media_type,
        media_url: feeds[index]["model"].media_url,
        quiz: feeds[index]["model"].quiz,
        quiz_answers: feeds[index]["model"].quiz_answers,
        quiz_category: feeds[index]["model"].quiz_category,
        quiz_level_id: feeds[index]["model"].quiz_level_id,
        quiz_status: feeds[index]["model"].quiz_status,
        end_time: feeds[index]["model"].end_time,
        pointz: feeds[index]["model"].pointz,
        minus_pointz: feeds[index]["model"].minus_pointz,
        is_brand_verified: feeds[index]["model"].is_brand_verified,
        is_brand_acc: feeds[index]["model"].is_brand_acc,
        follow_status: feeds[index]["model"].follow_status,
        comments_count: feeds[index]["model"].comments_count,
        likes_count: feeds[index]["model"].likes_count,
        like_id: feeds[index]["model"].like_id,
        post_comments: comments,
        isLike: false,
      );
      feeds[index]["model"] = postModel;
      debugPrint("comments removed success ");
      update();
    } catch (e) {}
  }

  void addAnnounceComment(
      int index, AnnounceCommentModel comment, bool loadmore) {
    try {
      AnouncementModel postModel = AnouncementModel(
          campaignType: feeds[index]["model"].campaignType,
          id: feeds[index]["model"].id,
          playerId: feeds[index]["model"].playerId,
          dateCreated: feeds[index]["model"].dateCreated,
          dateUpdated: feeds[index]["model"].dateUpdated,
          description: feeds[index]["model"].description,
          endDate: feeds[index]["model"].endDate,
          media: feeds[index]["model"].media,
          mediaType: feeds[index]["model"].mediaType,
          mediaUrl: feeds[index]["model"].mediaUrl,
          name: feeds[index]["model"].name,
          placement: feeds[index]["model"].placement,
          redirectUrl: feeds[index]["model"].redirectUrl,
          startDate: feeds[index]["model"].startDate,
          text: feeds[index]["model"].text,
          type: feeds[index]["model"].type,
          commentsCount: loadmore
              ? feeds[index]["model"].commentsCount
              : feeds[index]["model"].commentsCount += 1,
          likesCount: feeds[index]["model"].likesCount,
          isliked: feeds[index]["model"].isliked,
          playerImage: feeds[index]["model"].playerImage,
          PlayerName: feeds[index]["model"].PlayerName,
          ItemName: feeds[index]["model"].ItemName,
          announcement_comments:
              feeds[index]["model"].announcement_comments += [comment],
          announcement_likes: feeds[index]["model"].announcement_likes);

      feeds[index]["model"] = postModel;
      debugPrint("post is ${feeds[index]["model"]}");
      update();
    } catch (e) {
      print(e);
    }
  }

  void addReplyAnnounceComment(
      int index, int index2, AnnounceComments comment, bool loadmore) {
    try {
      AnnounceCommentModel commentModel = AnnounceCommentModel(
        id: feeds[index]["model"].announcement_comments[index2].id,
        subCommentCount: loadmore
            ? feeds[index]["model"]
                .announcement_comments[index2]
                .subCommentCount
            : feeds[index]["model"]
                .announcement_comments[index2]
                .subCommentCount += 1,
        player_id:
            feeds[index]["model"].announcement_comments[index2].player_id,
        announcement_id:
            feeds[index]["model"].announcement_comments[index2].announcement_id,
        comment_id:
            feeds[index]["model"].announcement_comments[index2].comment_id,
        comment: feeds[index]["model"].announcement_comments[index2].comment,
        date_created:
            feeds[index]["model"].announcement_comments[index2].date_created,
        player_name:
            feeds[index]["model"].announcement_comments[index2].player_name,
        player_image:
            feeds[index]["model"].announcement_comments[index2].player_image,
        is_brand_verified: feeds[index]["model"]
            .announcement_comments[index2]
            .is_brand_verified,
        comments: feeds[index]["model"]
            .announcement_comments[index2]
            .comments += [comment],
      );

      feeds[index]["model"].announcement_comments[index2] = commentModel;
      debugPrint("post is ${feeds[index]["model"]}");
      update();
    } catch (e) {
      print(e);
    }
  }

  void removeAnnounceComment(int index, int feedIndex) {
    try {
      debugPrint("feed index is $feedIndex comment index is $index");
      List<AnnounceCommentModel> comments =
          feeds[index]["model"].announcement_comments;
      comments.removeAt(feedIndex);

      AnouncementModel announceModel = AnouncementModel(
          campaignType: feeds[index]["model"].campaignType,
          id: feeds[index]["model"].id,
          playerId: feeds[index]["model"].playerId,
          dateCreated: feeds[index]["model"].dateCreated,
          dateUpdated: feeds[index]["model"].dateUpdated,
          description: feeds[index]["model"].description,
          endDate: feeds[index]["model"].endDate,
          media: feeds[index]["model"].media,
          mediaType: feeds[index]["model"].mediaType,
          mediaUrl: feeds[index]["model"].mediaUrl,
          name: feeds[index]["model"].name,
          placement: feeds[index]["model"].placement,
          redirectUrl: feeds[index]["model"].redirectUrl,
          startDate: feeds[index]["model"].startDate,
          text: feeds[index]["model"].text,
          type: feeds[index]["model"].type,
          commentsCount: feeds[index]["model"].commentsCount -= 1,
          likesCount: feeds[index]["model"].likesCount,
          isliked: feeds[index]["model"].isliked,
          playerImage: feeds[index]["model"].playerImage,
          PlayerName: feeds[index]["model"].PlayerName,
          ItemName: feeds[index]["model"].ItemName,
          announcement_comments: comments,
          announcement_likes: feeds[index]["model"].announcement_likes);
      feeds[index]["model"] = announceModel;
      debugPrint("comments removed success ");
      update();
    } catch (e) {}
  }

  void removeReplyAnnounceComment(
      int index, int mainCommentIndex, int subCommentIndex) {
    try {
      debugPrint("feed index is $subCommentIndex comment index is $index");
      List<AnnounceCommentModel> comments =
          feeds[index]["model"].announcement_comments;
      comments[mainCommentIndex].subCommentCount -= 1;
      // feeds[index]["model"].post_comments[index2].comments + [comment],
      comments[mainCommentIndex].comments.removeAt(subCommentIndex);
      //comments.removeAt(subCommentIndex);

      AnouncementModel announceModel = AnouncementModel(
          campaignType: feeds[index]["model"].campaignType,
          id: feeds[index]["model"].id,
          playerId: feeds[index]["model"].playerId,
          dateCreated: feeds[index]["model"].dateCreated,
          dateUpdated: feeds[index]["model"].dateUpdated,
          description: feeds[index]["model"].description,
          endDate: feeds[index]["model"].endDate,
          media: feeds[index]["model"].media,
          mediaType: feeds[index]["model"].mediaType,
          mediaUrl: feeds[index]["model"].mediaUrl,
          name: feeds[index]["model"].name,
          placement: feeds[index]["model"].placement,
          redirectUrl: feeds[index]["model"].redirectUrl,
          startDate: feeds[index]["model"].startDate,
          text: feeds[index]["model"].text,
          type: feeds[index]["model"].type,
          commentsCount: feeds[index]["model"].commentsCount,
          likesCount: feeds[index]["model"].likesCount,
          isliked: feeds[index]["model"].isliked,
          playerImage: feeds[index]["model"].playerImage,
          PlayerName: feeds[index]["model"].PlayerName,
          ItemName: feeds[index]["model"].ItemName,
          announcement_comments: comments,
          announcement_likes: feeds[index]["model"].announcement_likes);
      feeds[index]["model"] = announceModel;
      debugPrint("comments removed success ");
      update();
    } catch (e) {}
  }

  @override
  void onInit() {
    feeds.clear();
    fetchDataFromApi().then((value) => update());
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
