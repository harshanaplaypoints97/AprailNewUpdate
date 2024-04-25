// To parse this JSON data, do
//
//     final storyCreateModel = storyCreateModelFromJson(jsonString);

import 'dart:convert';

StoryCreateModel storyCreateModelFromJson(String str) => StoryCreateModel.fromJson(json.decode(str));

String storyCreateModelToJson(StoryCreateModel data) => json.encode(data.toJson());

class StoryCreateModel {
    bool done;
    Body body;
    dynamic message;

    StoryCreateModel({
        this.done,
        this.body,
        this.message,
    });

    factory StoryCreateModel.fromJson(Map<String, dynamic> json) => StoryCreateModel(
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
    CreatePlayerStories createPlayerStories;

    Body({
        this.createPlayerStories,
    });

    factory Body.fromJson(Map<String, dynamic> json) => Body(
        createPlayerStories: CreatePlayerStories.fromJson(json["create_player_stories"]),
    );

    Map<String, dynamic> toJson() => {
        "create_player_stories": createPlayerStories.toJson(),
    };
}

class CreatePlayerStories {
    String id;

    CreatePlayerStories({
        this.id,
    });

    factory CreatePlayerStories.fromJson(Map<String, dynamic> json) => CreatePlayerStories(
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
    };
}
