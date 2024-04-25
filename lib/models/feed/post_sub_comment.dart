import 'package:play_pointz/models/post/comment_model.dart';

class PostSubCommentsModel {
  bool done;
  Body body;
  String message;

  PostSubCommentsModel({this.done, this.body, this.message});

  PostSubCommentsModel.fromJson(Map<String, dynamic> json) {
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
  List<Comments> comments; // Change the type here
  int commentCount;

  Body({this.isCompleted, this.comments, this.commentCount});

  Body.fromJson(Map<String, dynamic> json) {
    isCompleted = json['is_completed'];
    if (json['comments'] != null) {
      comments = <Comments>[]; // Change the type here
      json['comments'].forEach((v) {
        comments.add(Comments.fromJson(v)); // Use Comments.fromJson here
      });
    }
    commentCount = json['comment_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_completed'] = isCompleted;
    if (comments != null) {
      data['comments'] =
          comments.map((v) => v.toJson()).toList(); // Use toJson() method here
    }
    data['comment_count'] = commentCount;
    return data;
  }
}
