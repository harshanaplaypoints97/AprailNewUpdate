import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class FriendsModel {
  final String friends_id_1;
  final String friends_id_2;
  final String date_created;
  final bool is_accepted;
  final String username;
  final String profile_image;
  final String full_name;
  FriendsModel({
    this.friends_id_1,
    this.friends_id_2,
    this.date_created,
    this.is_accepted,
    this.username,
    this.profile_image,
    this.full_name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'friends_id_1': friends_id_1,
      'friends_id_2': friends_id_2,
      'date_created': date_created,
      'is_accepted': is_accepted,
      'username': username,
      'profile_image': profile_image,
      'full_name': full_name,
    };
  }

  factory FriendsModel.fromMap(Map<String, dynamic> map) {
    return FriendsModel(
      friends_id_1: map['friendship_id_1'] as String,
      friends_id_2: map['friendship_id_2'] as String,
      date_created: map['date_created'] as String,
      is_accepted: map['is_accepted'] as bool,
      username: map['username'] as String,
      profile_image: map['profile_image'] == null
          ? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
          : map['profile_image'],
      full_name: map['full_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FriendsModel.fromJson(String source) =>
      FriendsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
