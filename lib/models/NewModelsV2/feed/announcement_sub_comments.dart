import 'package:play_pointz/models/notificaitons/announce_comment_model.dart';

class AnnouncementSubComments {
  bool done;
  Body body;
  String message;

  AnnouncementSubComments({this.done, this.body, this.message});

  AnnouncementSubComments.fromJson(Map<String, dynamic> json) {
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
  List<AnnounceComments> comments;
  int commentCount;

  Body({this.isCompleted, this.comments, this.commentCount});

  Body.fromJson(Map<String, dynamic> json) {
    isCompleted = json['is_completed'];
    if (json['comments'] != null) {
      comments = <AnnounceComments>[];
      json['comments'].forEach((v) {
        comments.add(AnnounceComments.fromJson(v));
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
