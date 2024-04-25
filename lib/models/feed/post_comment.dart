import 'package:play_pointz/models/post/comment_model.dart';

class PostCommentsModel {
  bool done;
  Body body;
  String message;

  PostCommentsModel({this.done, this.body, this.message});

  PostCommentsModel.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['done'] = done;
    if (body != null) {
      data['body'] = body.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Body {
  bool isCompleted;
  List<CommentModel> comments; // Change the type here
  int commentCount;

  Body({this.isCompleted, this.comments, this.commentCount});

  Body.fromJson(Map<String, dynamic> json) {
    isCompleted = json['is_completed'];
    if (json['comments'] != null) {
      comments = <CommentModel>[]; // Change the type here
      json['comments'].forEach((v) {
        comments.add(CommentModel.fromMap(v)); // Use CommentModel.fromMap here
      });
    }
    commentCount = json['comment_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_completed'] = isCompleted;
    if (comments != null) {
      data['comments'] =
          comments.map((v) => v.toMap()).toList(); // Use toMap() method here
    }
    data['comment_count'] = commentCount;
    return data;
  }
}

/* 
class Body {
  bool isCompleted;
  List<MainComments> comments;
  int commentCount;

  Body({this.isCompleted, this.comments, this.commentCount});

  Body.fromJson(Map<String, dynamic> json) {
    isCompleted = json['is_completed'];
    if (json['comments'] != null) {
      comments = <MainComments>[];
      json['comments'].forEach((v) {
        comments.add(MainComments.fromJson(v));
      });
    }
    commentCount = json['comment_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_completed'] = isCompleted;
    if (comments != null) {
      data['comments'] = comments.map((v) => v.toJson()).toList();
    }
    data['comment_count'] = commentCount;
    return data;
  }
}
 */
class MainComments {
  String id;
  String playerId;
  String postId;
  String commentId;
  String comment;
  String dateCreated;
  String playerName;
  String playerImage;
  bool isBrandVerified;
  List<Comments> comments;

  MainComments(
      {this.id,
      this.playerId,
      this.postId,
      this.commentId,
      this.comment,
      this.dateCreated,
      this.playerName,
      this.playerImage,
      this.isBrandVerified,
      this.comments});

  MainComments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    playerId = json['player_id'];
    postId = json['post_id'];
    commentId = json['comment_id'];
    comment = json['comment'];
    dateCreated = json['date_created'];
    playerName = json['player_name'];
    playerImage = json['player_image'];
    isBrandVerified = json['is_brand_verified'];
    if (json['comments'] != null) {
      comments = <Null>[];
      json['comments'].forEach((v) {
        comments.add(Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['player_id'] = playerId;
    data['post_id'] = postId;
    data['comment_id'] = commentId;
    data['comment'] = comment;
    data['date_created'] = dateCreated;
    data['player_name'] = playerName;
    data['player_image'] = playerImage;
    data['is_brand_verified'] = isBrandVerified;
    if (comments != null) {
      data['comments'] = comments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
