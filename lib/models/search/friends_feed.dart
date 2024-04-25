class FriendsFeed {
  bool done;
  Body body;
  String message;

  FriendsFeed({this.done, this.body, this.message});

  FriendsFeed.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['done'] = done;
    if (body != null) {
      data['body'] = body.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Body {
  int count;
  List<Posts> posts;

  Body({this.count, this.posts});

  Body.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['posts'] != null) {
      posts = <Posts>[];
      json['posts'].forEach((v) {
        posts.add(Posts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['count'] = count;
    if (posts != null) {
      data['posts'] = posts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Posts {
  String playerName;
  String playerImage;
  List<PostComments> postComments;
  List<PostLikes> postLikes;
  String playerId;
  String mediaUrl;
  String mediaType;
  String id;
  String dateCreated;
  String dateUpdated;
  String description;

  Posts(
      {this.playerName,
      this.playerImage,
      this.postComments,
      this.postLikes,
      this.playerId,
      this.mediaUrl,
      this.mediaType,
      this.id,
      this.dateCreated,
      this.dateUpdated,
      this.description});

  Posts.fromJson(Map<String, dynamic> json) {
    playerName = json['player_name'];
    playerImage = json['player_image'];
    if (json['post_comments'] != null) {
      postComments = <PostComments>[];
      json['post_comments'].forEach((v) {
        postComments.add(PostComments.fromJson(v));
      });
    }
    if (json['post_likes'] != null) {
      postLikes = <PostLikes>[];
      json['post_likes'].forEach((v) {
        postLikes.add(PostLikes.fromJson(v));
      });
    }
    playerId = json['player_id'];
    mediaUrl = json['media_url'];
    mediaType = json['media_type'];
    id = json['id'];
    dateCreated = json['date_created'];
    dateUpdated = json['date_updated'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['player_name'] = playerName;
    data['player_image'] = playerImage;
    if (postComments != null) {
      data['post_comments'] = postComments.map((v) => v.toJson()).toList();
    }
    if (postLikes != null) {
      data['post_likes'] = postLikes.map((v) => v.toJson()).toList();
    }
    data['player_id'] = playerId;
    data['media_url'] = mediaUrl;
    data['media_type'] = mediaType;
    data['id'] = id;
    data['date_created'] = dateCreated;
    data['date_updated'] = dateUpdated;
    data['description'] = description;
    return data;
  }
}

class PostComments {
  String id;
  String playerId;
  String postId;
  String commentId;
  String comment;
  String dateCreated;
  String playerName;
  String playerImage;
  // List<Null> likes;

  PostComments({
    this.id,
    this.playerId,
    this.postId,
    this.commentId,
    this.comment,
    this.dateCreated,
    this.playerName,
    this.playerImage,
    // this.likes
  });

  PostComments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    playerId = json['player_id'];
    postId = json['post_id'];
    commentId = json['comment_id'];
    comment = json['comment'];
    dateCreated = json['date_created'];
    playerName = json['player_name'];
    playerImage = json['player_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['player_id'] = playerId;
    data['post_id'] = postId;
    data['comment_id'] = commentId;
    data['comment'] = comment;
    data['date_created'] = dateCreated;
    data['player_name'] = playerName;
    data['player_image'] = playerImage;
    return data;
  }
}

class PostLikes {
  String id;
  String playerId;
  String postId;
  String dateCreated;

  PostLikes({this.id, this.playerId, this.postId, this.dateCreated});

  PostLikes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    playerId = json['player_id'];
    postId = json['post_id'];
    dateCreated = json['date_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['player_id'] = playerId;
    data['post_id'] = postId;
    data['date_created'] = dateCreated;
    return data;
  }
}
