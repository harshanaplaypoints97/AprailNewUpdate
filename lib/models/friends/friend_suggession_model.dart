import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class FriendSuggestionModel {
  final String id;
  final String username;
  final String email;
  final int points;
  final int points_by_answers;
  final int points_by_invites;
  final String full_name;
  final String gender;
  final String date_of_birth;
  final String address;
  final String contact_no;
  final String profile_image;
  final String cover_image;
  final bool is_blocked;
  FriendSuggestionModel(
      {this.id,
      this.username,
      this.email,
      this.points,
      this.points_by_answers,
      this.points_by_invites,
      this.full_name,
      this.gender,
      this.date_of_birth,
      this.address,
      this.contact_no,
      this.profile_image,
      this.cover_image,
      this.is_blocked});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'points': points,
      'points_by_answers': points_by_answers,
      'points_by_invites': points_by_invites,
      'full_name': full_name,
      'gender': gender,
      'date_of_birth': date_of_birth,
      'address': address,
      'contact_no': contact_no,
      'profile_image': profile_image,
      'cover_image': cover_image,
      'is_blocked': is_blocked
    };
  }

  factory FriendSuggestionModel.fromMap(Map<String, dynamic> map) {
    return FriendSuggestionModel(
        id: map['id'] == null ? "" : map["id"],
        username: map['username'] == null ? "" : map["username"],
        email: map['email'] == null ? "" : map["email"],
        points: map['points'] == null ? 0 : map["points"],
        points_by_answers:
            map['points_by_answers'] == null ? 0 : map["points_by_answers"],
        points_by_invites:
            map['points_by_invites'] == null ? 0 : map["points_by_invites"],
        full_name: map['full_name'] == null ? "" : map["full_name"],
        gender: map['gender'] == null ? "" : map["gender"],
        date_of_birth: map['date_of_birth'] == null ? "" : map["date_of_birth"],
        address: map['address'] == null ? "" : map["address"],
        contact_no: map['contact_no'] == null ? "" : map["contact_no"],
        profile_image: map['profile_image'] == null
            ? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
            : map["profile_image"],
        cover_image: map['cover_image'] == null
            ? "https://upload.wikimedia.org/wikipedia/commons/b/b9/No_Cover.jpg"
            : map["cover_image"],
        is_blocked: map['is_blocked'] == null ? "" : map["is_blocked"]);
  }

  String toJson() => json.encode(toMap());

  factory FriendSuggestionModel.fromJson(String source) =>
      FriendSuggestionModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
