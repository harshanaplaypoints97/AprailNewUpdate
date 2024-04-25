// To parse this JSON data, do
//
//     final storyModel = storyModelFromJson(jsonString);

import 'dart:convert';

StoryModel storyModelFromJson(String str) =>
    StoryModel.fromJson(json.decode(str));

String storyModelToJson(StoryModel data) => json.encode(data.toJson());

class StoryModel {
  bool done;
  Body body;
  dynamic message;

  StoryModel({
    this.done,
    this.body,
    this.message,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) => StoryModel(
        done: json["done"],
        body: Body.fromJson(json["body"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "done": done,
        "body": body.toJson(),
        "message": message,
      };
}

class Body {
  int count;
  List<Story> stories;

  Body({
    this.count,
    this.stories,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        count: json["count"],
        stories:
            List<Story>.from(json["stories"].map((x) => Story.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "stories": List<dynamic>.from(stories.map((x) => x.toJson())),
      };
}

class Story {
  String id;
  String playerId;
  int viewCount;
  DateTime dateUpdated;
  bool isViewed;
  dynamic profileImage;
  String playerUsername;
  String playerFullName;
  bool isBrandAcc;
  List<Content> contents;

  Story({
    this.id,
    this.playerId,
    this.viewCount,
    this.dateUpdated,
    this.isViewed,
    this.profileImage,
    this.playerUsername,
    this.playerFullName,
    this.isBrandAcc,
    this.contents,
  });

  factory Story.fromJson(Map<String, dynamic> json) => Story(
        id: json["id"],
        playerId: json["player_id"],
        viewCount: json["view_count"],
        dateUpdated: DateTime.parse(json["date_updated"]),
        isViewed: json["is_viewed"],
        profileImage: json["profile_image"],
        playerUsername: json["player_username"],
        playerFullName: json["player_full_name"],
        isBrandAcc: json["is_brand_acc"],
        contents: List<Content>.from(
            json["contents"].map((x) => Content.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "player_id": playerId,
        "view_count": viewCount,
        "date_updated": dateUpdated.toIso8601String(),
        "is_viewed": isViewed,
        "profile_image": profileImage,
        "player_username": playerUsername,
        "player_full_name": playerFullName,
        "is_brand_acc": isBrandAcc,
        "contents": List<dynamic>.from(contents.map((x) => x.toJson())),
      };
}

class Content {
  String id;
  String imageUrl;
  String description;
  DateTime dateCreated;
  DateTime dateUpdated;

  Content({
    this.id,
    this.imageUrl,
    this.description,
    this.dateCreated,
    this.dateUpdated,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["id"],
        imageUrl: json["image_url"],
        description: json["description"],
        dateCreated: DateTime.parse(json["date_created"]),
        dateUpdated: DateTime.parse(json["date_updated"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image_url": imageUrl,
        "description": description,
        "date_created": dateCreated.toIso8601String(),
        "date_updated": dateUpdated.toIso8601String(),
      };
}
