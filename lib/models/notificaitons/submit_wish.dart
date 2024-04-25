import 'package:flutter/material.dart';

class SubmitWish {
  bool done;
  BodyOfSubmitWish body;
  String message;

  SubmitWish({this.done, this.body, this.message});

  SubmitWish.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = json['body'] != null
        ? BodyOfSubmitWish.fromJson(
            json['body']["create_player_announcement_comment"])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['done'] = this.done;
    if (this.body != null) {
      data['body'] = this.body.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class BodyOfSubmitWish {
  String id;
  String playerId;
  String announcementId;
  String commentId;
  String comment;
  String dateCreated;
  String playerName;
  String playerImage;
  bool is_brand_verified;

  BodyOfSubmitWish(
      {this.id,
      this.playerId,
      this.announcementId,
      this.commentId,
      this.comment,
      this.dateCreated,
      this.playerName,
      this.playerImage,
      this.is_brand_verified});

  BodyOfSubmitWish.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    playerId = json['player_id'];
    announcementId = json['announcement_id'];
    commentId = json['comment_id'];
    comment = json['comment'];
    dateCreated = json['date_created'];
    playerName = json['player_name'];
    playerImage = json['player_image'];
    is_brand_verified = json['is_brand_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['player_id'] = this.playerId;
    data['announcement_id'] = this.announcementId;
    data['comment_id'] = this.commentId;
    data['comment'] = this.comment;
    data['date_created'] = this.dateCreated;
    data['player_name'] = this.playerName;
    data['player_image'] = this.playerImage;
    data['is_brand_verified'] = this.is_brand_verified;
    return data;
  }
}
