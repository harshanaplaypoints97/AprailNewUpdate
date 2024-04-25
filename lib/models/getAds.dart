class GetAds {
  GetAds({
    this.done,
    this.body,
    this.message,
  });
  bool done;
  List<BodyOfGetAds> body;
  String message;

  GetAds.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = List.from(json['body']).map((e) => BodyOfGetAds.fromJson(e)).toList();
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['done'] = done;
    _data['body'] = body.map((e) => e.toJson()).toList();
    _data['message'] = message;
    return _data;
  }
}

class BodyOfGetAds {
  BodyOfGetAds({
    this.id,
    this.name,
    this.redirectUrl,
    this.placement,
    this.text,
    this.startDate,
    this.endDate,
    this.dateCreated,
    this.dateUpdated,
    this.campaignType,
    this.media,
  });
  String id;
  String name;
  String redirectUrl;
  String placement;
  String text;
  String startDate;
  String endDate;
  String dateCreated;
  String dateUpdated;
  String campaignType;
  List<Media> media;

  BodyOfGetAds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    redirectUrl = json['redirect_url'];
    placement = json['placement'];
    text = json['text'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    dateCreated = json['date_created'];
    dateUpdated = json['date_updated'];
    campaignType = json['campaign_type'];
    media = List.from(json['media']).map((e) => Media.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['redirect_url'] = redirectUrl;
    _data['placement'] = placement;
    _data['text'] = text;
    _data['start_date'] = startDate;
    _data['end_date'] = endDate;
    _data['date_created'] = dateCreated;
    _data['date_updated'] = dateUpdated;
    _data['campaign_type'] = campaignType;
    _data['media'] = media.map((e) => e.toJson()).toList();
    return _data;
  }
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

  Media.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adId = json['ad_id'];
    mediaType = json['media_type'];
    mediaUrl = json['media_url'];
    redirectUrl = json['redirect_url'];
    dateCreated = json['date_created'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['ad_id'] = adId;
    _data['media_type'] = mediaType;
    _data['media_url'] = mediaUrl;
    _data['redirect_url'] = redirectUrl;
    _data['date_created'] = dateCreated;
    return _data;
  }
}
