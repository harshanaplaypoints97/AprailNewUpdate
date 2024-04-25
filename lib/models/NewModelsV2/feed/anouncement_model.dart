import 'dart:convert';

import 'package:play_pointz/models/notificaitons/announce_comment_model.dart';
import 'package:play_pointz/models/notificaitons/announce_like_model.dart';
// import 'dart:ffi';

AnouncementModel anouncementModelFromJson(String str) =>
    AnouncementModel.fromJson(json.decode(str));

String anouncementModelToJson(AnouncementModel data) =>
    json.encode(data.toJson());

class AnouncementModel {
  String type;
  String id;
  String name;
  dynamic redirectUrl;
  dynamic placement;
  dynamic text;
  String startDate;
  String endDate;
  String dateCreated;
  String dateUpdated;
  dynamic campaignType;
  List<dynamic> media;
  String description;
  String mediaType;
  String mediaUrl;
  int commentsCount;
  int likesCount;
  bool isliked;
  String playerImage;
  String PlayerName;
  String ItemName;
  String playerId;
  List<AnnounceCommentModel> announcement_comments;
  List<AnnounceLikeModel> announcement_likes;

  AnouncementModel({
    this.type,
    this.id,
    this.name,
    this.redirectUrl,
    this.placement,
    this.text,
    this.startDate,
    this.endDate,
    this.dateCreated,
    this.dateUpdated,
    this.campaignType,
    this.media,
    this.description,
    this.mediaType,
    this.mediaUrl,
    this.commentsCount,
    this.likesCount,
    this.isliked,
    this.playerImage,
    this.PlayerName,
    this.ItemName,
    this.playerId,
    this.announcement_comments,
    this.announcement_likes,
  });
  factory AnouncementModel.fromMap(Map<String, dynamic> map) =>
      AnouncementModel(
        type: map["type"] ?? "",
        id: map["id"] ?? "",
        name: map["name"] ?? "",
        redirectUrl: map["redirect_url"] ?? "",
        placement: map["placement"] ?? "",
        text: map["text"] ?? "",
        startDate: map["start_date"] ?? "",
        endDate: map["end_date"] ?? "",
        dateCreated: map["date_created"] ?? "",
        dateUpdated: map["date_updated"] ?? "",
        campaignType: map["campaign_type"] ?? "",
        media: List<dynamic>.from(map["media"].map((x) => x)),
        description: map["description"] ?? "",
        mediaType: map["media_type"] ?? "",
        mediaUrl: map["media_url"] ?? "",
        commentsCount: map["comments_count"] ?? 0,
        likesCount: map["likes_count"] ?? 0,
        isliked: map["is_liked"] ?? "",
        playerImage: map["player_image"] ?? "",
        PlayerName: map["player_name"] ?? "",
        ItemName: map["item_name"] ?? "",
        playerId: map["player_id"] ?? "",
        announcement_comments: map["announcement_comments"] != null
            ? (map["announcement_comments"] as List)
                .map((e) => AnnounceCommentModel.fromMap(e))
                .toList()
                .reversed
                .toList()
            : [],
        announcement_likes: map["announcement_likes"] != null
            ? (map["announcement_likes"] as List)
                .map((e) => AnnounceLikeModel.fromMap(e))
                .toList()
            : [],
      );

  factory AnouncementModel.fromJson(Map<String, dynamic> json) =>
      AnouncementModel(
        type: json["type"] ?? "",
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        redirectUrl: json["redirect_url"] ?? "",
        placement: json["placement"] ?? "",
        text: json["text"] ?? "",
        startDate: json["start_date"] ?? "",
        endDate: json["end_date"] ?? "",
        dateCreated: json["date_created"] ?? "",
        dateUpdated: json["date_updated"] ?? "",
        campaignType: json["campaign_type"] ?? "",
        media: List<dynamic>.from(json["media"].map((x) => x)),
        description: json["description"] ?? "",
        mediaType: json["media_type"] ?? "",
        mediaUrl: json["media_url"] ?? "",
        commentsCount: json["comments_count"] ?? 0,
        likesCount: json["likes_count"] ?? 0,
        isliked: json["is_liked"] ?? "",
        playerImage: json["player_image"] ?? "",
        PlayerName: json["player_name"] ?? "",
        ItemName: json["item_name"] ?? "",
        playerId: json["player_id"] ?? "",
        announcement_comments: json["announcement_comments"] != null
            ? (json["announcement_comments"] as List)
                .map((e) => AnnounceCommentModel.fromMap(e))
                .toList()
                .reversed
                .toList()
            : [],
        // announcement_comments: [],
        announcement_likes: json["announcement_likes"] != null
            ? (json["announcement_likes"] as List)
                .map((e) => AnnounceLikeModel.fromMap(e))
                .toList()
            : [],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "name": name,
        "redirect_url": redirectUrl,
        "placement": placement,
        "text": text,
        "start_date": startDate,
        "end_date": endDate,
        "date_created": dateCreated,
        "date_updated": dateUpdated,
        "campaign_type": campaignType,
        "media": List<dynamic>.from(media.map((x) => x)),
        "description": description,
        "media_type": mediaType,
        "media_url": mediaUrl,
        "comments_count": commentsCount,
        "likes_count": likesCount,
        "is_liked": isliked,
        "player_image": playerImage,
        "player_name": PlayerName,
        "item_name": ItemName,
        "player_id": playerId,
        'announcement_comments':
            announcement_comments.map((x) => x.toMap()).toList(),
        'announcement_likes': announcement_likes.map((x) => x.toMap()).toList(),
      };
}
