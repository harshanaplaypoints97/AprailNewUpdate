import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PlayMartModel {
  String ConId;
  List<String> ItemNameList;
  List<String> ItemPriceList;
  List<String> ItemDescriptionList;
  List<String> ItemImageList;
  List<String> ItemReviewLink;
  List<String> RedeamPointList;

  List<bool> ColorVisible;
  List<bool> WeightVisible;
  List<bool> SizeVisible;
  Map<String, dynamic> ColorList;
  Map<String, dynamic> SizeList;
  Map<String, dynamic> WeightList;

  String SenderName;
  String SenderId;
  String ReciveId;
  String Message;
  String MessageTime;
  String ImageUrl;
  String GiftUrl;
  int Sender_Msg_Num;
  int Reciver_Msg_Num;

  PlayMartModel(
    this.ConId,
    this.ItemNameList,
    this.ItemPriceList,
    this.ItemDescriptionList,
    this.ItemImageList,
    this.ItemReviewLink,
    this.RedeamPointList,
    this.ColorVisible,
    this.WeightVisible,
    this.SizeVisible,
    this.ColorList,
    this.SizeList,
    this.WeightList,
    this.SenderName,
    this.SenderId,
    this.ReciveId,
    this.Message,
    this.MessageTime,
    this.ImageUrl,
    this.GiftUrl,
    this.Sender_Msg_Num,
    this.Reciver_Msg_Num,
  );

  factory PlayMartModel.fromJson(Map<String, dynamic> json) =>
      _$PlayMartModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlayMartModelToJson(this);
}

PlayMartModel _$PlayMartModelFromJson(Map<String, dynamic> json) {
  return PlayMartModel(
    json['ConId'] as String,
    (json['ItemNameList'] as List)?.map((e) => e as String)?.toList(),
    (json['ItemPriceList'] as List)?.map((e) => e as String)?.toList(),
    (json['ItemDescriptionList'] as List)?.map((e) => e as String)?.toList(),
    (json['ItemImageList'] as List)?.map((e) => e as String)?.toList(),
    (json['ItemReviewLink'] as List)?.map((e) => e as String)?.toList(),
    (json['RedeamPointList'] as List)?.map((e) => e as String)?.toList(),
    (json['ColorVisible'] as List)?.map((e) => e as bool)?.toList(),
    (json['WeightVisible'] as List)?.map((e) => e as bool)?.toList(),
    (json['SizeVisible'] as List)?.map((e) => e as bool)?.toList(),
    json['ColorList'] as Map<String, dynamic>,
    json['SizeList'] as Map<String, dynamic>,
    json['WeightList'] as Map<String, dynamic>,
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

Map<String, dynamic> _$PlayMartModelToJson(PlayMartModel instance) =>
    <String, dynamic>{
      'ConId': instance.ConId,
      'ItemNameList': instance.ItemNameList,
      'ItemPriceList': instance.ItemPriceList,
      'ItemDescriptionList': instance.ItemDescriptionList,
      'ItemImageList': instance.ItemImageList,
      'ItemReveiwLink': instance.ItemReviewLink,
      'RedeamPointList': instance.RedeamPointList,
      'ColorVisible': instance.ColorVisible,
      'WeightVisible': instance.WeightVisible,
      'SizeVisible': instance.SizeVisible,
      'ColorList': instance.ColorList,
      'SizeList': instance.SizeList,
      'WeightList': instance.SizeList,
      'SenderName': instance.SenderName,
      'SenderId': instance.SenderId,
      'ReciveId': instance.ReciveId,
      'Message': instance.Message,
      'MessageTime': instance.MessageTime,
      'ImageUrl': instance.ImageUrl,
      'GiftUrl': instance.GiftUrl,
      'Sender_Msg_Num': instance.Sender_Msg_Num,
      'Reciver_Msg_Num': instance.Reciver_Msg_Num,
    };
