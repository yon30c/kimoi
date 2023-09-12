// ignore_for_file: constant_identifier_names

import 'dart:convert';

class JikanResponse {
    final Pagination pagination;
    final List<Datum> data;

    JikanResponse({
        required this.pagination,
        required this.data,
    });

    factory JikanResponse.fromRawJson(String str) => JikanResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory JikanResponse.fromJson(Map<String, dynamic> json) => JikanResponse(
        pagination: Pagination.fromJson(json["pagination"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "pagination": pagination.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    final int malId;
    final String url;
    final Map<String, Image> images;
    final Trailer? trailer;
    final List<Title> titles;
    final String title;
    final String? type;
    final String source;
    final int? episodes;
    final String status;
    final bool airing;
    final String duration;
    final String? rating;
    final double? score;
    final int? rank;
    final int popularity;
    final int favorites;
    final String? synopsis;
    final String? season;
    final int? year;
    final List<Genre> studios;
    final List<Genre> genres;

    Datum({
        required this.malId,
        required this.url,
        required this.images,
        required this.trailer,
        required this.titles,
        required this.title,
        required this.type,
        required this.source,
        required this.episodes,
        required this.status,
        required this.airing,
        required this.duration,
        required this.rating,
        required this.score,
        required this.rank,
        required this.popularity,
        required this.favorites,
        required this.synopsis,
        required this.season,
        required this.year,
        required this.studios,
        required this.genres,
    });

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        malId: json["mal_id"],
        url: json["url"],
        images: Map.from(json["images"]).map((k, v) => MapEntry<String, Image>(k, Image.fromJson(v))),
        trailer: Trailer.fromJson(json["trailer"]),
        titles: List<Title>.from(json["titles"].map((x) => Title.fromJson(x))),
        title: json["title"],
        type: json["type"],
        source: json["source"],
        episodes: json["episodes"],
        status: json["status"],
        airing: json["airing"],
        duration: json["duration"],
        rating: json["rating"],
        score: json["score"]?.toDouble(),
        rank: json["rank"],
        popularity: json["popularity"],
        favorites: json["favorites"],
        synopsis: json["synopsis"],
        season: json["season"],
        year: json["year"],
        studios: List<Genre>.from(json["studios"].map((x) => Genre.fromJson(x))),
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "mal_id": malId,
        "url": url,
        "images": Map.from(images).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "trailer": trailer?.toJson(),
        "titles": List<dynamic>.from(titles.map((x) => x.toJson())),
        "title": title,
        "type": type,
        "source": source,
        "episodes": episodes,
        "status": status,
        "airing": airing,
        "duration": duration,
        "rating": rating,
        "score": score,
        "rank": rank,
        "popularity": popularity,
        "favorites": favorites,
        "synopsis": synopsis,
        "season": season,
        "year": year,
        "studios": List<dynamic>.from(studios.map((x) => x.toJson())),
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
    };
}



class Prop {
    final From from;
    final From to;

    Prop({
        required this.from,
        required this.to,
    });

    factory Prop.fromRawJson(String str) => Prop.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Prop.fromJson(Map<String, dynamic> json) => Prop(
        from: From.fromJson(json["from"]),
        to: From.fromJson(json["to"]),
    );

    Map<String, dynamic> toJson() => {
        "from": from.toJson(),
        "to": to.toJson(),
    };
}

class From {
    final int? day;
    final int? month;
    final int? year;

    From({
        required this.day,
        required this.month,
        required this.year,
    });

    factory From.fromRawJson(String str) => From.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory From.fromJson(Map<String, dynamic> json) => From(
        day: json["day"],
        month: json["month"],
        year: json["year"],
    );

    Map<String, dynamic> toJson() => {
        "day": day,
        "month": month,
        "year": year,
    };
}

class Broadcast {
    final String day;
    final String time;
    final String timezone;
    final String string;

    Broadcast({
        required this.day,
        required this.time,
        required this.timezone,
        required this.string,
    });

    factory Broadcast.fromRawJson(String str) => Broadcast.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Broadcast.fromJson(Map<String, dynamic> json) => Broadcast(
        day: json["day"],
        time: json["time"],
        timezone: json["timezone"],
        string: json["string"],
    );

    Map<String, dynamic> toJson() => {
        "day": day,
        "time": time,
        "timezone": timezone,
        "string": string,
    };
}

class Genre {
    final int malId;
    final Type type;
    final String name;
    final String url;

    Genre({
        required this.malId,
        required this.type,
        required this.name,
        required this.url,
    });

    factory Genre.fromRawJson(String str) => Genre.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        malId: json["mal_id"],
        type: typeValues.map[json["type"]]!,
        name: json["name"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "mal_id": malId,
        "type": typeValues.reverse[type],
        "name": name,
        "url": url,
    };
}

enum Type {
    ANIME
}

final typeValues = EnumValues({
    "anime": Type.ANIME
});

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

class Title {
    final String type;
    final String title;

    Title({
        required this.type,
        required this.title,
    });

    factory Title.fromRawJson(String str) => Title.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Title.fromJson(Map<String, dynamic> json) => Title(
        type: json["type"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "title": title,
    };
}

class Trailer {
    final String? youtubeId;
    final String? url;
    final String? embedUrl;
    final Images? images;

    Trailer({
        required this.youtubeId,
        required this.url,
        required this.embedUrl,
        required this.images,
    });

    factory Trailer.fromRawJson(String str) => Trailer.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Trailer.fromJson(Map<String, dynamic> json) => Trailer(
        youtubeId: json["youtube_id"],
        url: json["url"],
        embedUrl: json["embed_url"],
        images: Images.fromJson(json["images"]),
    );

    Map<String, dynamic> toJson() => {
        "youtube_id": youtubeId,
        "url": url,
        "embed_url": embedUrl,
        "images": images?.toJson(),
    };
}

class Images {
    final String? imageUrl;
    final String? smallImageUrl;
    final String? mediumImageUrl;
    final String? largeImageUrl;
    final String? maximumImageUrl;

    Images({
        required this.imageUrl,
        required this.smallImageUrl,
        required this.mediumImageUrl,
        required this.largeImageUrl,
        required this.maximumImageUrl,
    });

    factory Images.fromRawJson(String str) => Images.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Images.fromJson(Map<String, dynamic> json) => Images(
        imageUrl: json["image_url"],
        smallImageUrl: json["small_image_url"],
        mediumImageUrl: json["medium_image_url"],
        largeImageUrl: json["large_image_url"],
        maximumImageUrl: json["maximum_image_url"],
    );

    Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
        "small_image_url": smallImageUrl,
        "medium_image_url": mediumImageUrl,
        "large_image_url": largeImageUrl,
        "maximum_image_url": maximumImageUrl,
    };
}

class Pagination {
    final int lastVisiblePage;
    final bool hasNextPage;
    final int currentPage;
    final Items items;

    Pagination({
        required this.lastVisiblePage,
        required this.hasNextPage,
        required this.currentPage,
        required this.items,
    });

    factory Pagination.fromRawJson(String str) => Pagination.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        lastVisiblePage: json["last_visible_page"],
        hasNextPage: json["has_next_page"],
        currentPage: json["current_page"],
        items: Items.fromJson(json["items"]),
    );

    Map<String, dynamic> toJson() => {
        "last_visible_page": lastVisiblePage,
        "has_next_page": hasNextPage,
        "current_page": currentPage,
        "items": items.toJson(),
    };
}

class Items {
    final int count;
    final int total;
    final int perPage;

    Items({
        required this.count,
        required this.total,
        required this.perPage,
    });

    factory Items.fromRawJson(String str) => Items.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Items.fromJson(Map<String, dynamic> json) => Items(
        count: json["count"],
        total: json["total"],
        perPage: json["per_page"],
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "total": total,
        "per_page": perPage,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
