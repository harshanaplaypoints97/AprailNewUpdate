import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class LiveCrickeMatch {
  String ConId;

  String ImageLink;
  String LiveLink;

  LiveCrickeMatch(
    this.ConId,
    this.ImageLink,
    this.LiveLink,
  );

  factory LiveCrickeMatch.fromJson(Map<String, dynamic> json) =>
      _$LiveCrickeMatchFromJson(json);

  Map<String, dynamic> toJson() => _$LiveCrickeMatchToJson(this);
}

LiveCrickeMatch _$LiveCrickeMatchFromJson(Map<String, dynamic> json) {
  return LiveCrickeMatch(
    json['ConId'] as String,
    json['ImageLink'] as String,
    json['LiveLink'] as String,
  );
}

Map<String, dynamic> _$LiveCrickeMatchToJson(LiveCrickeMatch instance) =>
    <String, dynamic>{
      'ConId': instance.ConId,
      'ImageLink': instance.ImageLink,
      'LiveLink': instance.LiveLink,
    };
