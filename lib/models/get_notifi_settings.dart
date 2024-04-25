class GetNotifiSettings {
  GetNotifiSettings({
    this.done,
    this.body,
    this.message,
  });
  bool done;
  Body body;
  String message;

  GetNotifiSettings.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['done'] = done;

    if (body != null) {
      _data['body'] = body.toJson();
    }
    _data['message'] = message;
    return _data;
  }
}

class Body {
  Body({
    this.playerId,
    this.isPushNotification,
    this.isEmailNotification,
  });
  String playerId;
  bool isPushNotification;
  bool isEmailNotification;

  Body.fromJson(Map<String, dynamic> json) {
    playerId = json['player_id'];
    isPushNotification = json['is_push_notification'];
    isEmailNotification = json['is_email_notification'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['player_id'] = playerId;
    _data['is_push_notification'] = isPushNotification;
    _data['is_email_notification'] = isEmailNotification;
    return _data;
  }
}
