import 'package:flutter/cupertino.dart';

class GetItems {
  GetItems({
    this.done,
    this.body,
    this.message,
  });
  bool done;
  Body body;
  String message;

  GetItems.fromJson(Map<String, dynamic> json) {
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
    this.upcomingArrivals,
    this.newArrivals,
  });
  List<UpcomingArrivals> upcomingArrivals;
  List<NewArrivals> newArrivals;

  Body.fromJson(Map<String, dynamic> json) {
    upcomingArrivals = List.from(json['upcomingArrivals'])
        .map((e) => UpcomingArrivals.fromJson(e))
        .toList();
    newArrivals = List.from(json['newArrivals'])
        .map((e) => NewArrivals.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['upcomingArrivals'] =
        upcomingArrivals.map((e) => e.toJson()).toList();
    _data['newArrivals'] = newArrivals.map((e) => e.toJson()).toList();
    return _data;
  }
}

class UpcomingArrivals {
  UpcomingArrivals(
      {this.delivery_option,
      this.id,
      this.itemCategoryId,
      this.stockAmount,
      this.priceInPoints,
      this.price,
      this.name,
      this.description,
      this.imageUrl,
      this.thumbnailUrl,
      this.dateCreated,
      this.dateUpdated,
      this.startTime,
      this.endTime,
      this.eventId});

  String delivery_option;
  String id;
  String itemCategoryId;
  int stockAmount;
  String priceInPoints;
  String price;
  String name;
  String description;
  String imageUrl;
  String thumbnailUrl;
  String dateCreated;
  String dateUpdated;
  String startTime;
  String endTime;
  String eventId;

  UpcomingArrivals.fromJson(Map<String, dynamic> json) {
    delivery_option = json['delivery_option'];
    id = json['id'];
    itemCategoryId = json['item_category_id'];
    stockAmount = json['stock_amount'];
    priceInPoints = json['price_in_points'];
    price = json['price'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['image_url'];
    thumbnailUrl = json['thumbnail_url'];
    dateCreated = json['date_created'];
    dateUpdated = json['date_updated'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    eventId = json['event_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['delivery_option'] = delivery_option;
    _data['id'] = id;
    _data['item_category_id'] = itemCategoryId;
    _data['stock_amount'] = stockAmount;
    _data['price_in_points'] = priceInPoints;
    _data['price'] = price;
    _data['name'] = name;
    _data['description'] = description;
    _data['image_url'] = imageUrl;
    _data['date_created'] = dateCreated;
    _data['date_updated'] = dateUpdated;
    _data['start_time'] = startTime;
    _data['end_time'] = endTime;
    _data['event_id'] = eventId;
    return _data;
  }
}

class NewArrivals {
  NewArrivals(
      {this.id,
      this.itemCategoryId,
      this.stockAmount,
      this.priceInPoints,
      this.price,
      this.name,
      this.description,
      this.imageUrl,
      this.thumbnailUrl,
      this.dateCreated,
      this.dateUpdated,
      this.startTime,
      this.endTime,
      this.eventId});
  String id;
  String itemCategoryId;
  int stockAmount;
  String priceInPoints;
  String price;
  String name;
  String description;
  String imageUrl;
  String thumbnailUrl;
  String dateCreated;
  String dateUpdated;
  String startTime;
  String endTime;
  String eventId;

  NewArrivals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemCategoryId = json['item_category_id'];
    stockAmount = json['stock_amount'];
    priceInPoints = json['price_in_points'];
    price = json['price'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['image_url'];
    thumbnailUrl = json['thumbnail_url'];
    dateCreated = json['date_created'];
    dateUpdated = json['date_updated'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    eventId = json['event_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['item_category_id'] = itemCategoryId;
    _data['stock_amount'] = stockAmount;
    _data['price_in_points'] = priceInPoints;
    _data['price'] = price;
    _data['name'] = name;
    _data['description'] = description;
    _data['image_url'] = imageUrl;
    _data['date_created'] = dateCreated;
    _data['date_updated'] = dateUpdated;
    _data['start_time'] = startTime;
    _data['end_time'] = endTime;
    _data['event_id'] = eventId;
    return _data;
  }
}
