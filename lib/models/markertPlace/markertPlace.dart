class MarkertPlaceItem {
  MarkertPlaceItem({
    this.done,
    this.body,
    this.message,
  });

  bool done;
  Body body;
  String message;

  MarkertPlaceItem.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'done': done,
      'message': message,
    };
    if (body != null) {
      data['body'] = body.toJson();
    }
    return data;
  }
}

class Body {
  CreatePlayerMarketplaceItem createPlayerMarketplaceItem;

  Body({
    this.createPlayerMarketplaceItem,
  });

  Body.fromJson(Map<String, dynamic> json) {
    createPlayerMarketplaceItem = json['create_player_marketplace_item'] != null
        ? CreatePlayerMarketplaceItem.fromJson(
            json['create_player_marketplace_item'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (createPlayerMarketplaceItem != null) {
      data['create_player_marketplace_item'] =
          createPlayerMarketplaceItem.toJson();
    }
    return data;
  }
}

class CreatePlayerMarketplaceItem {
  String id;

  CreatePlayerMarketplaceItem({
    this.id,
  });

  CreatePlayerMarketplaceItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
    };
    return data;
  }
}
