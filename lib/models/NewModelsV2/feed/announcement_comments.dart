import 'package:play_pointz/models/notificaitons/announce_comment_model.dart';

class AnnouncementComments {
  bool done;
  Body body;
  String message;

  AnnouncementComments({this.done, this.body, this.message});

  AnnouncementComments.fromJson(Map<String, dynamic> json) {
    try {
      done = json['done'];
      body = json['body'] != null ? Body.fromJson(json['body']) : null;
      message = json['message'] ?? "";
    } catch (e) {
      print(e);
    }
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
  List<AnnounceCommentModel> comments;
  int commentCount;

  Body({this.isCompleted, this.comments, this.commentCount});

  Body.fromJson(Map<String, dynamic> json) {
    isCompleted = json['is_completed'];
    if (json['comments'] != null) {
      comments = <AnnounceCommentModel>[];
      json['comments'].forEach((v) {
        comments.add(AnnounceCommentModel.fromMap(v));
      });
    }
    commentCount = json['comment_count'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_completed'] = isCompleted;
    if (comments != null) {
      data['comments'] = comments.map((v) => v.toMap()).toList();
    }
    data['comment_count'] = commentCount;
    return data;
  }
}
