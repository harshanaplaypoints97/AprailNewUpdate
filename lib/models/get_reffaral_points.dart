class GetRefarralPoints {
  bool done;
  BodyOfGetRefarralPoints body;
  String message;

  GetRefarralPoints({this.done, this.body, this.message});

  GetRefarralPoints.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = json['body'] != null ? new BodyOfGetRefarralPoints.fromJson(json['body']) : null;
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

class BodyOfGetRefarralPoints {
  int joinPoints;

  BodyOfGetRefarralPoints({this.joinPoints});

  BodyOfGetRefarralPoints.fromJson(Map<String, dynamic> json) {
    joinPoints = json['referral_points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['referral_points'] = this.joinPoints;
    return data;
  }
}
