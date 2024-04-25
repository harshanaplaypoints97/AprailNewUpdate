class RedeemBlock {
  bool done;
  Body body;
  String message;

  RedeemBlock({this.done, this.body, this.message});

  RedeemBlock.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
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

class Body {
  String blockDate;
  bool isBlocked;

  Body({this.blockDate, this.isBlocked});

  Body.fromJson(Map<String, dynamic> json) {
    blockDate = json['block_date'];
    isBlocked = json['is_blocked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['block_date'] = this.blockDate;
    data['is_blocked'] = this.isBlocked;
    return data;
  }
}
