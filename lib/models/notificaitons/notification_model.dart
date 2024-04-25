import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NotificationModel {
  final String id;
  final String notificaiton;
  final String type;
  final String item_id;
  final String friend_id;
  final String player_id;
  final bool is_read;
  final String date_created;
  final String date_updated;
  final Map friend;
  final Map item;
  final String post_id;
  final String announcement_id;
  final String support_id;
  final String p_support_id;
  NotificationModel({
    this.id,
    this.notificaiton,
    this.type,
    this.item_id,
    this.friend_id,
    this.player_id,
    this.is_read,
    this.date_created,
    this.date_updated,
    this.friend,
    this.item,
    this.post_id,
    this.announcement_id,
    this.support_id,
    this.p_support_id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'notificaiton': notificaiton,
      'type': type,
      'item_id': item_id,
      'friend_id': friend_id,
      'player_id': player_id,
      'is_read': is_read,
      'date_created': date_created,
      'date_updated': date_updated,
      'friend': friend,
      'item': item,
      'post_id': post_id,
      'announcement_id': announcement_id,
      'support_id': support_id,
      'p_support_id': p_support_id
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
        id: map['id'] == null ? "" : map["id"],
        notificaiton: map['notification'] == null ? "" : map["notification"],
        type: map['type'] == null ? "" : map["type"],
        item_id: map['item_id'] == null ? "" : map["item_id"],
        friend_id: map['friend_id'] == null ? "" : map["friend_id"],
        player_id: map['player_id'] == null ? "" : map["player_id"],
        is_read: map['is_read'] == null ? false : map["is_read"],
        date_created: map['date_created'] == null ? "" : map["date_created"],
        date_updated: map['date_updated'] == null ? "" : map["date_updated"],
        friend: map["friend"] == null ? {} : map["friend"],
        item: map["item"] == null ? {} : map["item"],
        post_id: map["post_id"] ?? "",
        announcement_id: map["announcement_id"] ?? "",
        support_id: map["support_id"] ?? "",
        p_support_id: map["p_support_id"] ?? ""
        );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
