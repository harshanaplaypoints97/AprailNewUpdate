import 'dart:convert';

CampaignsModel campaignsModelFromJson(String str) =>
    CampaignsModel.fromJson(json.decode(str));

String campaignsModelToJson(CampaignsModel data) => json.encode(data.toJson());

class CampaignsModel {
  CampaignsModel({
    this.type,
    this.id,
    this.name,
    this.sponsorName,
    this.redirectUrl,
    this.placement,
    this.text,
    this.startDate,
    this.endDate,
    this.dateCreated,
    this.dateUpdated,
    this.campaignType,
    this.media,
    this.description,
    this.mediaType,
    this.mediaUrl,
  });

  String type;
  String id;
  String name;
  String sponsorName;
  String redirectUrl;
  String placement;
  String text;
  String startDate;
  String endDate;
  String dateCreated;
  String dateUpdated;
  String campaignType;
  List media;
  dynamic description;
  dynamic mediaType;
  dynamic mediaUrl;

  factory CampaignsModel.fromJson(Map<String, dynamic> json) => CampaignsModel(
        type: json["type"] ?? "",
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        sponsorName: json["sponsor_name"] ?? "",
        redirectUrl: json["redirect_url"] ?? "",
        placement: json["placement"] ?? "",
        text: json["text"] ?? "",
        startDate: json["start_date"] ?? "",
        endDate: json["end_date"] ?? "",
        dateCreated: json["date_created"] ?? "",
        dateUpdated: json["date_updated"] ?? "",
        campaignType: json["campaign_type"] ?? "",
        media: json["media"] ?? "",
        description: json["description"] ?? "",
        mediaType: json["media_type"] ?? "",
        mediaUrl: json["media_url"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "name": name,
        "sponsor_name": sponsorName,
        "redirect_url": redirectUrl,
        "placement": placement,
        "text": text,
        "start_date": startDate,
        "end_date": endDate,
        "date_created": dateCreated,
        "date_updated": dateUpdated,
        "campaign_type": campaignType,
        "media": media,
        "description": description,
        "media_type": mediaType,
        "media_url": mediaUrl,
      };
}

class Media {
  Media({
    this.id,
    this.adId,
    this.mediaType,
    this.mediaUrl,
    this.redirectUrl,
    this.dateCreated,
  });

  String id;
  String adId;
  String mediaType;
  String mediaUrl;
  String redirectUrl;
  String dateCreated;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        id: json["id"] ?? "",
        adId: json["ad_id"] ?? "",
        mediaType: json["media_type"] ?? "",
        mediaUrl: json["media_url"] ?? "",
        redirectUrl: json["redirect_url"] ?? "",
        dateCreated: json["date_created"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ad_id": adId,
        "media_type": mediaType,
        "media_url": mediaUrl,
        "redirect_url": redirectUrl,
        "date_created": dateCreated,
      };
}
