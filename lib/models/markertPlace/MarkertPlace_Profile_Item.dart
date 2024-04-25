// To parse this JSON data, do
//
//     final markertPlaceAllItem = markertPlaceAllItemFromJson(jsonString);

import 'dart:convert';

MarkertPlaceAllItem markertPlaceAllItemFromJson(String str) => MarkertPlaceAllItem.fromJson(json.decode(str));

String markertPlaceAllItemToJson(MarkertPlaceAllItem data) => json.encode(data.toJson());

class MarkertPlaceAllItem {
    bool done;
    Body body;
    dynamic message;

    MarkertPlaceAllItem({
        this.done,
        this.body,
        this.message,
    });

    factory MarkertPlaceAllItem.fromJson(Map<String, dynamic> json) => MarkertPlaceAllItem(
        done: json["done"],
        body: Body.fromJson(json["body"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "done": done,
        "body": body.toJson(),
        "message": message,
    };
}

class Body {
    int count;
    List<MarketplaceItem> marketplaceItems;

    Body({
        this.count,
        this.marketplaceItems,
    });

    factory Body.fromJson(Map<String, dynamic> json) => Body(
        count: json["count"],
        marketplaceItems: List<MarketplaceItem>.from(json["marketplace_items"].map((x) => MarketplaceItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "marketplace_items": List<dynamic>.from(marketplaceItems.map((x) => x.toJson())),
    };
}

class MarketplaceItem {
    String id;
    String playerId;
    String itemName;
    String itemDesc;
    String itemCategory;
    int itemPrice;
    DateTime dateCreated;
    DateTime dateUpdated;
    String playerUsername;
    String playerFullName;
    dynamic playerProfileImage;
    List<MarketplaceMedia> marketplaceMedia;

    MarketplaceItem({
        this.id,
        this.playerId,
        this.itemName,
        this.itemDesc,
        this.itemCategory,
        this.itemPrice,
        this.dateCreated,
        this.dateUpdated,
        this.playerUsername,
        this.playerFullName,
        this.playerProfileImage,
        this.marketplaceMedia,
    });

    factory MarketplaceItem.fromJson(Map<String, dynamic> json) => MarketplaceItem(
        id: json["id"],
        playerId: json["player_id"],
        itemName: json["item_name"],
        itemDesc: json["item_desc"],
        itemCategory: json["item_category"],
        itemPrice: json["item_price"],
        dateCreated: DateTime.parse(json["date_created"]),
        dateUpdated: DateTime.parse(json["date_updated"]),
        playerUsername: json["player_username"],
        playerFullName: json["player_full_name"],
        playerProfileImage: json["player_profile_image"],
        marketplaceMedia: List<MarketplaceMedia>.from(json["marketplace_media"].map((x) => MarketplaceMedia.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "player_id": playerId,
        "item_name": itemName,
        "item_desc": itemDesc,
        "item_category": itemCategory,
        "item_price": itemPrice,
        "date_created": dateCreated.toIso8601String(),
        "date_updated": dateUpdated.toIso8601String(),
        "player_username": playerUsername,
        "player_full_name": playerFullName,
        "player_profile_image": playerProfileImage,
        "marketplace_media": List<dynamic>.from(marketplaceMedia.map((x) => x.toJson())),
    };
}

class MarketplaceMedia {
    String id;
    String marketplaceItemId;
    String imageUrl;

    MarketplaceMedia({
        this.id,
        this.marketplaceItemId,
        this.imageUrl,
    });

    factory MarketplaceMedia.fromJson(Map<String, dynamic> json) => MarketplaceMedia(
        id: json["id"],
        marketplaceItemId: json["marketplace_item_id"],
        imageUrl: json["image_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "marketplace_item_id": marketplaceItemId,
        "image_url": imageUrl,
    };
}
