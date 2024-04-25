class PostLike {
  bool done;
  Body body;
  String message;

  PostLike({this.done, this.body, this.message});

  PostLike.fromJson(Map<String, dynamic> json) {
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
  // Body({});
  Body();

  Body.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    return data;
  }
}
