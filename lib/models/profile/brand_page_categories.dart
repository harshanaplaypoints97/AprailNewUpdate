class BrandPageCategories {
  bool done;
  List<BodyOfBrandPageCategories> body;
  String message;

  BrandPageCategories({this.done, this.body, this.message});

  BrandPageCategories.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    if (json['body'] != null) {
      body = <BodyOfBrandPageCategories>[];
      json['body'].forEach((v) {
        body.add(new BodyOfBrandPageCategories.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['done'] = this.done;
    if (this.body != null) {
      data['body'] = this.body.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class BodyOfBrandPageCategories {
  String id;
  String category;
  String dateCreated;
  String dateUpdated;

  BodyOfBrandPageCategories({this.id, this.category, this.dateCreated, this.dateUpdated});

  BodyOfBrandPageCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    dateCreated = json['date_created'];
    dateUpdated = json['date_updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['date_created'] = this.dateCreated;
    data['date_updated'] = this.dateUpdated;
    return data;
  }
}
