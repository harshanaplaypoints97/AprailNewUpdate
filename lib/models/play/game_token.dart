class GameToken {
  bool done;
  Body body;
  String message;

  GameToken({this.done, this.body, this.message});

  GameToken.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['done'] = done;
    if (body != null) {
      data['body'] = body.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Body {
  String token;
  int points;

  Body({this.token, this.points});

  Body.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = token;
    data['points'] = points;
    return data;
  }
}
