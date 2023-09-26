

import 'dart:convert';

class JikanRecomendations {
    final Pagination pagination;
    final List<Datum> data;

    JikanRecomendations({
        required this.pagination,
        required this.data,
    });

    factory JikanRecomendations.fromRawJson(String str) => JikanRecomendations.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory JikanRecomendations.fromJson(Map<String, dynamic> json) => JikanRecomendations(
        pagination: Pagination.fromJson(json["pagination"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "pagination": pagination.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    final String malId;
    final List<Entry> entry;
    final String content;
    final DateTime date;
    final User user;

    Datum({
        required this.malId,
        required this.entry,
        required this.content,
        required this.date,
        required this.user,
    });

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        malId: json["mal_id"],
        entry: List<Entry>.from(json["entry"].map((x) => Entry.fromJson(x))),
        content: json["content"],
        date: DateTime.parse(json["date"]),
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "mal_id": malId,
        "entry": List<dynamic>.from(entry.map((x) => x.toJson())),
        "content": content,
        "date": date.toIso8601String(),
        "user": user.toJson(),
    };
}

class Entry {
    final int malId;
    final String url;
    final Map<String, Image> images;
    final String title;

    Entry({
        required this.malId,
        required this.url,
        required this.images,
        required this.title,
    });

    factory Entry.fromRawJson(String str) => Entry.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Entry.fromJson(Map<String, dynamic> json) => Entry(
        malId: json["mal_id"],
        url: json["url"],
        images: Map.from(json["images"]).map((k, v) => MapEntry<String, Image>(k, Image.fromJson(v))),
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "mal_id": malId,
        "url": url,
        "images": Map.from(images).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "title": title,
    };
}

class Image {
    final String imageUrl;
    final String smallImageUrl;
    final String largeImageUrl;

    Image({
        required this.imageUrl,
        required this.smallImageUrl,
        required this.largeImageUrl,
    });

    factory Image.fromRawJson(String str) => Image.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Image.fromJson(Map<String, dynamic> json) => Image(
        imageUrl: json["image_url"],
        smallImageUrl: json["small_image_url"],
        largeImageUrl: json["large_image_url"],
    );

    Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
        "small_image_url": smallImageUrl,
        "large_image_url": largeImageUrl,
    };
}

class User {
    final String url;
    final String username;

    User({
        required this.url,
        required this.username,
    });

    factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory User.fromJson(Map<String, dynamic> json) => User(
        url: json["url"],
        username: json["username"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "username": username,
    };
}

class Pagination {
    final int lastVisiblePage;
    final bool hasNextPage;

    Pagination({
        required this.lastVisiblePage,
        required this.hasNextPage,
    });

    factory Pagination.fromRawJson(String str) => Pagination.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        lastVisiblePage: json["last_visible_page"],
        hasNextPage: json["has_next_page"],
    );

    Map<String, dynamic> toJson() => {
        "last_visible_page": lastVisiblePage,
        "has_next_page": hasNextPage,
    };
}
