class AddFriend {
  AddFriend({
    this.done,
    this.body,
    this.message,
  });
  bool done;
  Body body;
  String message;

  AddFriend.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
    message = null;
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
    this.count,
    this.friends,
  });
  int count;
  List<dynamic> friends;

  Body.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    friends = List.castFrom<dynamic, dynamic>(json['friends']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['count'] = count;
    _data['friends'] = friends;
    return _data;
  }
}
