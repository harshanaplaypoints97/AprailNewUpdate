class SupportReply {
  bool done;
  List<BodyOfSupportReply> body;
  String message;

  SupportReply({this.done, this.body, this.message});

  SupportReply.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    if (json['body'] != null) {
      body = <BodyOfSupportReply>[];
      json['body'].forEach((v) {
        body.add(new BodyOfSupportReply.fromJson(v));
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

class BodyOfSupportReply {
  String id;
  String playerId;
  String resolvedBy;
  String name;
  String imageUrl;
  String contactNo;
  String subject;
  String comment;
  bool isResolved;
  String resolvedDate;
  String supportId;
  String startedBy;
  String player;
  String playerImage;
  String dateCreated;

  BodyOfSupportReply(
      {this.id,
      this.playerId,
      this.resolvedBy,
      this.name,
      this.imageUrl,
      this.contactNo,
      this.subject,
      this.comment,
      this.isResolved,
      this.resolvedDate,
      this.supportId,
      this.startedBy,
      this.player,
      this.playerImage,
      this.dateCreated});

  BodyOfSupportReply.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    playerId = json['player_id'];
    resolvedBy = json['resolved_by'];
    name = json['name'];
    imageUrl = json['image_url'];
    contactNo = json['contact_no'];
    subject = json['subject'];
    comment = json['comment'];
    isResolved = json['is_resolved'];
    resolvedDate = json['resolved_date'];
    supportId = json['support_id'];
    startedBy = json['started_by'];
    player = json['player'];
    playerImage = json['player_image'];
    dateCreated = json['date_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['player_id'] = this.playerId;
    data['resolved_by'] = this.resolvedBy;
    data['name'] = this.name;
    data['image_url'] = this.imageUrl;
    data['contact_no'] = this.contactNo;
    data['subject'] = this.subject;
    data['comment'] = this.comment;
    data['is_resolved'] = this.isResolved;
    data['resolved_date'] = this.resolvedDate;
    data['support_id'] = this.supportId;
    data['started_by'] = this.startedBy;
    data['player'] = this.player;
    data['player_image'] = this.playerImage;
    data['date_created'] = this.dateCreated;
    return data;
  }
}
