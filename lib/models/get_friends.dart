class GetFriends {
  GetFriends({
    this.done,
    this.body,
    this.message,
  });
  bool done;
  BodyOfFriends body;
  String message;

  GetFriends.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = json['body'] != null ? BodyOfFriends.fromJson(json['body']) : null;
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

class BodyOfFriends {
  BodyOfFriends({
    this.count,
    this.friends,
  });
  int count;
  List<AllFriends> friends;

  BodyOfFriends.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    friends =
        List.from(json['friends']).map((e) => AllFriends.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['count'] = count;
    _data['friends'] = friends.map((e) => e.toJson()).toList();
    return _data;
  }
}

class AllFriends {
  AllFriends(
      {this.friendshipId_1,
      this.friendshipId_2,
      this.isAccepted,
      this.dateCreated,
      this.username,
      this.fullName,
      this.profileimage,
      this.id});
  String friendshipId_1;
  String friendshipId_2;
  bool isAccepted;
  String dateCreated;
  String username;
  String fullName;
  String profileimage;
  String id;

  AllFriends.fromJson(Map<String, dynamic> json) {
    friendshipId_1 = json['friendship_id_1'];
    friendshipId_2 = json['friendship_id_2'];
    isAccepted = json['is_accepted'];
    dateCreated = json['date_created'];
    username = json['username'];
    fullName = json['full_name'];
    profileimage = json['profile_image'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['friendship_id_1'] = friendshipId_1;
    _data['friendship_id_2'] = friendshipId_2;
    _data['is_accepted'] = isAccepted;
    _data['date_created'] = dateCreated;
    _data['username'] = username;
    _data['full_name'] = fullName;
    _data['profile_image'] = profileimage;
    _data['id'] = id;
    return _data;
  }
}
