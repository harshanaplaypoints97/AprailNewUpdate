class CreatePost {
  bool done;
  Body body;
  String message;

  CreatePost({this.done, this.body, this.message});

  CreatePost.fromJson(Map<String, dynamic> json) {
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
  Body();

  // ignore: empty_constructor_bodies
  Body.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    return data;
  }
}
