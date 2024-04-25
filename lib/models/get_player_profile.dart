class GetPlayerProfile {
  GetPlayerProfile({
    this.done,
    this.body,
    this.message,
  });
  bool done;
  BodyOfProfileData body;
  String message;

  GetPlayerProfile.fromJson(Map<String, dynamic> json) {
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
      this.web,
      this.contact_no,
      this.description,
      this.points,
      this.inviteToken,
      this.correctAnswers,
      this.incorrectAnswers,
      this.totalFriends,
      this.totalPosts,
      this.friendStatus,
      this.address,
      this.page_category,
      this.is_brand_acc,
      this.page_verified,
      this.is_private,
      this.show_point_count,
      this.show_answer_count});

  String id;
  String username;
  String email;
  String fullName;
  String profileImage;
  String coverImage;
  String gender;
  String dateOfBirth;
  String country;
  String web;
  String contact_no;
  String description;
  int points;
  String inviteToken;
  int correctAnswers;
  int incorrectAnswers;
  int totalFriends;
  int totalPosts;
  String friendStatus;
  String address;
  String page_category;
  bool is_brand_acc;
  bool page_verified;
  bool is_private;
  bool show_point_count;
  bool show_answer_count;

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
    web = json['web'];
    description = json['description'];
    contact_no = json['contact_no'];
    points = json['points'];
    inviteToken = json['invite_token'];
    correctAnswers = json['correct_answers'];
    incorrectAnswers = json['incorrect_answers'];
    totalFriends = json['total_friends'] != null ? json['total_friends'] : 0;
    totalPosts = json['total_posts'];
    friendStatus = json['friend_status'];
    address = json['address'];
    page_category = json['page_category'];
    is_brand_acc = json['is_brand_acc'] != null ? json['is_brand_acc'] : false;
    page_verified =
        json['page_verified'] != null ? json['page_verified'] : false;
    is_private = json['is_private'] != null ? json['is_private'] : false;
    show_point_count =
        json['show_point_count'] != null ? json['show_point_count'] : true;
    show_answer_count =
        json['show_answer_count'] != null ? json['show_answer_count'] : true;
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
    _data['web'] = web;
    _data['description'] = description;
    _data['contact_no'] = contact_no;
    _data['points'] = points;
    _data['invite_token'] = inviteToken;
    _data['correct_answers'] = correctAnswers;
    _data['incorrect_answers'] = incorrectAnswers;
    _data['total_friends'] = totalFriends;
    _data['total_posts'] = totalPosts;
    _data['friend_status'] = friendStatus;
    _data['address'] = address;
    _data['page_category'] = page_category;
    _data['is_brand_acc'] = is_brand_acc;
    _data['page_verified'] = page_verified;
    _data['is_private'] = is_private;
    _data['show_point_count'] = show_point_count;
    _data['show_answer_count'] = show_answer_count;
    return _data;
  }
}
