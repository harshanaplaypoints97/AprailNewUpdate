class UpdateAccImages {
  UpdateAccImages({
    this.done,
    this.body,
    this.message,
  });
  bool done;
  Body body;
  String message;

  UpdateAccImages.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['done'] = done;
    if (body != null) {
      _data['body'] = body.toJson();
    }
    _data['message'] = message;
    return _data;
  }
}

class Body {
  Body({
    this.url,
  });
  String url;

  Body.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['url'] = url;
    return _data;
  }
}
