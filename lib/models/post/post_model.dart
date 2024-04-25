// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:play_pointz/models/post/comment_model.dart';
import 'package:play_pointz/models/post/like_model.dart';

class PostModel {
  final String player_name;
  final String player_image;
  final List<CommentModel> post_comments;
  //final List<PostLikeModel> post_like;
  final String player_id;
  final String type;
  final String id;
  final String date_created;
  final String date_updated;
  String description;
  final String media_type;
  final String media_url;
  final List quiz_answers;
  final String quiz_status;
  final String end_time;
  final String quiz;
  final String pointz;
  final String quiz_category;
  final String quiz_level_id;
  final String minus_pointz;
  bool isLike;
  final bool is_brand_verified;
  final bool is_brand_acc;
  final String original_url;
  int likes_count;
  int comments_count;
  String item_name;
  String follow_status;
  String like_id;
  PostModel({
    this.player_name,
    this.player_image,
    this.post_comments,
    //this.post_like,
    this.player_id,
    this.type,
    this.id,
    this.date_created,
    this.date_updated,
    this.description,
    this.media_type,
    this.media_url,
    this.quiz_answers,
    this.quiz_status,
    this.end_time,
    this.quiz,
    this.pointz,
    this.quiz_category,
    this.quiz_level_id,
    this.minus_pointz,
    this.isLike,
    this.is_brand_verified,
    this.is_brand_acc,
    this.original_url,
    this.likes_count,
    this.comments_count,
    this.item_name,
    this.follow_status,
    this.like_id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'player_name': player_name,
      'post_comments': post_comments.map((x) => x.toMap()).toList(),
      //  'post_like': post_like.map((x) => x.toMap()).toList(),
      'player_id': player_id,
      'type': type,
      'id': id,
      'date_created': date_created,
      'date_updated': date_updated,
      'description': description,
      'media_type': media_type,
      'media_url': media_url,
      'quiz_answers': quiz_answers,
      'quiz_status': quiz_status,
      'end_time': end_time,
      'quiz': quiz,
      'pointz': pointz,
      'quiz_category': quiz_category,
      'quiz_level_id': quiz_level_id,
      'minus_pointz': minus_pointz,
      'original_url': original_url,
      'likes_count': likes_count,
      'comments_count': comments_count,
      'item_name': item_name,
      'follow_status': follow_status,
      'is_brand_verified': is_brand_verified,
      'is_brand_acc': is_brand_acc,
      'like_id': like_id,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
        player_name: map['player_name'] ?? "No Name",
        player_image: map['player_image'] ??
            "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg",
        /*  */

        post_comments: map["post_comments"] != null
            ? (map["post_comments"] as List)
                .map((e) => CommentModel.fromMap(e))
                .toList()
                .reversed
                .toList()
            : [],
        // post_comments: [],
        /*   post_like: map["post_likes"] != null
            ? (map["post_likes"] as List)
                .map((e) => PostLikeModel.fromMap(e))
                .toList()
            : [], */
        player_id: map['player_id'] ??
            "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg",
        type: map['type'] ?? "",
        id: map['id'] ?? "",
        date_created: map['date_created'] ?? "",
        date_updated: map['date_updated'] ?? "",
        description: map['description'] ?? "",
        media_type: map['media_type'] ?? "",
        media_url: map['media_url'] ?? "",
        quiz_answers: [],
        quiz_status: map['quiz_status'] ?? "",
        end_time: map['end_time'] ?? "",
        quiz: map['quiz'] ?? "",
        pointz: map['pointz'] ?? "",
        quiz_category: map['quiz_category'] ?? "",
        quiz_level_id: map['quiz_level_id'] ?? "",
        minus_pointz: map['minus_pointz'] ?? "",
        isLike: map["is_liked"] ?? false,
        is_brand_verified: map["is_brand_verified"] ?? false,
        is_brand_acc: map["is_brand_acc"] ?? false,
        original_url: map["original_url"] ?? "",
        likes_count: map["post_likes_count"] ?? 0,
        comments_count: map["post_comments_count"] ?? 0,
        like_id: map["like_id"] ?? "",
        item_name: map["item_name"] ?? "",
        follow_status: map["follow_status"] ?? "");
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
