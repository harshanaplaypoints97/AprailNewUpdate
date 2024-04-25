class FistLoginPoints {
  bool done;
  BodyOfFistLoginPoints body;
  String message;

  FistLoginPoints({this.done, this.body, this.message});

  FistLoginPoints.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = json['body'] != null ? new BodyOfFistLoginPoints.fromJson(json['body']) : null;
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

class BodyOfFistLoginPoints {
  int joinPoints;

  BodyOfFistLoginPoints({this.joinPoints});

  BodyOfFistLoginPoints.fromJson(Map<String, dynamic> json) {
    joinPoints = json['join_points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['join_points'] = this.joinPoints;
    return data;
  }
}
