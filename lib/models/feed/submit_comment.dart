import 'package:flutter/material.dart';

class SubmitComment {
  bool done;
  BodyOfSubmitComment body;
  String message;

  SubmitComment({this.done, this.body, this.message});

  SubmitComment.fromJson(Map<String, dynamic> json) {
    debugPrint("json body is ${json['body']}");
    done = json['done'];
    body = json['body'] != null
        ? BodyOfSubmitComment.fromJson(
            json['body']["create_player_post_comment"])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['done'] = done;
    if (body != null) {
      data['body'] = body.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class BodyOfSubmitComment {
  String playerId;
  String postId;
  String commentId;
  String dateCreated;

  BodyOfSubmitComment(
      {this.playerId, this.postId, this.commentId, this.dateCreated});

  BodyOfSubmitComment.fromJson(Map<String, dynamic> json) {
    playerId = json['player_id'];
    postId = json['post_id'];
    commentId = json['id'];
    dateCreated = json['date_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['player_id'] = playerId;
    data['post_id'] = postId;
    data['comment_id'] = commentId;
    data['date_created'] = dateCreated;
    return data;
  }
}
