import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class MessageModel {
  String ConId;

  String SenderName;
  String SenderId;
  String ReciveId;
  String Message;
  String MessageTime;
  String ImageUrl;
  String GiftUrl;
  int Sender_Msg_Num;
  int Reciver_Msg_Num;

  MessageModel(
      this.ConId,
      this.SenderName,
      this.SenderId,
      this.ReciveId,
      this.Message,
      this.MessageTime,
      this.ImageUrl,
      this.GiftUrl,
      this.Sender_Msg_Num,
      this.Reciver_Msg_Num);

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) {
  return MessageModel(
    json['ConId'] as String,
    json['SenderName'] as String,
    json['SenderId'] as String,
    json['ReciveId'] as String,
    json['Message'] as String,
    json['MessageTime'] as String,
    json['ImageUrl'] as String,
    json['GiftUrl'] as String,
    json['Sender_Msg_Num'] as int,
    json['Reciver_Msg_Num'] as int,
  );
}

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'ConId': instance.ConId,
      'SenderName': instance.SenderName,
      'SenderId': instance.SenderId,
      'ReciveId': instance.ReciveId,
      'Message': instance.Message,
      'MessageTime': instance.MessageTime,
      'ImageUrl': instance.ImageUrl,
      'GiftUrl': instance.GiftUrl,
      'Sender_Msg_Num':instance.Sender_Msg_Num,
      'Reciver_Msg_Num':instance.Reciver_Msg_Num

    };
