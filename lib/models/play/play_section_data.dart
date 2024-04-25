class PlaySectionData {
  bool done;
  List<PlaySectionDataBody> body;
  String message;

  PlaySectionData({this.done, this.body, this.message});

  PlaySectionData.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    if (json['body'] != null) {
      body = <PlaySectionDataBody>[];
      json['body'].forEach((v) {
        body.add(PlaySectionDataBody.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['done'] = this.done;
    if (body != null) {
      data['body'] = this.body.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class PlaySectionDataBody {
  bool loading = false;
  String id;
  String name;
  String version;
  String description;
  int expensePoints;
  int scoreEqualsTo;
  int plusScore;
  int minusScore;
  bool isActive;
  String imageUrl;
  String dateCreated;
  String dateUpdated;
  String type;
  String gameUrl;

  PlaySectionDataBody(
      {this.id,
      this.loading,
      this.name,
      this.version,
      this.description,
      this.expensePoints,
      this.scoreEqualsTo,
      this.plusScore,
      this.minusScore,
      this.isActive,
      this.imageUrl,
      this.dateCreated,
      this.dateUpdated,
      this.type,
      this.gameUrl});

  PlaySectionDataBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    version = json['version'];
    description = json['description'];
    expensePoints = json['expense_points'];
    scoreEqualsTo = json['score_equals_to'];
    plusScore = json['plus_score'];
    minusScore = json['minus_score'];
    isActive = json['is_active'];
    imageUrl = json['image_url'];
    dateCreated = json['date_created'];
    dateUpdated = json['date_updated'];
    type = json['type'];
    gameUrl = json['game_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['version'] = version;
    data['description'] = description;
    data['expense_points'] = expensePoints;
    data['score_equals_to'] = scoreEqualsTo;
    data['plus_score'] = plusScore;
    data['minus_score'] = minusScore;
    data['is_active'] = isActive;
    data['image_url'] = imageUrl;
    data['date_created'] = dateCreated;
    data['date_updated'] = dateUpdated;
    data['type'] = type;
    data['game_url'] = gameUrl;
    return data;
  }
}
