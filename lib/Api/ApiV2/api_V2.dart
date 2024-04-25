import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:play_pointz/models/NewModelsV2/feed/announcement_comments.dart';
import 'package:play_pointz/models/NewModelsV2/feed/announcement_sub_comments.dart';
import 'package:play_pointz/models/feed/post_comment.dart';
import 'package:play_pointz/models/feed/post_sub_comment.dart';

import '../../config.dart';
import '../../models/NewModelsV2/Profile/my_post_model.dart';

import '../../models/NewModelsV2/store/resent_winners.dart';
import '../../services/app_interceptors.dart';

class ApiV2 {
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

  Future<MyPosts> getPostById({String id, String version = thisVersion}) async {
    try {
      await setCookie();
      Response response = await _dio.get(
          '$baseUrl/api/v1/player-post-controller-player-friend/$id?type=player&version=$version');
      return MyPosts.fromJson(response.data);
    } catch (e) {
      debugPrint("fetch feed posts failed $e");
      return e;
    }
  }

  deletePost({String postId}) async {
    try {
      await setCookie();
      Response response = await _dio
          .delete('$baseUrl/api/v1/player-post-controller-player/$postId');

      return response.data;
    } catch (e) {
      debugPrint("fetch feed posts failed $e");
      return e;
    }
  }

  Future<Map> checkForgetToken({String token, String email}) async {
    try {
      await setCookie();
      Response response =
          await _dio.get('$baseUrl/auth/reset-password/$token/$email');

      return response.data;
    } catch (e) {
      debugPrint("check forget token failed $e");
      return {"error": e};
    }
  }

  Future<bool> resetPassword({String password, String email}) async {
    try {
      await setCookie();
      Response response =
          await _dio.post('$baseUrl/auth/reset-password', data: {
        'password': password,
        'email': email,
      });
      debugPrint("reset password response is ${response.data}");
      return response.data['done'];
    } catch (e) {
      debugPrint("check forget token failed $e");
      return false;
    }
  }

  Future<Map> getHomeFeed(
      {int offSet = 0,
      int limit = 10,
      int count = 0,
      int remainCount = 0,
      bool isFinished = false}) async {
    try {
      /* final newVersionPlus = NewVersionPlus();
      final version = await newVersionPlus.getVersionStatus();                                      
      String localVersion = version.localVersion; */

      String localVersion = thisVersion;

      final now = DateTime.now();
      await setCookie();
      Response response = await _dio.get(
          '$baseUrl/api/v1/player-post-controller-player?offset=$offSet&limit=$limit&timestamp=$now&is_finish_posts=$isFinished&post_count=$count&remainCount=$remainCount&version=$localVersion');

      return response.data;
    } catch (e) {
      debugPrint("check forget token failed $e");
      return {"error": e};
    }
  }

  Future<Map> getProfileFeed(
      {int offSet,
      String type,
      int limit = 10,
      int count = 0,
      int remainCount = 0,
      String id,
      bool isFinished = false}) async {
    try {
      await setCookie();
      Response response = await _dio.get(
          '$baseUrl/api/v1//player-post-controller-player-friend-new/$id?offset=$offSet&limit=$limit&type=$type');

      return response.data;
    } catch (e) {
      debugPrint("check forget token failed $e");
      return {"error": e};
    }
  }

  Future<PostCommentsModel> GetPostComments(
      {String id, int offset, int limit, int commentCount = 0}) async {
    try {
      await setCookie();
      Response response = await _dio.get(
          '$baseUrl/api/v1/player-post-controller-player-comments/$id?offset=$offset&limit=$limit&comment_count=$commentCount');

      //return response.data;
      return PostCommentsModel.fromJson(response.data);
    } catch (e) {
      debugPrint("check forget token failed $e");
      // return {"error": e};
    }
  }

  Future<AnnouncementComments> GetAnnouncementComments(
      {String id, int offset, int limit, int commentCount = 0}) async {
    try {
      await setCookie();
      Response response = await _dio.get(
          '$baseUrl/api/v1/player-post-controller-player-announcement-comments/$id?offset=$offset&limit=$limit&comment_count=$commentCount');

      //return response.data;
      return AnnouncementComments.fromJson(response.data);
    } catch (e) {
      debugPrint("check forget token failed $e");
      // return {"error": e};
    }
  }

  Future<AnnouncementSubComments> GetAnnouncementSubComments(
      {String id, int offset, int limit, int commentCount = 0}) async {
    try {
      await setCookie();
      Response response = await _dio.get(
          '$baseUrl/api/v1/player-post-controller-player-announcement-sub-comments/$id?offset=$offset&limit=$limit&comment_count=$commentCount');

      //return response.data;
      return AnnouncementSubComments.fromJson(response.data);
    } catch (e) {
      debugPrint("check forget token failed $e");
      // return {"error": e};
    }
  }

  Future<PostSubCommentsModel> GetPostSubComments(
      {String id, int offset, int limit, int commentCount = 0}) async {
    try {
      await setCookie();
      Response response = await _dio.get(
          '$baseUrl/api/v1/player-post-controller-player-sub-comments/$id?offset=$offset&limit=$limit&comment_count=$commentCount');

      //return response.data;
      return PostSubCommentsModel.fromJson(response.data);
    } catch (e) {
      debugPrint("check forget token failed $e");
      // return {"error": e};
    }
  }

  Future<Map> deleteComment(String id) async {
    try {
      await setCookie();
      Response response =
          await _dio.delete('$baseUrl/api/v1/post-comments-controller/$id');

      return response.data;
    } catch (e) {
      debugPrint("check forget token failed $e");
      return {"error": e};
    }
  }

  Future<Map> deleteAnounceComment(String id) async {
    try {
      await setCookie();
      Response response = await _dio
          .delete('$baseUrl/api/v1/announcement-comments-controller/$id');

      return response.data;
    } catch (e) {
      debugPrint("check forget token failed $e");
      return {"error": e};
    }
  }

  Future<ResentWinners> getResentWinners() async {
    try {
      await setCookie();
      final response = await _dio
          .get('$baseUrl/api/v1/order-controller-players?offset=0&limit=10');
      return ResentWinners.fromJson(response.data);
    } catch (e) {
      debugPrint("check forget token failed $e");
      throw Exception(e);
    }
  }
}
