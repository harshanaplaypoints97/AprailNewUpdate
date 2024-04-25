// // ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Login {
  Login({
    this.done,
    this.message,
  });
  bool done;
  Body body;
  String message;

  Login.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['done'] = done;
    if (body != null) {}
    _data['message'] = message;
    return _data;
  }
}

class Body {
  Body({
    this.user,
  });
  User user;
  Body.fromJson(Map<String, dynamic> json) {
    user = json['user'];
  }
}

class User {
  final String id;
  final String username;
  final String fullName;
  final String email;
  String profileImage;
  String coverImage;
  final String gender;
  final String dateOfBirth;
  final String country;
  final int points;
  final String contactNo;
  final String inviteToken;
  final int correctAnswers;
  final int incorrectAnswers;
  final int totalFriends;
  final String address;
  final String houseNo;
  final String street;
  final String city;
  final String district;
  final String zipCode;
  final String web;
  final String description;
  final bool is_brand_acc;
  final bool page_verified;
  User({
    this.id,
    this.coverImage,
    this.username,
    this.fullName,
    this.email,
    this.profileImage,
    this.gender,
    this.dateOfBirth,
    this.country,
    this.points,
    this.contactNo,
    this.inviteToken,
    this.correctAnswers,
    this.incorrectAnswers,
    this.totalFriends,
    this.address,
    this.houseNo,
    this.street,
    this.city,
    this.district,
    this.zipCode,
    this.web,
    this.description,
    this.is_brand_acc,
    this.page_verified,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'fullName': fullName,
      'email': email,
      'profileImage': profileImage,
      'coverImage': coverImage,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'country': country,
      'points': points,
      'contactNo': contactNo,
      'inviteToken': inviteToken,
      'correctAnswers': correctAnswers,
      'incorrectAnswers': incorrectAnswers,
      'totalFriends': totalFriends,
      'houseNo': houseNo,
      'street': street,
      'city': city,
      'district': district,
      'zipCode': zipCode,
      'description': description,
      'web': web,
      'is_brand_acc': is_brand_acc,
      'page_verified': page_verified,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] == null ? "" : map["id"],
      username: map['username'] == null ? "" : map["username"],
      fullName: map['full_name'] == null ? "" : map["full_name"],
      email: map['email'] == null ? "" : map["email"],
      profileImage: map['profile_image'] == null
          ? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
          : map["profile_image"],
      coverImage: map['cover_image'] == null
          ? "https://upload.wikimedia.org/wikipedia/commons/b/b9/No_Cover.jpg"
          : map["cover_Image"],
      gender: map['gender'] == null ? "" : map["gender"],
      dateOfBirth: map['date_of_birth'] == null ? "" : map["date_of_birth"],
      country: map['city'] == null ? "" : map["city"],
      points: map['points'] == null ? 0 : map["points"],
      contactNo: map['contact_no'] == null ? "" : map["contact_no"],
      inviteToken: map['invite_token'] == null ? "" : map["invite_token"],
      correctAnswers:
          map['correct_answers'] == null ? 0 : map["correct_answers"],
      incorrectAnswers:
          map['incorrect_answers'] == null ? 0 : map["incorrect_answers"],
      totalFriends: map['total_friends'] == null ? 0 : map["total_friends"],
      address: map["address"] ?? "",
      city: map["city"] ?? "",
      houseNo: map["house_no"] ?? "",
      street: map["street"] ?? "",
      district: map["district"] ?? "",
      zipCode: map["zip_code"] ?? "",
      description: map["description"] ?? "",
      web: map["web"] ?? "",
      is_brand_acc: map["is_brand_acc"] ?? false,
      page_verified: map["page_verified"] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
