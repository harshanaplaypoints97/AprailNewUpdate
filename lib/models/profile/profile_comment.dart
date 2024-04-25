class ProfileComments {
  bool done;
  List<BodyOfProfileComments> body;
  String message;

  ProfileComments({this.done, this.body, this.message});

  ProfileComments.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    if (json['body'] != null) {
      body = <BodyOfProfileComments>[];
      json['body'].forEach((v) {
        body.add(new BodyOfProfileComments.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['done'] = this.done;
    if (this.body != null) {
      data['body'] = this.body.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class BodyOfProfileComments {
  String id;
  String playerId;
  String postId;
  String commentId;
  String comment;
  String dateCreated;
  String playerName;
  String playerImage;
  bool is_brand_verified;
  // List<Null> likes;
  List<SubComments> comments;

  BodyOfProfileComments(
      {this.id,
      this.playerId,
      this.postId,
      this.commentId,
      this.comment,
      this.dateCreated,
      this.playerName,
      this.playerImage,
      this.is_brand_verified,
      // this.likes,
      this.comments});

  BodyOfProfileComments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    playerId = json['player_id'];
    postId = json['post_id'];
    commentId = json['comment_id'];
    comment = json['comment'];
    dateCreated = json['date_created'];
    playerName = json['player_name'];
    playerImage = json['player_image'];
    is_brand_verified = json['is_brand_verified'] ?? false;
    if (json['comments'] != null) {
      comments = <SubComments>[];
      json['comments'].forEach((v) {
        comments.add(new SubComments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['player_id'] = this.playerId;
    data['post_id'] = this.postId;
    data['comment_id'] = this.commentId;
    data['comment'] = this.comment;
    data['date_created'] = this.dateCreated;
    data['player_name'] = this.playerName;
    data['player_image'] = this.playerImage;
    data['is_brand_verified'] = this.is_brand_verified;
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubComments {
  String id;
  String playerId;
  String postId;
  String commentId;
  String comment;
  String dateCreated;
  String playerName;
  String playerImage;
  bool is_brand_verified;

  SubComments(
      {this.id,
      this.playerId,
      this.postId,
      this.commentId,
      this.comment,
      this.dateCreated,
      this.playerName,
      this.playerImage,
      this.is_brand_verified});

  SubComments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    playerId = json['player_id'];
    postId = json['post_id'];
    commentId = json['comment_id'];
    comment = json['comment'];
    dateCreated = json['date_created'];
    playerName = json['player_name'];
    playerImage = json['player_image'];
    is_brand_verified = json['is_brand_verified'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['player_id'] = this.playerId;
    data['post_id'] = this.postId;
    data['comment_id'] = this.commentId;
    data['comment'] = this.comment;
    data['date_created'] = this.dateCreated;
    data['player_name'] = this.playerName;
    data['player_image'] = this.playerImage;
    data['is_brand_verified'] = this.is_brand_verified;
    return data;
  }
}
