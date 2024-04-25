import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AnnounceLikeModel {
  final String id;
  final String player_id;
  final String announcement_id;
  final String date_created;
  AnnounceLikeModel({
    this.id,
    this.player_id,
    this.announcement_id,
    this.date_created,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'player_id': player_id,
      'announcement_id': announcement_id,
      'date_created': date_created,
    };
  }

  factory AnnounceLikeModel.fromMap(Map<String, dynamic> map) {
    return AnnounceLikeModel(
      id: map['id'] == null ? "" : map["id"],
      player_id: map['player_id'] == null ? "" : map["player_id"],
      announcement_id: map['announcement_id'] == null ? "" : map["announcement_id"],
      date_created: map['date_created'] == null ? "" : map["date_created"],
    );
  }

  String toJson() => json.encode(toMap());

  factory AnnounceLikeModel.fromJson(String source) =>
      AnnounceLikeModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
