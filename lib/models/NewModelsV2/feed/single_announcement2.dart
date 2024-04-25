class SingleAnnouncement {
  bool done;
  BodyOfSingleAnnouncement body;
  String message;

  SingleAnnouncement({this.done, this.body, this.message});

  SingleAnnouncement.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = json['body'] != null
        ? new BodyOfSingleAnnouncement.fromJson(json['body'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['done'] = this.done;
    if (this.body != null) {
      data['body'] = this.body.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class BodyOfSingleAnnouncement {
  String playerName;
  String playerImage;
  List<SingleAnnouncementComments> announcementComments;
  List<SingleAnnouncementLikes> announcementLikes;
  bool isLiked;
  String playerId;
  String type;
  String id;
  String dateCreated;
  String dateUpdated;
  String description;
  String mediaType;
  String mediaUrl;
  String thumbUrl;
  String originalUrl;
  String orderBy;
  String itemName;
  String likesCount;
  String commentsCount;
  String likeId;

  BodyOfSingleAnnouncement(
      {this.playerName,
      this.likeId,
      this.playerImage,
      this.announcementComments,
      this.announcementLikes,
      this.isLiked,
      this.playerId,
      this.type,
      this.id,
      this.dateCreated,
      this.dateUpdated,
      this.description,
      this.mediaType,
      this.mediaUrl,
      this.thumbUrl,
      this.originalUrl,
      this.orderBy,
      this.itemName,
      this.likesCount,
      this.commentsCount});

  BodyOfSingleAnnouncement.fromJson(Map<String, dynamic> json) {
    playerName = json['player_name'];
    playerImage = json['player_image'];
    if (json['announcement_comments'] != null) {
      announcementComments = <SingleAnnouncementComments>[];
      json['announcement_comments'].forEach((v) {
        announcementComments.add(new SingleAnnouncementComments.fromJson(v));
      });
    }
    if (json['announcement_likes'] != null) {
      announcementLikes = <SingleAnnouncementLikes>[];
      json['announcement_likes'].forEach((v) {
        announcementLikes.add(new SingleAnnouncementLikes.fromJson(v));
      });
    }
    isLiked = json['is_liked'];
    playerId = json['player_id'];
    type = json['type'];
    id = json['id'];
    dateCreated = json['date_created'];
    dateUpdated = json['date_updated'];
    description = json['description'];
    mediaType = json['media_type'];
    mediaUrl = json['media_url'];
    thumbUrl = json['thumb_url'];
    originalUrl = json['original_url'];
    orderBy = json['order_by'];
    itemName = json['item_name'];
    likesCount = json['likes_count'];
    commentsCount = json['comments_count'];
    likeId = json["like_id"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['player_name'] = this.playerName;
    data['player_image'] = this.playerImage;
    if (this.announcementComments != null) {
      data['announcement_comments'] =
          this.announcementComments.map((v) => v.toJson()).toList();
    }
    if (this.announcementLikes != null) {
      data['announcement_likes'] =
          this.announcementLikes.map((v) => v.toJson()).toList();
    }
    data['is_liked'] = this.isLiked;
    data['player_id'] = this.playerId;
    data['type'] = this.type;
    data['id'] = this.id;
    data['date_created'] = this.dateCreated;
    data['date_updated'] = this.dateUpdated;
    data['description'] = this.description;
    data['media_type'] = this.mediaType;
    data['media_url'] = this.mediaUrl;
    data['thumb_url'] = this.thumbUrl;
    data['original_url'] = this.originalUrl;
    data['order_by'] = this.orderBy;
    data['item_name'] = this.itemName;
    data['likes_count'] = this.likesCount;
    data['comments_count'] = this.commentsCount;
    data['like_id'] = this.likeId;
    return data;
  }
}

class SingleAnnouncementComments {
  String id;
  String playerId;
  String announcementId;
  String commentId;
  String comment;
  String dateCreated;
  String playerName;
  String playerImage;
  bool is_brand_verified;

  List<SingleComments> comments;

  SingleAnnouncementComments(
      {this.id,
      this.playerId,
      this.announcementId,
      this.commentId,
      this.comment,
      this.dateCreated,
      this.playerName,
      this.playerImage,
      this.comments,
      this.is_brand_verified});

  SingleAnnouncementComments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    playerId = json['player_id'];
    announcementId = json['announcement_id'];
    commentId = json['comment_id'];
    comment = json['comment'];
    dateCreated = json['date_created'];
    playerName = json['player_name'];
    playerImage = json['player_image'];
    is_brand_verified = json['is_brand_verified'] ?? false;
    if (json['comments'] != null) {
      comments = <SingleComments>[];
      json['comments'].forEach((v) {
        comments.add(new SingleComments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['player_id'] = this.playerId;
    data['announcement_id'] = this.announcementId;
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

class SingleComments {
  String id;
  String playerId;
  String announcementId;
  String commentId;
  String comment;
  String dateCreated;
  String playerName;
  String playerImage;
  bool is_brand_verified;

  SingleComments(
      {this.id,
      this.playerId,
      this.announcementId,
      this.commentId,
      this.comment,
      this.dateCreated,
      this.playerName,
      this.playerImage,
      this.is_brand_verified});

  SingleComments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    playerId = json['player_id'];
    announcementId = json['announcement_id'];
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
    data['announcement_id'] = this.announcementId;
    data['comment_id'] = this.commentId;
    data['comment'] = this.comment;
    data['date_created'] = this.dateCreated;
    data['player_name'] = this.playerName;
    data['player_image'] = this.playerImage;
    data['is_brand_verified'] = this.is_brand_verified;
    return data;
  }
}

class SingleAnnouncementLikes {
  String id;
  String playerId;
  String announcementId;
  String dateCreated;

  SingleAnnouncementLikes(
      {this.id, this.playerId, this.announcementId, this.dateCreated});

  SingleAnnouncementLikes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    playerId = json['player_id'];
    announcementId = json['announcement_id'];
    dateCreated = json['date_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['player_id'] = this.playerId;
    data['announcement_id'] = this.announcementId;
    data['date_created'] = this.dateCreated;
    return data;
  }
}
