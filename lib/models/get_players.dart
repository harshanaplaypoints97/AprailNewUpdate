class GetPlayers {
  GetPlayers({
    this.done,
    this.body,
    this.message,
  });
  bool done;
  Body body;
  String message;

  GetPlayers.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
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

class Body {
  Body({
    this.count,
    this.players,
  });
  int count;
  List<Players> players;

  Body.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    players =
        List.from(json['players']).map((e) => Players.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['count'] = count;
    _data['players'] = players.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Players {
  Players(
      {this.id,
      this.username,
      this.email,
      this.fullName,
      this.facebookId,
      this.googleToken,
      this.profileImage,
      this.coverImage,
      this.isActive,
      this.isBlocked,
      this.dateCreated,
      this.dateUpdated,
      this.points,
      this.friendStatus});
  String id;
  String username;
  String email;
  String fullName;
  String facebookId;
  String googleToken;
  String profileImage;
  String coverImage;
  bool isActive;
  bool isBlocked;
  String dateCreated;
  String dateUpdated;
  int points;
  String friendStatus;

  Players.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    fullName = json['full_name'];
    facebookId = json['facebook_id'];
    googleToken = json['google_token'];
    profileImage = json['profile_image'];
    coverImage = json['cover_image'];
    isActive = json['is_active'];
    isBlocked = json['is_blocked'];
    dateCreated = json['date_created'];
    dateUpdated = json['date_updated'];
    points = json['points'];
    friendStatus = json['friend_status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['username'] = username;
    _data['email'] = email;
    _data['full_name'] = fullName;
    _data['facebook_id'] = facebookId;
    _data['google_token'] = googleToken;
    _data['profile_image'] = profileImage;
    _data['cover_image'] = coverImage;
    _data['is_active'] = isActive;
    _data['is_blocked'] = isBlocked;
    _data['date_created'] = dateCreated;
    _data['date_updated'] = dateUpdated;
    _data['points'] = points;
    _data['friend_status'] = friendStatus;
    return _data;
  }
}
