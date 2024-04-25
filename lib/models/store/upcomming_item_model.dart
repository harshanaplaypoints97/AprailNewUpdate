import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UpCommingItem {
  final String delivery_option;
  final String id;
  final String type;
  final String itemCategoryId;
  final String imageUrl;
  final int stockAmount;
  final String priceInPoints;
  final String price;
  final String name;
  final String description;
  final String dateCreated;
  final String dateUpdated;
  final String startTime;
  String serverTime;
  final String endTime;
  final String eventId;
  final int itemQuantity;
  final String thumnailUrl;
  final String waiting_start_time;
  final String waiting_end_time;
  UpCommingItem({
    this.delivery_option,
    this.id,
    this.type,
    this.itemCategoryId,
    this.imageUrl,
    this.stockAmount,
    this.priceInPoints,
    this.price,
    this.name,
    this.description,
    this.dateCreated,
    this.dateUpdated,
    this.startTime,
    this.serverTime,
    this.endTime,
    this.eventId,
    this.itemQuantity,
    this.thumnailUrl,
    this.waiting_start_time,
    this.waiting_end_time,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'delivery_option': delivery_option,
      'id': id,
      'type': type,
      'itemCategoryId': itemCategoryId,
      'stockAmount': stockAmount,
      'priceInPoints': priceInPoints,
      'price': price,
      'name': name,
      'description': description,
      'dateCreated': dateCreated,
      'dateUpdated': dateUpdated,
      'startTime': startTime,
      'server_time': serverTime,
      'endTime': endTime,
      'eventId': eventId,
      'itemQuantity': itemQuantity,
    };
  }

  factory UpCommingItem.fromMap(Map<String, dynamic> map) {
    return UpCommingItem(
      delivery_option:
          map['delivery_option'] == null ? "" : map["delivery_option"],
      id: map['id'] == null ? "" : map["id"],
      type: map['type'] == null ? "" : map["type"],
      itemCategoryId:
          map['item_category_id'] == null ? "" : map["item_category_id"],
      stockAmount: map['stock_amount'] == null ? 0 : map["stock_amount"],
      priceInPoints:
          map['price_in_points'] == null ? "" : map["price_in_points"],
      price: map['price'] == null ? "0.0" : map["price"],
      name: map['name'] == null ? "" : map["name"],
      description: map['description'] == null ? "" : map["description"],
      dateCreated: map['date_created'] == null ? "" : map["date_created"],
      dateUpdated: map['date_updated'] == null ? "" : map["date_updated"],
      startTime: map['start_time'] == null ? "" : map["start_time"],
      serverTime: map['server_time'] == null ? "" : map["server_time"],
      endTime: map['end_time'] == null ? "" : map["end_time"],
      eventId: map['event_id'] == null ? "" : map["event_id"],
      itemQuantity: map['item_quantity'] == null ? 0 : map["item_quantity"],
      imageUrl: map["image_url"] == null ? "" : map["image_url"],
      thumnailUrl: map["thumbnail_url"] == null ? null : map["thumbnail_url"],
      waiting_start_time:
          map["waiting_start_time"] == null ? "" : map["waiting_start_time"],
      waiting_end_time:
          map["waiting_end_time"] == null ? "" : map["waiting_end_time"],
    );
  }

  String toJson() => json.encode(toMap());

  factory UpCommingItem.fromJson(String source) =>
      UpCommingItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
