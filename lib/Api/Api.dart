import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

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

import '../models/markertPlace/markertPlace.dart';

class Api {
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

  Future<Map> getNewLogo() async {
    try {
      await setCookie();
      Response response = await _dio.get('$baseUrl/public/app-logo');

      return response.data;
    } catch (e) {
      debugPrint("get profile data failed $e");
      return {"error": e};
    }
  }

  Future<Login> checkEmailDomain(String email) async {
    try {
      await setCookie();
      Response response = await _dio.get('$baseUrl/auth/check-email/$email');
      //print(response.data);
      return Login.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        Login result = Login();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        Login result = Login();
        result.message = 'Unauthorize.';
        return result;
      } else if (e.response.statusCode == 503) {
        Login result = Login();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        Login result = Login();
        result.message = "Something went wrong";
        return result;
      }
    }
  }

  Future<Login> checkUserName(String userName) async {
    try {
      await setCookie();
      Response response = await _dio.get('$baseUrl/auth/check-user/$userName');
      //print(response.data);
      return Login.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        Login result = Login();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        Login result = Login();
        result.message = 'Unauthorize.';
        return result;
      } else if (e.response.statusCode == 503) {
        Login result = Login();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        Login result = Login();
        result.message = "Something went wrong";
        return result;
      }
    }
  }

  Future<Login> checkLogin() async {
    try {
      await setCookie();
      Response response = await _dio.get('$baseUrl/auth/check_login');
      //print(response.data);
      return Login.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        Login result = Login();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        Login result = Login();
        result.message = 'Unauthorize.';
        return result;
      } else if (e.response.statusCode == 503) {
        Login result = Login();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        Login result = Login();
        result.message = "Something went wrong";
        return result;
      }
    }
  }

  Future<Login> loginApi(String username, String password) async {
    try {
      await setCookie();
      Response response = await _dio.post('$baseUrl/auth/login',
          data: {'username': username, 'password': password});
    } catch (e) {
      if (e.response.statusCode == 302) {
        return checkLogin();
      } else {
        if (e.response.statusCode == 400) {
          Login result = Login();
          result.message = 'Bad Request.';
          return result;
        } else if (e.response.statusCode == 401) {
          Login result = Login();
          result.message = 'Unauthorize.';
          return result;
        } else if (e.response.statusCode == 503) {
          Login result = Login();
          result.message = 'Service Unavailable.';
          return result;
        } else {
          Login result = Login();
          result.message = "Something went wrong";
          return result;
        }
      }
    }
  }

  Future<NewSignUp> playerSignUp(
      String email,
      String userName,
      String gender,
      String fullname,
      String password,
      String ref_token,
      String deviceId) async {
    try {
      await setCookie();
      if (ref_token == null || ref_token == "" || ref_token == "null") {
        Response response =
            await _dio.post('$baseUrl/auth/player-controller', data: {
          'email': email,
          'username': userName,
          'password': password,
          'full_name': fullname,
          'gender': gender,
          'device_id': deviceId
        });
        debugPrint("------------------- register response ${response.data}");
        return NewSignUp.fromJson(response.data);
        /*  */
      } else {
        Response response = await _dio
            .post('$baseUrl/auth/player-controller?token=$ref_token', data: {
          'email': email,
          'username': userName,
          'password': password,
          'full_name': fullname,
          'gender': gender,
          'device_id': deviceId
        });
        debugPrint("------------------- register response ${response.data}");
        return NewSignUp.fromJson(response.data);
      }
    } catch (e) {}
  }

  Future<SendMailToResetPass> sendEmailForgotPassword(String email) async {
    try {
      await setCookie();
      Response response = await _dio
          .post('$baseUrl/auth/forgot-password', data: {'email': email});
      debugPrint(
          "------------------- send foreget password email ${response.data}");
      return SendMailToResetPass.fromJson(response.data);
    } catch (e) {
      debugPrint("-------------------- send forgetpassword email failed $e");
      if (e.response.statusCode == 400) {
        SendMailToResetPass result = SendMailToResetPass();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        SendMailToResetPass result = SendMailToResetPass();
        result.message = 'Unauthorize.';
        return result;
      } else if (e.response.statusCode == 503) {
        SendMailToResetPass result = SendMailToResetPass();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        SendMailToResetPass result = SendMailToResetPass();
        result.message = "Something went wrong";
        return result;
      }
    }
  }

  Future<ResetPassword> resetPassword(String password, String token) async {
    try {
      await setCookie();
      Response response =
          await _dio.post('$baseUrl/auth/reset-password/$token', data: {
        'password': password,
      });
      return ResetPassword.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        ResetPassword result = ResetPassword();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        ResetPassword result = ResetPassword();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        ResetPassword result = ResetPassword();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        ResetPassword result = ResetPassword();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<CheckPlayerLogin> playerLoginCheck(
      {String version, String deviceId, String fcm}) async {
    try {
      // String fcmToken = await _fcm.getToken();
      String fcmToken = fcm;
      String platform = Platform.operatingSystem.toLowerCase();

      await setCookie();
      Response response = await _dio.get(
          '$baseUrl/auth/verify?version=$version&device_id=$deviceId&token=$fcmToken&platform=$platform');
      return CheckPlayerLogin.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        CheckPlayerLogin result = CheckPlayerLogin();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        CheckPlayerLogin result = CheckPlayerLogin();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        CheckPlayerLogin result = CheckPlayerLogin();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        CheckPlayerLogin result = CheckPlayerLogin();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<FistLoginPoints> getfirstloginpoints() async {
    try {
      await setCookie();
      Response response =
          await _dio.get('$baseUrl/api/v1/player-controller-player-point');
      return FistLoginPoints.fromJson(response.data);
    } catch (e) {}
  }

  Future<GetRefarralPoints> getRefPoints(BuildContext context) async {
    try {
      await setCookie();
      Response response =
          await _dio.get('$baseUrl/api/v1/player-controller-player-ref-point');
      return GetRefarralPoints.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 401) {
        ForceLogOutClass forceLogOutClass = ForceLogOutClass(context);
        forceLogOutClass.forceLogOut();
      }
    }
  }

  Future<LogOut> PlayerLogOut() async {
    try {
      await setCookie();
      Response response = await _dio.get('$baseUrl/auth/logout');
      return LogOut.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        LogOut result = LogOut();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        LogOut result = LogOut();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        LogOut result = LogOut();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        LogOut result = LogOut();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<LogOut> playerDeactivate(
      {String userName, String email, String password}) async {
    try {
      await setCookie();
      Response response = await _dio.post(
          '$baseUrl/api/v1/player-controller-player-delete',
          data: {"username": userName, "email": email, "password": password});
      return LogOut.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        LogOut result = LogOut();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        LogOut result = LogOut();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        LogOut result = LogOut();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        LogOut result = LogOut();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<Map> getProfiledata() async {
    try {
      await setCookie();
      Response response =
          await _dio.get('$baseUrl/api/v1/player-controller-player');

      return response.data;
    } catch (e) {
      debugPrint("get profile data failed $e");
      return {"error": e};
    }
  }

  Future<Map> sendDailyCoingAddinReq() async {
    try {
      await setCookie();
      Response response =
          await _dio.get('$baseUrl/api/v1/player-controller-player-config');
      debugPrint("dauly adding coin response ${response.data}");
      return response.data;
    } catch (e) {
      debugPrint("get daily coin update balance failed $e");
      return {"error": e};
    }
  }

  Future<UpdateAccImages> setProfileImages(
      String imgType, String profileImage) async {
    try {
      await setCookie();
      Response response = await _dio
          .put('$baseUrl/api/v1/player-controller-player-images', data: {
        "type": imgType,
        "profile_image": profileImage.toString(),
      });
      return UpdateAccImages.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        UpdateAccImages result = UpdateAccImages();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        UpdateAccImages result = UpdateAccImages();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        UpdateAccImages result = UpdateAccImages();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        UpdateAccImages result = UpdateAccImages();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<UpdateAccImages> setCoverImages(
      String imgType, String coverImage) async {
    try {
      await setCookie();
      Response response = await _dio.put(
          '$baseUrl/api/v1/player-controller-player-images',
          data: {"type": imgType, "cover_image": coverImage});
      return UpdateAccImages.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        UpdateAccImages result = UpdateAccImages();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        UpdateAccImages result = UpdateAccImages();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        UpdateAccImages result = UpdateAccImages();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        UpdateAccImages result = UpdateAccImages();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<UpdateProfData> updateUserDetails(
      String email,
      String userName,
      String gender,
      String fullname,
      String country,
      String birthDay,
      String houseNo,
      String street,
      String city,
      String district,
      String zipCode,
      String address,
      String contact,
      String description,
      String website) async {
    try {
      await setCookie();
      Response response =
          await _dio.put('$baseUrl/api/v1/player-controller-player', data: {
        'email': email,
        'username': userName,
        'country': country,
        'full_name': fullname,
        'gender': gender,
        'date_of_birth': birthDay,
        'house_no': houseNo,
        'street': street,
        "city": city,
        'district': district,
        'zip_code': zipCode,
        'address': address,
        'contact_no': contact,
        'description': description,
        'web': website,
      });

      //  debugPrint("update profile data repsonse ${response.data}");

      return UpdateProfData.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        UpdateProfData result = UpdateProfData();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        UpdateProfData result = UpdateProfData();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        UpdateProfData result = UpdateProfData();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        UpdateProfData result = UpdateProfData();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<NotifiSettings> updateNotiSettings(
      {bool notification, bool emailpuh}) async {
    try {
      await setCookie();
      Response response = await _dio
          .put('$baseUrl/api/v1/player-settings-controller', data: {
        "is_push_notification": notification,
        "is_email_notification": emailpuh
      });
      return NotifiSettings.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        NotifiSettings result = NotifiSettings();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        NotifiSettings result = NotifiSettings();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        NotifiSettings result = NotifiSettings();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        NotifiSettings result = NotifiSettings();
        result.done = false;
        result.message = "Something went wrong";
        return result;
      }
    }
  }

  Future<UpdatePassword> updatePassword(
      {String email, String currenPW, String newPW}) async {
    try {
      await setCookie();
      debugPrint("updatre a called");
      Response response = await _dio
          .put('$baseUrl/api/v1/player-controller-player-password', data: {
        "password": currenPW,
        "new_password": newPW,
      });

      debugPrint("change password response is ${response.data}");
      return UpdatePassword.fromJson(response.data);
    } catch (e) {
      debugPrint("update player password faled $e");
      return null;
    }
  }

  Future<GetNotifiSettings> getNotifiSettings() async {
    try {
      await setCookie();
      Response response = await _dio.get(
        '$baseUrl/api/v1/player-settings-controller',
      );
      return GetNotifiSettings.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        GetNotifiSettings result = GetNotifiSettings();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        GetNotifiSettings result = GetNotifiSettings();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        GetNotifiSettings result = GetNotifiSettings();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        GetNotifiSettings result = GetNotifiSettings();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<SendSupport> sendSupport(
      {String name,
      String contactNu,
      String subject,
      String comment,
      String support_id,
      String image_url,
      String type}) async {
    try {
      await setCookie();
      Response response = await _dio.post(
          '$baseUrl/api/v1/player-support-controller?version=$thisVersion',
          data: {
            "name": name,
            "contact_no": contactNu,
            "subject": subject,
            "comment": comment,
            "support_id": support_id,
            "image_url": image_url,
            "media_type": image_url != null ? "Image" : null,
          });
      debugPrint("send support request response ${response.data}");
      return SendSupport.fromJson(response.data);
    } catch (e) {
      debugPrint("send support request failed $e");
      return null;
    }
  }

  Future<SupportReply> getSupportReply({String id, String pId}) async {
    try {
      await setCookie();
      Response response = await _dio.get(
        '$baseUrl/api/v1/player-support-controller-player/$id?prv_id=$pId&version=$thisVersion',
      );
      return SupportReply.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        SupportReply result = SupportReply();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        SupportReply result = SupportReply();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        SupportReply result = SupportReply();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        SupportReply result = SupportReply();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<GetPlayers> getPlayers(BuildContext context) async {
    try {
      await setCookie();
      Response response = await _dio.get(
        '$baseUrl/api/v1/player-controller-player-players',
      );
      return GetPlayers.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        GetPlayers result = GetPlayers();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        ForceLogOutClass forceLogOutClass = ForceLogOutClass(context);
        forceLogOutClass.forceLogOut();
        GetPlayers result = GetPlayers();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        GetPlayers result = GetPlayers();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        GetPlayers result = GetPlayers();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<GetPlayerProfile> getPlayersProfle({String playerId}) async {
    try {
      await setCookie();
      Response response = await _dio.get(
        '$baseUrl/api/v1/player-controller-player-other/$playerId',
      );
      //  debugPrint("-------------------- player profile data ${response.data}");
      return GetPlayerProfile.fromJson(response.data);
    } catch (e) {
      debugPrint("------- get player profile failed $e");
      if (e.response.statusCode == 400) {
        GetPlayerProfile result = GetPlayerProfile();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        GetPlayerProfile result = GetPlayerProfile();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        GetPlayerProfile result = GetPlayerProfile();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        GetPlayerProfile result = GetPlayerProfile();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  //friend profile
  Future<FriendsFeed> getFriendsFeeds(
      {String id, String version = thisVersion}) async {
    try {
      await setCookie();
      Response response = await _dio.get(
          '$baseUrl/api/v1/player-post-controller-player-friend/$id?type=friend&version=$version');
      return FriendsFeed.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        FriendsFeed result = FriendsFeed();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        FriendsFeed result = FriendsFeed();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        FriendsFeed result = FriendsFeed();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        FriendsFeed result = FriendsFeed();
        result.message = 'Contact your developer.';
        return result;
      }
    }
  }

//friends
  Future<AddFriend> addFriends(String friendId) async {
    try {
      await setCookie();
      Response response = await _dio.post(
          '$baseUrl/api/v1/friendship-controller',
          data: {'friendship_id': friendId});
      return AddFriend.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        AddFriend result = AddFriend();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        AddFriend result = AddFriend();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        AddFriend result = AddFriend();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        AddFriend result = AddFriend();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<List<FriendsModel>> getFriends() async {
    try {
      await setCookie();
      Response response = await _dio.get(
        '$baseUrl/api/v1/friendship-controller-friends/accepted?offset=0&limit=100&search=null',
      );
      debugPrint("friends response is ${response.data}");
      Map body = response.data["body"];
      List a = body["friends"];

      List<FriendsModel> friends = [];
      friends = a.map((e) => FriendsModel.fromMap(e)).toList();
      return friends;
    } catch (e) {
      debugPrint("get friends failed $e");
      return [];
    }
  }

  Future<SearchPlayer> searchplayer(String searchText) async {
    try {
      await setCookie();
      Response response = await _dio.get(
        '$baseUrl/api/v1/player-controller-player-players?offset=0&limit=100&search=$searchText',
      );

      Map body = response.data["body"];
      return SearchPlayer.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        SearchPlayer result = SearchPlayer();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        SearchPlayer result = SearchPlayer();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        SearchPlayer result = SearchPlayer();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        SearchPlayer result = SearchPlayer();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<GetFriends> getFriendRequests() async {
    try {
      await setCookie();
      Response response = await _dio.get(
        '$baseUrl/api/v1/friendship-controller-friends/notaccepted?offset=0&limit=50&search=null',
      );

      debugPrint("requests response is ${response.data}");
      return GetFriends.fromJson(response.data);
    } catch (e) {
      debugPrint("get friends requests fauled $e");
    }
  }

  Future<RequestResponse> friendRequestUpdate(
      String friendId, bool accept) async {
    try {
      await setCookie();

      Response response = await _dio
          .put('$baseUrl/api/v1/friendship-controller/$friendId', data: {
        'is_accepted': accept,
      });
      debugPrint("friend request accept response is ${response.data}");
      return RequestResponse.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        RequestResponse result = RequestResponse();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        RequestResponse result = RequestResponse();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        RequestResponse result = RequestResponse();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        RequestResponse result = RequestResponse();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<RequestResponse> removeFriend(String friendId) async {
    try {
      await setCookie();
      Response response = await _dio.delete(
        '$baseUrl/api/v1/friendship-controller/$friendId',
      );
      debugPrint("remove friend response is ${response.data}");
      return RequestResponse.fromJson(response.data);
    } catch (e) {
      debugPrint("remove friend request failed $e");
      if (e.response.statusCode == 400) {
        RequestResponse result = RequestResponse();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        RequestResponse result = RequestResponse();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        RequestResponse result = RequestResponse();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        RequestResponse result = RequestResponse();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

//orders
  Future<Orders> getOrders() async {
    try {
      await setCookie();
      Response response = await _dio.get(
        '$baseUrl/api/v1/order-controller-player?status=all',
      );
      return Orders.fromJson(response.data);

      log(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        Orders result = Orders();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        Orders result = Orders();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        Orders result = Orders();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        Orders result = Orders();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  //orders
  Future<RequestResponse> changeOrderStatus(
      String orderId, String status) async {
    try {
      await setCookie();
      Response response = await _dio.put(
          '$baseUrl/api/v1/order-controller-player-status/$orderId',
          data: {'status': status});
      return RequestResponse.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        RequestResponse result = RequestResponse();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        RequestResponse result = RequestResponse();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        RequestResponse result = RequestResponse();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        RequestResponse result = RequestResponse();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  //store
  Future<List<NewCategoryModel>> getItemCategories() async {
    try {
      await setCookie();
      Response response = await _dio.get(
        '$baseUrl/api/v1/item-categories-controller-player',
      );
      //  debugPrint("get category response ${response.data["body"][0]}");
      final List li = response.data["body"];

      return li.map((e) => NewCategoryModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint("get categort failed $e");

      return [];
    }
  }

  Future<Map> getItems(
      {String category,
      int count,
      int limit,
      int offset,
      int remainCount}) async {
    try {
      await setCookie();
      Response response = await _dio.get(
        '$baseUrl/api/v1/item-controller-player-all?category=$category&count=$count&limit=$limit&offset=$offset&version=$thisVersion&remainCount=$remainCount',
      );
      debugPrint(
          "--------------------------------------- get items \n ${response.data["body"].toString()}");
      return response.data;
    } catch (e) {
      debugPrint("get items failed $e");
      return {};
    }
  }

  Future<GetItems> getItemData(String id) async {
    try {
      await setCookie();
      Response response = await _dio.get(
        '$baseUrl/api/v1/item-controller/$id',
      );
      debugPrint("$id ${response.data}");
      return GetItems.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        GetItems result = GetItems();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        GetItems result = GetItems();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        GetItems result = GetItems();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        GetItems result = GetItems();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<PurchaseItem> purchaseItem(
      {String id,
      String eventId,
      String itemId,
      String phoneNu,
      String address,
      String houseNo,
      String street,
      String city,
      String district,
      String zipCode}) async {
    try {
      await setCookie();
      Response response =
          await _dio.post('$baseUrl/api/v1/order-controller', data: {
        "item_id": itemId,
        "event_id": eventId,
        "phone_no": phoneNu,
        "house_no": houseNo,
        "street": street,
        "city": city,
        "district": district,
        "zip_code": zipCode,
        "address": null
      });
      debugPrint("place order response ${response.data}");
      return PurchaseItem.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        PurchaseItem result = PurchaseItem();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        PurchaseItem result = PurchaseItem();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        PurchaseItem result = PurchaseItem();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        PurchaseItem result = PurchaseItem();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<CurrentTime> getCurrentTime() async {
    try {
      await setCookie();
      Response response = await _dio
          .get('$baseUrl/api/v1/player-settings-controller-current-time');
      debugPrint("place order response 1 ${response.data}");
      return CurrentTime.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        CurrentTime result = CurrentTime();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        CurrentTime result = CurrentTime();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        CurrentTime result = CurrentTime();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        CurrentTime result = CurrentTime();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<RedeemBlock> purchaseBlock(BuildContext context) async {
    try {
      await setCookie();
      Response response =
          await _dio.get('$baseUrl/api/v1/player-controller-player-redeem');
      debugPrint("place order response 2 ${response.data}");
      return RedeemBlock.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        RedeemBlock result = RedeemBlock();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        ForceLogOutClass forceLogOutClass = ForceLogOutClass(context);
        forceLogOutClass.forceLogOut();
        RedeemBlock result = RedeemBlock();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        RedeemBlock result = RedeemBlock();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        RedeemBlock result = RedeemBlock();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  //notification
  Future<List<NotificationModel>> getNotifications() async {
    try {
      List<NotificationModel> notifications = [];
      await setCookie();

      Response response = await _dio.get(
        '$baseUrl/api/v1/player-notifications-controller?offset=0&limit=80&version=$thisVersion',
      );
      List friends = response.data["body"]["friends"];
      for (Map a in friends) {
        // print(a);

        notifications.add(NotificationModel.fromMap(a));

        // break;
        // break;
      }
      return notifications;
    } catch (e) {
      debugPrint("get friend notification failed $e");
      return [];
    }
  }

  Future<UnReadNotiCount> getUnReadNotificationCount() async {
    try {
      await setCookie();

      Response response = await _dio.get(
        '$baseUrl/api/v1/player-notifications-controller-unread',
      );

      return UnReadNotiCount.fromJson(response.data);
    } catch (e) {
      debugPrint("get friend notification failed $e");
    }
  }

  Future<ReadNotification> updateNotifications(String notificationId) async {
    try {
      await setCookie();
      Response response = await _dio.put(
        '$baseUrl/api/v1/player-notifications-controller/$notificationId',
      );
      return ReadNotification.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        ReadNotification result = ReadNotification();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        ReadNotification result = ReadNotification();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        ReadNotification result = ReadNotification();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        ReadNotification result = ReadNotification();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<ReadNotification> readAllNotifications() async {
    try {
      await setCookie();
      Response response = await _dio.put(
        '$baseUrl/api/v1/player-notifications-controller',
      );
      return ReadNotification.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        ReadNotification result = ReadNotification();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        ReadNotification result = ReadNotification();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        ReadNotification result = ReadNotification();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        ReadNotification result = ReadNotification();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

//feed
  Future<GetItemCategories> getHomepage() async {
    try {
      await setCookie();
      Response response = await _dio.get(
        '$baseUrl/api/v1/player-post-controller-player?offset=0&limit=18',
      );
      return GetItemCategories.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        GetItemCategories result = GetItemCategories();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        GetItemCategories result = GetItemCategories();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        GetItemCategories result = GetItemCategories();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        GetItemCategories result = GetItemCategories();
        result.message = 'Unknown error has occurred please contact developer.';
        return result;
      }
    }
  }

  Future<GetItemCategories> createPost2(
      {String image, File video, String description, String mediaUrl}) async {
    try {
      await setCookie();
      Response response = await _dio
          .post('$baseUrl/api/v1/player-post-controller-player', data: {
        "base64_media": image,
        "media_type": video,
        "description": description,
        "media_url": mediaUrl
      });
      return GetItemCategories.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        GetItemCategories result = GetItemCategories();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        GetItemCategories result = GetItemCategories();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        GetItemCategories result = GetItemCategories();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        GetItemCategories result = GetItemCategories();
        result.message = 'Unknown error has occurred please contact developer.';
        return result;
      }
    }
  }

  Future<void> updatePost(
      {String image,
      File video,
      String description,
      String mediaUrl,
      String originalUrl,
      String postID}) async {
    try {
      debugPrint("called");
      await setCookie();
      Response response = await _dio
          .put('$baseUrl/api/v1/player-post-controller-player/$postID', data: {
        "base64_media": image,
        "media_type": "Image",
        "description": description,
        "media_url": mediaUrl,
        "original_url": originalUrl,
        "is_archived": false,
      });
      debugPrint(
          "----------------------- update post response is ${response.data}");
      // return GetItemCategories.fromJson(response.data);
    } catch (e) {
      debugPrint("update post failed $e");
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await setCookie();
      Response response = await _dio.delete(
        '$baseUrl/api/v1/player-post-controller-player/$postId',
      );
      return GetItemCategories.fromJson(response.data);
    } catch (e) {
      debugPrint("delete post failed $e");
    }
  }

  Future<SubmitComment> createComment(
      {String postId, String comment, String commentId}) async {
    try {
      await setCookie();
      Response response = await _dio.post(
        '$baseUrl/api/v1/post-comments-controller',
        data: {
          "post_id": postId,
          "comment": comment,
          "comment_id": commentId,
        },
      );
      return SubmitComment.fromJson(response.data);
    } catch (e) {
      debugPrint("comment failed $e ${e.response.statusCode}");

      return null;
    }
  }

  Future<SubmitWish> createWish({
    String announcementId,
    String commentId,
    String comment,
  }) async {
    try {
      await setCookie();
      Response response = await _dio.post(
        '$baseUrl/api/v1/announcement-comments-controller',
        data: {
          "announcement_id": announcementId,
          "comment": comment,
          "comment_id": commentId,
        },
      );
      return SubmitWish.fromJson(response.data);
    } catch (e) {
      debugPrint("Wishes failed $e ${e.response.statusCode}");

      return null;
    }
  }

  Future<PostLikeModel> postLike({String postId}) async {
    try {
      // print("post id is $postId");
      await setCookie();
      Response response =
          await _dio.post('$baseUrl/api/v1/post-likes-controller', data: {
        "post_id": postId.toString(),
      });
      return PostLikeModel.fromMap(response.data["body"]);
    } catch (e) {
      debugPrint("post like failed $e");

      return null;
    }
  }

  Future<AnnounceLikeModel> announcementLike({String announcementId}) async {
    try {
      // print("post id is $postId");
      await setCookie();
      Response response = await _dio
          .post('$baseUrl/api/v1/announcement-likes-controller', data: {
        "announcement_id": announcementId.toString(),
      });
      return AnnounceLikeModel.fromMap(response.data["body"]);
    } catch (e) {
      debugPrint("Announcement like failed $e");

      return null;
    }
  }

  Future<AnnounceLikeModel> deleteAnnouncementLike(
      {String announcementId}) async {
    try {
      // print("post id is $postId");
      await setCookie();
      Response response = await _dio.delete(
          '$baseUrl/api/v1/announcement-likes-controller/$announcementId');
      return AnnounceLikeModel.fromMap(response.data["body"]);
    } catch (e) {
      debugPrint("Announcement like remove failed $e");

      return null;
    }
  }

  Future<PostLike> removeLike({String postId}) async {
    try {
      await setCookie();

      Response response =
          await _dio.delete('$baseUrl/api/v1/post-likes-controller/$postId');

      debugPrint("delete like response is ${response.data}");
      return PostLike.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        PostLike result = PostLike();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        PostLike result = PostLike();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        PostLike result = PostLike();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        PostLike result = PostLike();
        result.message = 'Unknown error has occurred please contact developer.';
        return result;
      }
    }
  }

// post-likes-controller
  Future<CreatePost> createPost(
      {String mediaType, String description, String mediaUrl}) async {
    try {
      await setCookie();
      Response response = await _dio
          .post('$baseUrl/api/v1/player-post-controller-player', data: {
        'media_type': mediaType,
        'description': description,
        'base64_media': mediaUrl
      });
      return CreatePost.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        CreatePost result = CreatePost();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        CreatePost result = CreatePost();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        CreatePost result = CreatePost();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        CreatePost result = CreatePost();
        result.message = 'Contact your developer.';
        return result;
      }
    }
  }

  Future<List<PostModel>> getFeeds(
      {String mediaType, String description, String mediaUrl}) async {
    try {
      List<PostModel> posts = [];
      await setCookie();
      Response response =
          await _dio.get('$baseUrl/api/v1/player-post-controller-player');
      // debugPrint("response body is ${response.data}");
      final result = response.data["body"]["result"];
      debugPrint(
          "posts length from post = ${response.data["body"]["result"].length}");
      for (Map<String, dynamic> r in result) {
        //  debugPrint("post result is $r");
        posts.add(PostModel.fromMap(r));
      }

      return posts;
    } catch (e) {
      debugPrint("fetch feed posts failed $e");
      return [];
    }
  }

  Future<Map> friendSuggesion(BuildContext context) async {
    await setCookie();
    try {
      Response response = await _dio.get(
          "$baseUrl/api/v1/friendship-controller-friend-suggestions?offset=0&limit=10");
      // debugPrint("friend suggesion response is ${response.data["body"]}");
      return response.data;
    } catch (e) {
      if (e.response.statusCode == 401) {
        ForceLogOutClass forceLogOutClass = ForceLogOutClass(context);
        forceLogOutClass.forceLogOut();
      }
      debugPrint("get friend suggesions failed $e");
      return {};
    }
  }

  Future<List<FriendSuggestionModel>> getFriendSuggestions() async {
    try {
      await setCookie();
      Response response = await _dio.get(
          '$baseUrl/api/v1/friendship-controller-friend-suggestions?offset=0&limit=10');
      // debugPrint("response body is ${response.data}");
      if (response.data["done"]) {
        List<FriendSuggestionModel> li = [];
        for (Map<String, dynamic> data in response.data["body"]) {
          li.add(FriendSuggestionModel.fromMap(data));
        }
        return li;
      }
      return [];
    } catch (e) {
      debugPrint("get friend suggestions failed $e");
      return [];
    }
  }

  // Remove suggestion
  Future<Map> removeFriendSuggesion(String friendId) async {
    try {
      await setCookie();
      Response response = await _dio.put(
        '$baseUrl/api/v1/friendship-controller-remove/$friendId',
      );
      return response.data;
    } catch (e) {
      debugPrint("get friend suggesions failed $e");
      return {};
    }
  }

  Future<List<NewQuizModel>> getQuizes(
      {String mediaType,
      String description,
      String mediaUrl,
      String version}) async {
    try {
      final now = DateTime.now();
      await setCookie();
      Response response = await _dio.get(
          '$baseUrl/api/v1/quiz-controller-player?timestamp=$now&version=$version');

      if (response.data["done"]) {
        List all = response.data["body"];
        // List li = response.data["body"]["new_quizzes"];
        // List answeredQuizes = response.data["body"]["answered_quizzes"];
        // debugPrint("${answeredQuizes[0]}");
        List<NewQuizModel> allQuizes =
            all.map((e) => NewQuizModel.fromMap(e)).toList();
        // List<NewQuizModel> quizes =
        //     li.map((e) => NewQuizModel.fromMap(e)).toList();
        // List<NewQuizModel> answersed =
        //     answeredQuizes.map((e) => NewQuizModel.fromMap(e)).toList();

        // List<NewQuizModel> q = quizes + answersed;
        List<NewQuizModel> q = allQuizes;

        // return shuffle(q);
        return q;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("get quizes failed $e");
      return [];
    }
  }

  List<NewQuizModel> shuffle(List<NewQuizModel> items) {
    final random = Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  Future<SubmitAnswer> submitAnswer(BuildContext context,
      {String quizId, String answerId}) async {
    try {
      await setCookie();
      Response response =
          await _dio.put('$baseUrl/api/v1/quiz-controller-player', data: {
        'id': answerId,
        'quiz_id': quizId,
      });
      debugPrint("submit answer result ${response.data}");
      return SubmitAnswer.fromJson(response.data);
    } catch (e) {
      debugPrint("-------------------- submit answer failed $e");
      if (e.response.statusCode == 400) {
        SubmitAnswer result = SubmitAnswer();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        ForceLogOutClass forceLogOutClass = ForceLogOutClass(context);
        forceLogOutClass.forceLogOut();
        SubmitAnswer result = SubmitAnswer();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        SubmitAnswer result = SubmitAnswer();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        SubmitAnswer result = SubmitAnswer();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<SubmitAnswer> submitMCGameAnswer(
      {String mcGameId, String answerId}) async {
    try {
      await setCookie();
      Response response =
          await _dio.put('$baseUrl/api/v1/mc-games-controller-player', data: {
        'id': answerId,
        'mc_game_id': mcGameId,
      });
      debugPrint("submit answer result ${response.data}");
      return SubmitAnswer.fromJson(response.data);
    } catch (e) {
      debugPrint("-------------------- submit answer failed $e");
      if (e.response.statusCode == 400) {
        SubmitAnswer result = SubmitAnswer();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        SubmitAnswer result = SubmitAnswer();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        SubmitAnswer result = SubmitAnswer();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        SubmitAnswer result = SubmitAnswer();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<SubmitAnswer> submitWCGameAnswer(
      {String wcGameId, String answer}) async {
    try {
      await setCookie();
      Response response =
          await _dio.put('$baseUrl/api/v1/wc-games-controller-player', data: {
        'answer': answer,
        'wc_game_id': wcGameId,
      });
      debugPrint("submit answer result ${response.data}");
      return SubmitAnswer.fromJson(response.data);
    } catch (e) {
      debugPrint("-------------------- submit answer failed $e");
      if (e.response.statusCode == 400) {
        SubmitAnswer result = SubmitAnswer();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        SubmitAnswer result = SubmitAnswer();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        SubmitAnswer result = SubmitAnswer();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        SubmitAnswer result = SubmitAnswer();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<Playerpoints> getPoints() async {
    try {
      await setCookie();
      Response response = await _dio.get(
        '$baseUrl/api/v1/player-controller-player-points',
      );
      return Playerpoints.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        Playerpoints result = Playerpoints();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        Playerpoints result = Playerpoints();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        Playerpoints result = Playerpoints();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        Playerpoints result = Playerpoints();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<GetAds> getAds({String placement, String type}) async {
    try {
      await setCookie();
      Response response = await _dio.get(
        '$baseUrl/api/v1/campaign-controller-player?offset=0&limit=10&placement=$placement&campaign_type=$type',
      );
      return GetAds.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        GetAds result = GetAds();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        GetAds result = GetAds();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        GetAds result = GetAds();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        GetAds result = GetAds();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<ProfileComments> getCommentById({String id}) async {
    try {
      await setCookie();
      Response response = await _dio.get(
        '$baseUrl/api/v1/post-comments-controller/$id',
      );
      return ProfileComments.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        ProfileComments result = ProfileComments();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        ProfileComments result = ProfileComments();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        ProfileComments result = ProfileComments();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        ProfileComments result = ProfileComments();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<SendMailToResetPass> verifyEmail(
      {String otpCode, String email}) async {
    try {
      await setCookie();
      Response response = await _dio.get(
        '$baseUrl/auth/reset-password/$otpCode/$email',
      );
      return SendMailToResetPass.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        SendMailToResetPass result = SendMailToResetPass();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        SendMailToResetPass result = SendMailToResetPass();
        result.message = 'Unauthorize.';
        return result;
      } else if (e.response.statusCode == 503) {
        SendMailToResetPass result = SendMailToResetPass();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        SendMailToResetPass result = SendMailToResetPass();
        result.message = "Something went wrong";
        return result;
      }
    }
  }

  Future<SendMailToResetPass> verifyEmailByOtp(
      {String otpCode, String id}) async {
    try {
      await setCookie();
      Response response = await _dio.get(
        '$baseUrl/auth/verify-email/$otpCode?id=$id',
      );
      return SendMailToResetPass.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        SendMailToResetPass result = SendMailToResetPass();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        SendMailToResetPass result = SendMailToResetPass();
        result.message = 'Unauthorize.';
        return result;
      } else if (e.response.statusCode == 503) {
        SendMailToResetPass result = SendMailToResetPass();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        SendMailToResetPass result = SendMailToResetPass();
        result.message = "Something went wrong";
        return result;
      }
    }
  }

  Future<SendMailToResetPass> resendOtp(String userId) async {
    try {
      await setCookie();
      Response response = await _dio
          .post('$baseUrl/auth/resend-verification', data: {'id': userId});
      return SendMailToResetPass.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        SendMailToResetPass result = SendMailToResetPass();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        SendMailToResetPass result = SendMailToResetPass();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        SendMailToResetPass result = SendMailToResetPass();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        SendMailToResetPass result = SendMailToResetPass();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  // API 2nd Edition

  Future reportPost(String postId, String desc) async {
    try {
      await setCookie();
      Response response = await _dio.post('$baseUrl/api/v1/disputes-controller',
          data: {
            "type": "Post",
            "description": desc,
            "subject": "Banned",
            "post_id": postId
          });
      //  print(response.data['done']);

      return response.data['done'];
    } catch (e) {
      debugPrint("report post failed $e");
    }
  }

  Future<PostModel> getPosts() async {
    try {
      await setCookie();
      Response response =
          await _dio.get('$baseUrl/api/v1/player-post-controller-player');
      //  debugPrint("response body is ${response.data}");
      final result = response.data["body"]["result"];
      PostModel post = PostModel.fromJson(jsonDecode(result));
      return post;
    } catch (e) {
      debugPrint("fetch feed posts failed $e");
      return e;
    }
  }

  Future<PostModel> getPostsByPostId(
      {String id, String version = thisVersion}) async {
    try {
      await setCookie();
      Response response = await _dio.get(
          '$baseUrl/api/v1/player-post-controller-player/$id?version=$version');
      //  debugPrint("response body is ${response.data}");
      final result = response.data["body"];
      //return result;
      //PostModel post = PostModel.fromJson(jsonDecode(result));
      PostModel post = PostModel.fromMap(result);
      return post;
    } catch (e) {
      debugPrint("fetch feed posts failed $e");
      return e;
    }
  }

  Future<FriendsFeed> getPostById(
      {String id, String version = thisVersion}) async {
    try {
      await setCookie();
      Response response = await _dio.get(
          '$baseUrl/api/v1/player-post-controller-player-friend/$id?type=friend?version=$version');
      return FriendsFeed.fromJson(response.data);
    } catch (e) {
      debugPrint("fetch feed posts failed $e");
      return e;
    }
  }

  Future<Map> getPost({
    String id,
    int offset,
    String version = thisVersion,
  }) async {
    try {
      await setCookie();
      Response response = await _dio.get(
          '$baseUrl/api/v1/player-post-controller-player-friend/$id?type=friend&version=$version');
      return response.data;
    } catch (e) {
      debugPrint("fetch feed posts failed $e");
      return e;
    }
  }

  Future<PlayerPostsResult> getPlayerPosts(
      {String id, int offset, int limit, String version = thisVersion}) async {
    try {
      List<PostModel> posts = [];

      await setCookie();
      Response response = await _dio.get(
          '$baseUrl/api/v1/player-post-controller-player-friend/$id?type=player&offset=$offset&limit=$limit&version=$version');
      // debugPrint("response body is ${response.data}");
      final result = response.data["body"]["posts"];
      debugPrint(
          "posts length from post = ${response.data["body"]["posts"].length}");
      for (Map<String, dynamic> r in result) {
        //  debugPrint("post result is $r");

        posts.add(PostModel.fromMap(r));
      }

      return PlayerPostsResult(response.data["body"]["count"], posts);
    } catch (e) {
      debugPrint("fetch feed posts failed $e");
      return null;
    }
  }

  Future<List<PostModel>> getMyPosts(
      {String id, String version = thisVersion}) async {
    try {
      List<PostModel> posts = [];
      await setCookie();
      Response response = await _dio.get(
          '$baseUrl/api/v1/player-post-controller-player-friend/$id?type=player&version=$version');
      // debugPrint("response body is ${response.data}");
      final result = response.data["body"]["posts"];
      debugPrint(
          "posts length from post = ${response.data["body"]["posts"].length}");
      for (Map<String, dynamic> r in result) {
        //  debugPrint("post result is $r");
        posts.add(PostModel.fromMap(r));
      }

      return posts;
    } catch (e) {
      debugPrint("fetch feed posts failed $e");
      return [];
    }
  }

  Future<List<PostModel>> getPlayerFriendPosts(
      {String id, String version = thisVersion}) async {
    try {
      List<PostModel> posts = [];
      await setCookie();
      Response response = await _dio.get(
          '$baseUrl/api/v1/player-post-controller-player-friend/$id?type=friend&version=$version');
      // debugPrint("response body is ${response.data}");
      final result = response.data["body"]["posts"];
      debugPrint(
          "posts length from post = ${response.data["body"]["posts"].length}");
      for (Map<String, dynamic> r in result) {
        //  debugPrint("post result is $r");
        posts.add(PostModel.fromMap(r));
      }

      return posts;
    } catch (e) {
      debugPrint("fetch feed posts failed $e");
      return [];
    }
  }

  Future<SingleAnnouncement> getAnnouncementsByAnnouncementId(
      {String id, String version = thisVersion}) async {
    try {
      await setCookie();
      Response response = await _dio.get(
          '$baseUrl/api/v1/announcements-controller-player/$id?version=$version');

      return SingleAnnouncement.fromJson(response.data);
    } catch (e) {
      debugPrint("fetch feed posts failed $e");
      return e;
    }
  }

  // Impression count
  Future<Map> setImpression(String adId) async {
    try {
      await setCookie();
      Response response = await _dio.post(
          '$baseUrl/api/v1/ad-impressions-controller',
          data: {'ad_id': adId});
      debugPrint("submit answer result ${response.data}");
      return response.data;
    } catch (e) {
      debugPrint("get profile data failed $e");
      return {"error": e};
    }
  }

  // click count
  Future<Map> adClickCount(String adId) async {
    try {
      await setCookie();
      Response response = await _dio
          .post('$baseUrl/api/v1/ad-views-controller', data: {'ad_id': adId});
      debugPrint("submit answer result ${response.data}");
      return response.data;
    } catch (e) {
      debugPrint("get profile data failed $e");
      return {"error": e};
    }
  }

  // banner Impression count
  Future<Map> setBannerImpression(String bannerId) async {
    try {
      await setCookie();
      Response response = await _dio.post(
          '$baseUrl/api/v1/store-banner-impressions-controller',
          data: {'banner_id': bannerId});
      debugPrint("submit answer result ${response.data}");
      return response.data;
    } catch (e) {
      debugPrint("get profile data failed $e");
      return {"error": e};
    }
  }

  /*  /store-banner-impressions-controller
post
body: banner_id

(edited)
3:15

/store-banner-views-controller
post
body: banner_id */

  // banner click count
  Future<Map> bannerClickCount(String bannerId) async {
    try {
      await setCookie();
      Response response = await _dio.post(
          '$baseUrl/api/v1/store-banner-views-controller',
          data: {'banner_id': bannerId});
      debugPrint("submit answer result ${response.data}");
      return response.data;
    } catch (e) {
      debugPrint("get profile data failed $e");
      return {"error": e};
    }
  }

  Future<Map> testMe(String adId) async {
    try {
      await setCookie();
      Response response = await _dio.post(
          'https://c2b2-112-135-219-22.in.ngrok.io/debug',
          data: {'ad_id': adId});
      debugPrint("submit answer result ${response.data}");
      return response.data;
    } catch (e) {
      debugPrint("get profile data failed $e");
      return {"error": e};
    }
  }

  // privacy

  Future<PrivacyOptions> getPrivacyOptions() async {
    try {
      await setCookie();
      Response response =
          await _dio.get('$baseUrl/api/v1/player-controller-player-privacy');
      debugPrint("place order response 2 ${response.data}");
      return PrivacyOptions.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        PrivacyOptions result = PrivacyOptions();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        PrivacyOptions result = PrivacyOptions();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        PrivacyOptions result = PrivacyOptions();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        PrivacyOptions result = PrivacyOptions();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<NotifiSettings> updatePrivacySettings(
      {bool private, bool showAnswerCount, bool showPointCount}) async {
    try {
      await setCookie();
      Response response = await _dio
          .put('$baseUrl/api/v1/player-controller-player-privacy', data: {
        "is_private": private,
        "show_answer_count": showAnswerCount,
        "show_point_count": showPointCount,
      });
      return NotifiSettings.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        NotifiSettings result = NotifiSettings();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        NotifiSettings result = NotifiSettings();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        NotifiSettings result = NotifiSettings();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        NotifiSettings result = NotifiSettings();
        result.done = false;
        result.message = "Something went wrong";
        return result;
      }
    }
  }

  // brand pages
  Future<NotifiSettings> convertToBrandPage({String selectedCategory}) async {
    try {
      await setCookie();
      Response response = await _dio
          .put('$baseUrl/api/v1/player-controller-player-brand', data: {
        "brand_category_id": selectedCategory,
      });
      return NotifiSettings.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        NotifiSettings result = NotifiSettings();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        NotifiSettings result = NotifiSettings();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        NotifiSettings result = NotifiSettings();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        NotifiSettings result = NotifiSettings();
        result.done = false;
        result.message = "Something went wrong";
        return result;
      }
    }
  }

  Future<BrandPageCategories> getPageCategories() async {
    try {
      await setCookie();
      Response response =
          await _dio.get('$baseUrl/api/v1/brandcategories-controller');
      debugPrint("place order response 2 ${response.data}");
      return BrandPageCategories.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        BrandPageCategories result = BrandPageCategories();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        BrandPageCategories result = BrandPageCategories();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        BrandPageCategories result = BrandPageCategories();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        BrandPageCategories result = BrandPageCategories();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<PopUpData> getlatePopUp() async {
    try {
      await setCookie();
      Response response =
          await _dio.get('$baseUrl/api/v1/popup-banners-controller-player');
      debugPrint("place order response 2 ${response.data}");
      return PopUpData.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        PopUpData result = PopUpData();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        PopUpData result = PopUpData();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        PopUpData result = PopUpData();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        PopUpData result = PopUpData();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<Map> popupSeen(String popupId) async {
    try {
      await setCookie();
      Response response = await _dio
          .put('$baseUrl/api/v1/popup-banners-controller-player/$popupId');
      return response.data;
    } catch (e) {
      debugPrint("get profile data failed $e");
      return {"error": e};
    }
  }

  Future<PlaySectionData> getNewPlaySectionData(BuildContext context) async {
    try {
      await setCookie();
      Response response = await _dio.get(
        '$baseUrl/api/v1/play-controller?version=$thisVersion',
      );
      return PlaySectionData.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        PlaySectionData result = PlaySectionData();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        ForceLogOutClass forceLogOutClass = ForceLogOutClass(context);
        forceLogOutClass.forceLogOut();
        PlaySectionData result = PlaySectionData();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        PlaySectionData result = PlaySectionData();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        PlaySectionData result = PlaySectionData();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<GameToken> getGameToken(String gameId, String gameType) async {
    try {
      await setCookie();
      Response response = await _dio.post('$baseUrl/api/v1/fs-game-controller',
          data: {"game_id": gameId, "type": gameType});
      return GameToken.fromJson(response.data);
    } catch (e) {}
  }

  Future<GameEarnedPoints> getEarnedGamepoints(String gameType) async {
    try {
      await setCookie();
      Response response = await _dio.get(
        '$baseUrl/api/v1/fs-game-controller-points/$gameType',
      );

      return GameEarnedPoints.fromJson(response.data);
    } catch (e) {}
  }

//////////////////////////////////////////////////////MarkertPlace/////////////////////////////////////////////////////
  Future<MarkertPlaceItem> createMarketplaceItem(
      String itemName,
      String itemDesc,
      String itemCategory,
      String itemPrice,
      String Base64image,
      String imageUrl) async {
    try {
      // Assuming you have a method setCookie() to set the necessary cookie.
      await setCookie();

      // Now, make a request to create the marketplace item.
      Response response = await _dio.post(
        '$baseUrl/marketplace/items',
        data: {
          "item_name": itemName,
          "item_desc": itemDesc,
          "item_category": itemCategory,
          "item_price": itemPrice,
          "media": [
            {"base64_image": Base64image},
            {"image_url": imageUrl}
          ]
        },
      );

      print("itemm " + response.data);

      return MarkertPlaceItem(); // Or whatever response type you have
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
}
// "7e63f28d-4495-4640-b2ed-4da57719e3fb"

// quiz-controller-player

class PlayerPostsResult {
  final int allPostCount;
  final List<PostModel> posts;

  PlayerPostsResult(this.allPostCount, this.posts);
}
