class Orders {
  Orders({
    this.done,
    this.body,
    this.message,
  });
  bool done;
  List<BodyOFOrders> body;
  String message;

  Orders.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body =
        List.from(json['body']).map((e) => BodyOFOrders.fromJson(e)).toList();
    message = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['done'] = done;
    _data['friends'] = body.map((e) => e.toJson()).toList();
    _data['message'] = message;
    return _data;
  }
}

class BodyOFOrders {
  BodyOFOrders({
    this.id,
    this.itemId,
    this.playerId,
    this.pointsPaid,
    this.cashPaid,
    this.status,
    this.qty,
    this.item,
  });
  String id;
  String itemId;
  String playerId;
  int pointsPaid;
  int cashPaid;
  String status;
  int qty;
  Item item;

  BodyOFOrders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    playerId = json['player_id'];
    pointsPaid = json['points_paid'];
    cashPaid = json['cash_paid'];
    status = json['status'];
    qty = json['qty'];
    item = Item.fromJson(json['item']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['item_id'] = itemId;
    _data['player_id'] = playerId;
    _data['points_paid'] = pointsPaid;
    _data['cash_paid'] = cashPaid;
    _data['status'] = status;
    _data['qty'] = qty;
    _data['item'] = item.toJson();
    return _data;
  }
}

class Item {
  Item({
    this.id,
    this.stockAmount,
    this.priceInPoints,
    this.price,
    this.name,
    this.imageUrl,
    this.itemCategoryId,
    this.description,
  });
  String id;
  int stockAmount;
  int priceInPoints;
  int price;
  String name;
  String imageUrl;
  String itemCategoryId;
  String description;

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stockAmount = json['stock_amount'];
    priceInPoints = json['price_in_points'];
    price = json['price'];
    name = json['name'];
    imageUrl = json['image_url'];
    itemCategoryId = json['item_category_id'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['stock_amount'] = stockAmount;
    _data['price_in_points'] = priceInPoints;
    _data['price'] = price;
    _data['name'] = name;
    _data['image_url'] = imageUrl;
    _data['item_category_id'] = itemCategoryId;
    _data['description'] = description;
    return _data;
  }
}
