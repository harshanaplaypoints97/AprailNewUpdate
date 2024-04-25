

import 'dart:convert';

ResentWinners resentWinnersFromJson(String str) => ResentWinners.fromJson(json.decode(str));

String resentWinnersToJson(ResentWinners data) => json.encode(data.toJson());

class ResentWinners {
    ResentWinners({
        this.done,
        this.body,
        this.message,
    });

    bool done;
    Body body;
    dynamic message;

    factory ResentWinners.fromJson(Map<String, dynamic> json) => ResentWinners(
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
    Body({
        this.count,
        this.orders,
    });

    int count;
    List<Order> orders;

    factory Body.fromJson(Map<String, dynamic> json) => Body(
        count: json["count"],
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
    };
}

class Order {
    Order({
        this.id,
        this.itemId,
        this.playerId,
        this.pointsPaid,
        this.cashPaid,
        this.phoneNo,
        this.address,
        this.qty,
        this.item,
        this.player,
    });

    String id;
    String itemId;
    String playerId;
    int pointsPaid;
    int cashPaid;
    String phoneNo;
    String address;
    int qty;
    Item item;
    Player player;

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        itemId: json["item_id"],
        playerId: json["player_id"],
        pointsPaid: json["points_paid"],
        cashPaid: json["cash_paid"],
        phoneNo: json["phone_no"],
        address: json["address"],
        qty: json["qty"],
        item: Item.fromJson(json["item"]),
        player: Player.fromJson(json["player"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "item_id": itemId,
        "player_id": playerId,
        "points_paid": pointsPaid,
        "cash_paid": cashPaid,
        "phone_no": phoneNo,
        "address": address,
        "qty": qty,
        "item": item.toJson(),
        "player": player.toJson(),
    };
}

class Item {
    Item({
        this.id,
        this.name,
        this.imageUrl,
    });

    String id;
    String name;
    String imageUrl;

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        name: json["name"],
        imageUrl: json["image_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_url": imageUrl,
    };
}

class Player {
    Player({
        this.id,
        this.username,
        this.email,
        this.fullName,
        this.profileImage,
        this.coverImage,
    });

    String id;
    String username;
    String email;
    String fullName;
    String profileImage;
    dynamic coverImage;

    factory Player.fromJson(Map<String, dynamic> json) => Player(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        fullName: json["full_name"],
        profileImage: json["profile_image"],
        coverImage: json["cover_image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "full_name": fullName,
        "profile_image": profileImage,
        "cover_image": coverImage,
    };
}
