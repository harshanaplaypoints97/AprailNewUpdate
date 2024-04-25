
import 'dart:convert';

MyPosts myPostsFromJson(String str) => MyPosts.fromJson(json.decode(str));

String myPostsToJson(MyPosts data) => json.encode(data.toJson());

class MyPosts {
    MyPosts({
        this.done,
        this.body,
        this.message,
    });

    bool done;
    Body body;
    dynamic message;

    factory MyPosts.fromJson(Map<String, dynamic> json) => MyPosts(
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
        this.posts,
    });

    int count;
    List<Post> posts;

    factory Body.fromJson(Map<String, dynamic> json) => Body(
        count: json["count"],
        posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "posts": List<dynamic>.from(posts.map((x) => x.toJson())),
    };
}

class Post {
    Post({
        this.playerName,
        this.playerImage,
        this.postComments,
        this.postLikes,
        this.playerId,
        this.mediaUrl,
        this.mediaType,
        this.id,
        this.dateCreated,
        this.dateUpdated,
        this.description,
    });

    String playerName;
    String playerImage;
    List<PostComment> postComments;
    List<PostLike> postLikes;
    String playerId;
    dynamic mediaUrl;
    String mediaType;
    String id;
    DateTime dateCreated;
    DateTime dateUpdated;
    String description;

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        playerName: json["player_name"]??"",
        playerImage: json["player_image"]??"",
        postComments: List<PostComment>.from(json["post_comments"].map((x) => PostComment.fromJson(x))),
        postLikes: List<PostLike>.from(json["post_likes"].map((x) => PostLike.fromJson(x))),
        playerId: json["player_id"]??"",
        mediaUrl: json["media_url"]??"",
        mediaType: json["media_type"]??"",
        id: json["id"]??"",
        dateCreated: DateTime.parse(json["date_created"]??""),
        dateUpdated: DateTime.parse(json["date_updated"]??""),
        description: json["description"]??"",
    );

    Map<String, dynamic> toJson() => {
        "player_name": playerName,
        "player_image": playerImage,
        "post_comments": List<dynamic>.from(postComments.map((x) => x.toJson())),
        "post_likes": List<dynamic>.from(postLikes.map((x) => x.toJson())),
        "player_id": playerId,
        "media_url": mediaUrl,
        "media_type": mediaType,
        "id": id,
        "date_created": dateCreated.toIso8601String(),
        "date_updated": dateUpdated.toIso8601String(),
        "description": description,
    };
}

class PostComment {
    PostComment({
        this.id,
        this.playerId,
        this.postId,
        this.commentId,
        this.comment,
        this.dateCreated,
        this.playerName,
        this.playerImage,
        this.likes,
    });

    String id;
    String playerId;
    String postId;
    dynamic commentId;
    String comment;
    DateTime dateCreated;
    String playerName;
    String playerImage;
    List<dynamic> likes;

    factory PostComment.fromJson(Map<String, dynamic> json) => PostComment(
        id: json["id"]??"",
        playerId: json["player_id"]??"",
        postId: json["post_id"]??"",
        commentId: json["comment_id"]??"",
        comment: json["comment"]??"",
        dateCreated: DateTime.parse(json["date_created"]??""),
        playerName: json["player_name"]??"",
        playerImage: json["player_image"??""],
        likes: List<dynamic>.from(json["likes"].map((x) => x)??""),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "player_id": playerId,
        "post_id": postId,
        "comment_id": commentId,
        "comment": comment,
        "date_created": dateCreated.toIso8601String(),
        "player_name": playerName,
        "player_image": playerImage,
        "likes": List<dynamic>.from(likes.map((x) => x)),
    };
}

class PostLike {
    PostLike({
        this.id,
        this.playerId,
        this.postId,
        this.dateCreated,
    });

    String id;
    String playerId;
    String postId;
    DateTime dateCreated;

    factory PostLike.fromJson(Map<String, dynamic> json) => PostLike(
        id: json["id"],
        playerId: json["player_id"],
        postId: json["post_id"],
        dateCreated: DateTime.parse(json["date_created"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "player_id": playerId,
        "post_id": postId,
        "date_created": dateCreated.toIso8601String(),
    };
}

