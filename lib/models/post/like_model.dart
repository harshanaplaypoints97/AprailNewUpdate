import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PostLikeModel {
  final String id;
  final String player_id;
  final String post_id;
  final String date_created;
  PostLikeModel({
    this.id,
    this.player_id,
    this.post_id,
    this.date_created,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'player_id': player_id,
      'post_id': post_id,
      'date_created': date_created,
    };
  }

  factory PostLikeModel.fromMap(Map<String, dynamic> map) {
    return PostLikeModel(
      id: map['id'] == null ? "" : map["id"],
      player_id: map['player_id'] == null ? "" : map["player_id"],
      post_id: map['post_id'] == null ? "" : map["post_id"],
      date_created: map['date_created'] == null ? "" : map["date_created"],
    );
  }

  String toJson() => json.encode(toMap());

  factory PostLikeModel.fromJson(String source) =>
      PostLikeModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
