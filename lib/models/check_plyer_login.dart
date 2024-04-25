class CheckPlayerLogin {
  CheckPlayerLogin({
    this.done,
    this.body,
    this.message,
  });
  bool done;
  Body body;
  String message;

  CheckPlayerLogin.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['done'] = done;
    if (body != null) {
      _data['body'] = body.toJson();
    }
    _data['message'] = message;
    return _data;
  }
}

class Body {
  Body({
    this.id,
    this.type,
    this.username,
    this.fullName,
    this.email,
    this.isActive,
    this.isVerified,
    this.isBlocked,
    this.googleToken,
    this.facebookId,
    this.profileImage,
    this.coverImage,
    this.dateCreated,
    this.dateUpdated,
    this.country,
    this.dateOfBirth,
  });
  String id;
  String type;
  String username;
  String fullName;
  String email;
  bool isActive;
  bool isVerified;
  bool isBlocked;
  String googleToken;
  String facebookId;
  String profileImage;
  String coverImage;
  String dateCreated;
  String dateUpdated;
  String country;
  String dateOfBirth;

  Body.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    username = json['username'];
    fullName = json['full_name'];
    email = json['email'];
    isActive = json['is_active'];
    isVerified = json['is_verified'];
    isBlocked = json['is_blocked'];
    googleToken = json['google_token'];
    facebookId = json['facebook_id'];
    profileImage = json['profile_image'];
    coverImage = json['cover_image'];
    dateCreated = json['date_created'];
    dateUpdated = json['date_updated'];
    country = json['country'];
    dateOfBirth = json['date_of_birth'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['type'] = type;
    _data['username'] = username;
    _data['full_name'] = fullName;
    _data['email'] = email;
    _data['is_active'] = isActive;
    _data['is_verified'] = isVerified;
    _data['is_blocked'] = isBlocked;
    _data['google_token'] = googleToken;
    _data['facebook_id'] = facebookId;
    _data['profile_image'] = profileImage;
    _data['cover_image'] = coverImage;
    _data['date_created'] = dateCreated;
    _data['date_updated'] = dateUpdated;
    _data['country'] = country;
    _data['date_of_birth'] = dateOfBirth;
    return _data;
  }
}
