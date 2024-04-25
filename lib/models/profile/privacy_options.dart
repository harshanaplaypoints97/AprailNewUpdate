class PrivacyOptions {
  bool done;
  BodyOfPrivacyOptions body;
  String message;

  PrivacyOptions({this.done, this.body, this.message});

  PrivacyOptions.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = json['body'] != null ? new BodyOfPrivacyOptions.fromJson(json['body']) : null;
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

class BodyOfPrivacyOptions {
  String id;
  bool isPrivate;
  bool showAnswerCount;
  bool showPointCount;

  BodyOfPrivacyOptions({this.id, this.isPrivate, this.showAnswerCount, this.showPointCount});

  BodyOfPrivacyOptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isPrivate = json['is_private'];
    showAnswerCount = json['show_answer_count'];
    showPointCount = json['show_point_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_private'] = this.isPrivate;
    data['show_answer_count'] = this.showAnswerCount;
    data['show_point_count'] = this.showPointCount;
    return data;
  }
}
