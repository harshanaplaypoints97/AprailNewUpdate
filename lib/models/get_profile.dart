class GetProfile {
  GetProfile({
    this.done,
    this.body,
    this.message,
  });
  bool done;
  BodyOfProfileData body;
  String message;

  GetProfile.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body =
        json['body'] != null ? BodyOfProfileData.fromJson(json['body']) : null;
    message = null;
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

class BodyOfProfileData {
  BodyOfProfileData(
      {this.id,
      this.username,
      this.email,
      this.fullName,
      this.profileImage,
      this.coverImage,
      this.gender,
      this.dateOfBirth,
      this.country,
      this.points,
      this.inviteToken,
      this.correctAnswers,
      this.incorrectAnswers,
      this.totalFriends,
      this.friendStatus});
  String id;
  String username;
  String email;
  String fullName;
  String profileImage;
  String coverImage;
  String gender;
  String dateOfBirth;
  String country;
  int points;
  String inviteToken;
  int correctAnswers;
  int incorrectAnswers;
  int totalFriends;
  String friendStatus;

  BodyOfProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    fullName = json['full_name'];
    profileImage = json['profile_image'];
    coverImage = json['cover_image'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    country = json['country'];
    points = json['points'];
    inviteToken = json['invite_token'];
    correctAnswers = json['correct_answers'];
    incorrectAnswers = json['incorrect_answers'];
    totalFriends = json['total_friends'];
    friendStatus = json['friend_ststus'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['username'] = username;
    _data['email'] = email;
    _data['full_name'] = fullName;
    _data['profile_image'] = profileImage;
    _data['cover_image'] = coverImage;
    _data['gender'] = gender;
    _data['date_of_birth'] = dateOfBirth;
    _data['country'] = country;
    _data['points'] = points;
    _data['invite_token'] = inviteToken;
    _data['correct_answers'] = correctAnswers;
    _data['incorrect_answers'] = incorrectAnswers;
    _data['total_friends'] = totalFriends;
    _data['friend_status'] = friendStatus;
    return _data;
  }
}
