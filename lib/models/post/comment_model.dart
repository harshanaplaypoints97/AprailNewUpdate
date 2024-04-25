import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CommentModel {
  final String id;
  final String player_id;
  final String post_id;
  final String comment_id;
  final String comment;
  final String date_created;
  final String player_name;
  final bool is_brand_verified;
  final String player_image;
  List<Comments> comments;
  int sub_comment_count;

  CommentModel(
      {this.id,
      this.player_id,
      this.post_id,
      this.comment_id,
      this.comment,
      this.date_created,
      this.player_name,
      this.is_brand_verified,
      this.player_image,
      this.comments,
      this.sub_comment_count});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sub_comment_count': sub_comment_count,
      'id': id,
      'player_id': player_id,
      'post_id': post_id,
      'comment_id': comment_id,
      'comment': comment,
      'date_created': date_created,
      'player_name': player_name,
      'is_brand_verified': is_brand_verified,
      'player_image': player_image,
      // 'comments':comments.map((x) => x.toMap()).toList(),
      'comments': comments.map((v) => v.toJson()).toList()
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      sub_comment_count:
          map['sub_comment_count'] == null ? 0 : map["sub_comment_count"],
      id: map['id'] == null ? "" : map["id"],
      player_id: map['player_id'] == null ? "" : map["player_id"],
      post_id: map['post_id'] == null ? "" : map["post_id"],
      comment_id: map['comment_id'] == null ? "" : map["comment_id"],
      comment: map['comment'] == null ? "" : map["comment"],
      date_created: map['date_created'] == null ? "" : map["date_created"],
      player_name: map['player_name'] == null ? "" : map["player_name"],
      is_brand_verified:
          map['is_brand_verified'] == null ? false : map["is_brand_verified"],
      player_image: map['player_image'] == null
          ? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
          : map["player_image"],
      // comments: map['comments'] != null? <Comments>[]:null
      comments: map["comments"] != null
          ? (map["comments"] as List)
              .map((e) => Comments.fromJson(e))
              .toList()
              .reversed
              .toList()
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Comments {
  String id;
  String playerId;
  String postId;
  String commentId;
  String comment;
  String dateCreated;
  String playerName;
  bool is_brand_verified;
  String playerImage;

  Comments(
      {this.id,
      this.playerId,
      this.postId,
      this.commentId,
      this.comment,
      this.dateCreated,
      this.playerName,
      this.is_brand_verified,
      this.playerImage});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    playerId = json['player_id'];
    postId = json['post_id'];
    commentId = json['comment_id'];
    comment = json['comment'];
    dateCreated = json['date_created'];
    playerName = json['player_name'];
    is_brand_verified = json['is_brand_verified'] ?? false;
    playerImage = json['player_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['player_id'] = this.playerId;
    data['post_id'] = this.postId;
    data['comment_id'] = this.commentId;
    data['comment'] = this.comment;
    data['date_created'] = this.dateCreated;
    data['player_name'] = this.playerName;
    data['is_brand_verified'] = this.is_brand_verified;
    data['player_image'] = this.playerImage;
    return data;
  }
}
