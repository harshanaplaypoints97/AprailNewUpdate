import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/models/NewModelsV2/feed/single_announcement2.dart';
import 'package:play_pointz/models/Orders.dart';
import 'package:play_pointz/models/firstloginpoints.dart';
import 'package:play_pointz/models/friends/freiends_model.dart';
import 'package:play_pointz/models/friends/friend_suggession_model.dart';
import 'package:play_pointz/models/get_reffaral_points.dart';
import 'package:play_pointz/models/home/UnReadNoti.dart';
import 'package:play_pointz/models/home/popup_banner.dart';
import 'package:play_pointz/models/markertPlace/MarkertPlacePlayerItem.dart';
import 'package:play_pointz/models/markertPlace/MarkertPlace_Profile_Item.dart';
import 'package:play_pointz/models/notificaitons/announce_like_model.dart';
import 'package:play_pointz/models/notificaitons/notification_model.dart';
import 'package:play_pointz/models/notificaitons/submit_wish.dart';
import 'package:play_pointz/models/add_friend.dart';
import 'package:play_pointz/models/check_plyer_login.dart';
import 'package:play_pointz/models/feed/create_post.dart';
import 'package:play_pointz/models/feed/post_react.dart';
import 'package:play_pointz/models/feed/submit_comment.dart';
import 'package:play_pointz/models/friendrequest_response.dart';
import 'package:play_pointz/models/getAds.dart';
import 'package:play_pointz/models/get_friends.dart';
import 'package:play_pointz/models/get_items.dart';
import 'package:play_pointz/models/get_notifi_settings.dart';
import 'package:play_pointz/models/get_player_profile.dart';
import 'package:play_pointz/models/get_players.dart';
import 'package:play_pointz/models/item_categories.dart';
import 'package:play_pointz/models/log_out.dart';
import 'package:play_pointz/models/notification_settings.dart';
import 'package:play_pointz/models/play/game_earned_points.dart';
import 'package:play_pointz/models/play/game_token.dart';
import 'package:play_pointz/models/play/new_quiz_model.dart';
import 'package:play_pointz/models/play/play_section_data.dart';
import 'package:play_pointz/models/play/submit_answer.dart';
import 'package:play_pointz/models/player_points.dart';
import 'package:play_pointz/models/post/like_model.dart';
import 'package:play_pointz/models/post/post_model.dart';
import 'package:play_pointz/models/profile/brand_page_categories.dart';
import 'package:play_pointz/models/profile/privacy_options.dart';
import 'package:play_pointz/models/profile/profile_comment.dart';
import 'package:play_pointz/models/profile/support_reply.dart';
import 'package:play_pointz/models/purchase_item.dart';
import 'package:play_pointz/models/reset_password.dart';
import 'package:play_pointz/models/search/friends_feed.dart';
import 'package:play_pointz/models/search_players.dart';
import 'package:play_pointz/models/send_mail_to_reset_pass.dart';
import 'package:play_pointz/models/send_support.dart';
import 'package:play_pointz/models/signUp.dart';
import 'package:play_pointz/models/login.dart';
import 'package:play_pointz/models/store/current_time.dart';
import 'package:play_pointz/models/store/new_category_model.dart';
import 'package:play_pointz/models/store/redeem_block.dart';
import 'package:play_pointz/models/updateNotifi.dart';
import 'package:play_pointz/models/update_acc_images.dart';
import 'package:play_pointz/models/update_password.dart';
import 'package:play_pointz/models/update_profile.dart';
import 'package:play_pointz/services/app_interceptors.dart';
import '../../models/Story New/Create_Story_Model.dart';
import '../../models/Story New/Story_Model.dart';
import '../../models/markertPlace/markertPlace.dart';

class ApiStory {
  final Dio _dio = Dio();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<Directory> get _localCoookieDirectory async {
    final path = await _localPath;
    final Directory dir = Directory(path + '/cookies');
    await dir.create();
    return dir;
  }

  Future<void> setCookie() async {
    try {
      final Directory dir = await _localCoookieDirectory;
      final cookiePath = dir.path;
      var persistentCookies = PersistCookieJar(
          ignoreExpires: true, storage: FileStorage(cookiePath));
      _dio.interceptors.add(CustomInterceptors());
      _dio.interceptors.add(CookieManager(
              persistentCookies) //this sets up _dio to persist cookies throughout subsequent requests
          );
      _dio.options = BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 500000,
        receiveTimeout: 500000,
        headers: {
          HttpHeaders.userAgentHeader: "PlayPointz-dio-all-head",
          "Connection": "keep-alive",
        },
      );
      // return '';
    } catch (error) {
      //errorMessage(defaultErrorMsg);
      debugPrint("set cookie failed $error");
    }
  }

  //////////////////////////////////////////////CreateStory/////////////////////////////////////////////////////
  Future<StoryCreateModel> createStory(
    List<Map<String, dynamic>> contentList,
    BuildContext context,
  ) async {
    try {
      // Assuming you have a method setCookie() to set the necessary cookie.
      await setCookie();

      // Now, make a request to create the marketplace item.
      Response response = await _dio.post(
        '$baseUrl/api/v1/story-controller?offset=0&limit=5',
        data: {"content": contentList},
      );
      if (response.statusCode == 200) {
        Logger().i(response);
        Navigator.pop(context);
      }

      return StoryCreateModel();
    } catch (e) {
      if (e.response.statusCode == 400) {
        StoryCreateModel result = StoryCreateModel();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        StoryCreateModel result = StoryCreateModel();
        result.message = 'Unauthorize.';
        return result;
      } else if (e.response.statusCode == 503) {
        StoryCreateModel result = StoryCreateModel();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        StoryCreateModel result = StoryCreateModel();
        result.message = "Something went wrong";
        return result;
      }
    }
  }

  Future<StoryModel> GetStory(int offset, int limit) async {
    try {
      await setCookie();
      Response response = await _dio
          .get('$baseUrl/api/v1/story-controller?offset=$offset&limit=$limit');

      return StoryModel.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        StoryModel result = StoryModel();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        StoryModel result = StoryModel();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        StoryModel result = StoryModel();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        StoryModel result = StoryModel();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<PlayerMarkertPlace> GetPlayerMarkertPlaceItem(
      int offset, int limit) async {
    try {
      await setCookie();
      Response response = await _dio.get(
          '$baseUrl/api/v1/marketplace-item-controller-player?offset=0&limit=$limit&category=All');

      return PlayerMarkertPlace.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        PlayerMarkertPlace result = PlayerMarkertPlace();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        PlayerMarkertPlace result = PlayerMarkertPlace();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        PlayerMarkertPlace result = PlayerMarkertPlace();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        PlayerMarkertPlace result = PlayerMarkertPlace();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<StoryModel> DeleateStory(String id, BuildContext context) async {
    try {
      await setCookie();
      Response response =
          await _dio.delete('$baseUrl/api/v1/story-controller/$id');
      Logger().i(response.data);

      // if (response.statusCode == 200) {
      //   Navigator.pop(context);
      // }

      return StoryModel.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        StoryModel result = StoryModel();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        StoryModel result = StoryModel();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        StoryModel result = StoryModel();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        StoryModel result = StoryModel();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<MarkertPlaceItem> UpdateMarkertPlaceItem(
    String itemid,
    String itemName,
    String itemDesc,
    String itemCategory,
    String itemPrice,
    List<Map<String, dynamic>> mediaList,
    BuildContext context,
  ) async {
    try {
      // Assuming you have a method setCookie() to set the necessary cookie.
      await setCookie();

      // Now, make a request to create the marketplace item.
      Response response = await _dio.put(
        '$baseUrl/api/v1/marketplace-item-controller/$itemid',
        data: {
          "item_name": itemName,
          "item_desc": itemDesc,
          "item_category": itemCategory,
          "item_price": itemPrice,
          "media": mediaList
        },
      );
      if (response.statusCode == 200) {
        Logger().i(response);

        Navigator.pop(context);
      }

      return MarkertPlaceItem();
    } catch (e) {
      if (e.response.statusCode == 400) {
        MarkertPlaceItem result = MarkertPlaceItem();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        MarkertPlaceItem result = MarkertPlaceItem();
        result.message = 'Unauthorize.';
        return result;
      } else if (e.response.statusCode == 503) {
        MarkertPlaceItem result = MarkertPlaceItem();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        MarkertPlaceItem result = MarkertPlaceItem();
        result.message = "Something went wrong";
        return result;
      }
    }
  }

  Future reportPost(String storyId, String desc) async {
    try {
      await setCookie();
      Response response = await _dio.post(
          '$baseUrl/api/v1/story-controller-report',
          data: {"story_id": storyId, "type": "spam", "description": desc});
      //  print(response.data['done']);

      return response.data['done'];
    } catch (e) {
      debugPrint("report post failed $e");
    }
  }

  Future AddCount(String storyId) async {
    try {
      await setCookie();
      Response response = await _dio
          .post('$baseUrl/api/v1/story-controller-view', data: {"id": storyId});
      //  print(response.data['done']);
      Logger().i(response.data);
      return response.data['done'];
    } catch (e) {
      debugPrint("report post failed $e");
    }
  }
}
