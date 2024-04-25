import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AnnounceCommentModel {
  final String id;
  final String player_id;
  final String announcement_id;
  final String comment_id;
  final String comment;
  final String date_created;
  final String player_name;
  final String player_image;
  final bool is_brand_verified;
  int subCommentCount;
  final List<AnnounceComments> comments;

  AnnounceCommentModel(
      {this.id,
      this.subCommentCount,
      this.player_id,
      this.announcement_id,
      this.comment_id,
      this.comment,
      this.date_created,
      this.player_name,
      this.player_image,
      this.is_brand_verified,
      this.comments});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sub_comment_count': subCommentCount,
      'player_id': player_id,
      'announcement_id': announcement_id,
      'comment_id': comment_id,
      'comment': comment,
      'date_created': date_created,
      'player_name': player_name,
      'player_image': player_image,
      'is_brand_verified': is_brand_verified,
      // 'comments':comments.map((x) => x.toMap()).toList(),
      'comments': comments.map((v) => v.toJson()).toList()
    };
  }

  factory AnnounceCommentModel.fromMap(Map<String, dynamic> map) {
    return AnnounceCommentModel(
      id: map['id'] == null ? "" : map["id"],
      subCommentCount:
          map['sub_comment_count'] == null ? 0 : map["sub_comment_count"],
      player_id: map['player_id'] == null ? "" : map["player_id"],
      announcement_id:
          map['announcement_id'] == null ? "" : map["announcement_id"],
      comment_id: map['comment_id'] == null ? "" : map["comment_id"],
      comment: map['comment'] == null ? "" : map["comment"],
      date_created: map['date_created'] == null ? "" : map["date_created"],
      player_name: map['player_name'] == null ? "" : map["player_name"],
      is_brand_verified:
          map['is_brand_verified'] == null ? false : map["is_brand_verified"],
      player_image: map['player_image'] == null
          ? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
          : map["player_image"],
      // comments: map['comments'] != null? <AnnounceComments>[]:null
      comments: map["comments"] != null
          ? (map["comments"] as List)
              .map((e) => AnnounceComments.fromJson(e))
              .toList()
              .reversed
              .toList()
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory AnnounceCommentModel.fromJson(String source) =>
      AnnounceCommentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class AnnounceComments {
  String id;
  String playerId;
  String announceId;
  String commentId;
  String comment;
  String dateCreated;
  String playerName;
  String playerImage;
  bool is_brand_verified;

  AnnounceComments(
      {this.id,
      this.playerId,
      this.announceId,
      this.commentId,
      this.comment,
      this.dateCreated,
      this.playerName,
      this.playerImage,
      this.is_brand_verified});

  AnnounceComments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    playerId = json['player_id'];
    announceId = json['announcement_id'];
    commentId = json['comment_id'];
    comment = json['comment'];
    dateCreated = json['date_created'];
    playerName = json['player_name'];
    playerImage = json['player_image'];
    is_brand_verified = json['is_brand_verified'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['player_id'] = this.playerId;
    data['announcement_id'] = this.announceId;
    data['comment_id'] = this.commentId;
    data['comment'] = this.comment;
    data['date_created'] = this.dateCreated;
    data['player_name'] = this.playerName;
    data['player_image'] = this.playerImage;
    data['is_brand_verified'] = this.is_brand_verified;
    return data;
  }
}
