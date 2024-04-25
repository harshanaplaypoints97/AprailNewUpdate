import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CovercationModel {
  String id;
  List<String> users;
  String lastMessage;
  String lastMessageTime;
  List<String> userlist;
  List<String> mylist;

  String UserProfileImage;
  String UserProfileName;
  int ReciverCount;
  int SenderCount;
  int SenderTyping;
  int ReciverTyping;
  int Senderblock;
  int ReciverBlock;
  int ReciverhideSeen;
  int SenderhideTyping;
  int SenderhideSeen;
  int ReciverhideTyping;
  int CreatedConvercation;

  CovercationModel(
    this.id,
    this.users,
    this.lastMessage,
    this.lastMessageTime,
    this.userlist,
    this.mylist,
    this.UserProfileImage,
    this.UserProfileName,
    this.SenderCount,
    this.ReciverCount,
    this.ReciverTyping,
    this.SenderTyping,
    this.Senderblock,
    this.ReciverBlock,
    this.SenderhideTyping,
    this.ReciverhideTyping,
    this.SenderhideSeen,
    this.ReciverhideSeen,
    this.CreatedConvercation,
  );

  factory CovercationModel.fromJson(Map<String, dynamic> json) =>
      _$CovercationModelFromJson(json);

  Map<String, dynamic> toJson() => _$CovercationModelToJson(this);
}

CovercationModel _$CovercationModelFromJson(Map<String, dynamic> json) {
  return CovercationModel(
    json['id'] as String,
    (json['users'] as List)?.map((e) => e as String)?.toList(),
    json['lastMessage'] as String,
    json['lastMessageTime'] as String,
    (json['userlist'] as List)?.map((e) => e as String)?.toList(),
    (json['mylist'] as List)?.map((e) => e as String)?.toList(),
    json['userProfileImage'] as String,
    json['UserProfileName'] as String,
    json['SenderCount'] as int,
    json['ReciverCount'] as int,
    json['ReciverTyping'] as int,
    json['SenderTyping'] as int,
    json['Senderblock'] as int,
    json['ReciverBlock'] as int,
    json['SenderhideTyping'] as int,
    json['ReciverhideTyping'] as int,
    json['SenderhideSeen'] as int,
    json['ReciverhideSeen'] as int,
    json['CreatedConvercation']as int,
  );
}

Map<String, dynamic> _$CovercationModelToJson(CovercationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'users': instance.users,
      'lastMessage': instance.lastMessage,
      'lastMessageTime': instance.lastMessageTime,
      'userlist': instance.userlist,
      'mylist': instance.mylist,
      'UserProfileImage': instance.UserProfileImage,
      'UserProfileName': instance.UserProfileImage,
      'SenderCount': instance.SenderCount,
      'recivercount': instance.ReciverCount,
      'ReciverTyping': instance.ReciverTyping,
      'SenderTyping': instance.SenderTyping,
      'Senderblock': instance.Senderblock,
      'ReciverBlock': instance.ReciverBlock,
      'SenderhideTyping': instance.SenderhideTyping,
      'ReciverhideTyping': instance.ReciverhideTyping,
      'ReciverhideSeen': instance.ReciverhideSeen,
      'SenderhideSeen': instance.SenderhideSeen,
      'CreatedConvercation':instance.CreatedConvercation,
    };
