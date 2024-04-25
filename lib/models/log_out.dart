import 'package:play_pointz/models/check_plyer_login.dart';

class LogOut {
  LogOut({
    this.done,
    this.body,
    this.message,
  });
  bool done;
  Body body;
  String message;

  LogOut.fromJson(Map<String, dynamic> json) {
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
