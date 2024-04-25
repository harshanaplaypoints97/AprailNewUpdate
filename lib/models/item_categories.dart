class GetItemCategories {
  GetItemCategories({
    this.done,
    this.body,
    this.message,
  });
  bool done;
  List<BodyOfCategories> body;
  String message;

  GetItemCategories.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = List.from(json['body'])
        .map((e) => BodyOfCategories.fromJson(e))
        .toList();
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['done'] = done;
    _data['body'] = body.map((e) => e.toJson()).toList();
    _data['message'] = message;
    return _data;
  }
}

class BodyOfCategories {
  BodyOfCategories({
    this.id,
    this.name,
    this.imageUrl,
  });
  String id;
  String name;
  String imageUrl;

  BodyOfCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['image_url'] = imageUrl;
    return _data;
  }
}
