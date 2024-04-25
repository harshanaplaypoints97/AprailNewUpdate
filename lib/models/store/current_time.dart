class CurrentTime {
  bool done;
  BodyOfCurrentTime body;
  String message;

  CurrentTime({this.done, this.body, this.message});

  CurrentTime.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = json['body'] != null ? new BodyOfCurrentTime.fromJson(json['body']) : null;
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

class BodyOfCurrentTime {
  String currentTime;

  BodyOfCurrentTime({this.currentTime});

  BodyOfCurrentTime.fromJson(Map<String, dynamic> json) {
    currentTime = json['current_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_time'] = this.currentTime;
    return data;
  }
}
