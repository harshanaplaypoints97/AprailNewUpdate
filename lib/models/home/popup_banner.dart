class PopUpData {
  bool done;
  BodyOfPopUpData body;
  String message;

  PopUpData({this.done, this.body, this.message});

  PopUpData.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = json['body'] != null
        ? new BodyOfPopUpData.fromJson(json['body'])
        : null;
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

class BodyOfPopUpData {
  String id;
  String image_url;

  BodyOfPopUpData({this.id, this.image_url});

  BodyOfPopUpData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image_url = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image_url'] = this.image_url;
    return data;
  }
}
