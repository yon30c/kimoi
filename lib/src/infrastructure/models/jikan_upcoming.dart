

// ignore_for_file: constant_identifier_names

import 'dart:convert';

class JikanUpcoming {
    final Pagination pagination;
    final List<UpDatum> data;

    JikanUpcoming({
        required this.pagination,
        required this.data,
    });

    factory JikanUpcoming.fromRawJson(String str) => JikanUpcoming.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory JikanUpcoming.fromJson(Map<String, dynamic> json) => JikanUpcoming(
        pagination: Pagination.fromJson(json["pagination"]),
        data: List<UpDatum>.from(json["data"].map((x) => UpDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "pagination": pagination.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class UpDatum {
    final int malId;
    final String url;
    final Map<String, Image> images;
    final Trailer trailer;
    final bool approved;
    final List<Title> titles;
    final String title;
    final String? titleEnglish;
    final String titleJapanese;
    final List<String> titleSynonyms;
    final DatumType? type;
    final Source? source;
    final int? episodes;
    final Status status;
    final bool airing;
    final Aired aired;
    final Duration? duration;
    final Rating? rating;
    final dynamic score;
    final dynamic scoredBy;
    final dynamic rank;
    final int popularity;
    final int members;
    final int favorites;
    final String? synopsis;
    final dynamic background;
    final Season? season;
    final int? year;
    final Broadcast broadcast;
    final List<Demographic> producers;
    final List<Demographic> licensors;
    final List<Demographic> studios;
    final List<Demographic> genres;
    final List<dynamic> explicitGenres;
    final List<Demographic> themes;
    final List<Demographic> demographics;

    UpDatum({
        required this.malId,
        required this.url,
        required this.images,
        required this.trailer,
        required this.approved,
        required this.titles,
        required this.title,
        required this.titleEnglish,
        required this.titleJapanese,
        required this.titleSynonyms,
        required this.type,
        required this.source,
        required this.episodes,
        required this.status,
        required this.airing,
        required this.aired,
        required this.duration,
        required this.rating,
        required this.score,
        required this.scoredBy,
        required this.rank,
        required this.popularity,
        required this.members,
        required this.favorites,
        required this.synopsis,
        required this.background,
        required this.season,
        required this.year,
        required this.broadcast,
        required this.producers,
        required this.licensors,
        required this.studios,
        required this.genres,
        required this.explicitGenres,
        required this.themes,
        required this.demographics,
    });

    factory UpDatum.fromRawJson(String str) => UpDatum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UpDatum.fromJson(Map<String, dynamic> json) => UpDatum(
        malId: json["mal_id"],
        url: json["url"],
        images: Map.from(json["images"]).map((k, v) => MapEntry<String, Image>(k, Image.fromJson(v))),
        trailer: Trailer.fromJson(json["trailer"]),
        approved: json["approved"],
        titles: List<Title>.from(json["titles"].map((x) => Title.fromJson(x))),
        title: json["title"],
        titleEnglish: json["title_english"],
        titleJapanese: json["title_japanese"] ?? '',
        titleSynonyms: List<String>.from(json["title_synonyms"].map((x) => x)),
        type: json["type"] != null ? datumTypeValues.map[json["type"]] : null,
        source: sourceValues.map[json["source"]],
        episodes: json["episodes"],
        status: statusValues.map[json["status"]]!,
        airing: json["airing"],
        aired: Aired.fromJson(json["aired"]),
        duration: json["duration"] != null ? durationValues.map[json["duration"]] : null,
        rating: json["rating"] != null ? ratingValues.map[json["rating"]] : null,
        score: json["score"],
        scoredBy: json["scored_by"],
        rank: json["rank"],
        popularity: json["popularity"],
        members: json["members"],
        favorites: json["favorites"],
        synopsis: json["synopsis"],
        background: json["background"],
        season: json["season"] != null ? seasonValues.map[json["season"]] : null,
        year: json["year"],
        broadcast: Broadcast.fromJson(json["broadcast"]),
        producers: List<Demographic>.from(json["producers"].map((x) => Demographic.fromJson(x))),
        licensors: List<Demographic>.from(json["licensors"].map((x) => Demographic.fromJson(x))),
        studios: List<Demographic>.from(json["studios"].map((x) => Demographic.fromJson(x))),
        genres: List<Demographic>.from(json["genres"].map((x) => Demographic.fromJson(x))),
        explicitGenres: List<dynamic>.from(json["explicit_genres"].map((x) => x)),
        themes: List<Demographic>.from(json["themes"].map((x) => Demographic.fromJson(x))),
        demographics: List<Demographic>.from(json["demographics"].map((x) => Demographic.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "mal_id": malId,
        "url": url,
        "images": Map.from(images).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "trailer": trailer.toJson(),
        "approved": approved,
        "titles": List<dynamic>.from(titles.map((x) => x.toJson())),
        "title": title,
        "title_english": titleEnglish,
        "title_japanese": titleJapanese,
        "title_synonyms": List<dynamic>.from(titleSynonyms.map((x) => x)),
        "type": datumTypeValues.reverse[type],
        "source": sourceValues.reverse[source],
        "episodes": episodes,
        "status": statusValues.reverse[status],
        "airing": airing,
        "aired": aired.toJson(),
        "duration": durationValues.reverse[duration],
        "rating": ratingValues.reverse[rating],
        "score": score,
        "scored_by": scoredBy,
        "rank": rank,
        "popularity": popularity,
        "members": members,
        "favorites": favorites,
        "synopsis": synopsis,
        "background": background,
        "season": seasonValues.reverse[season],
        "year": year,
        "broadcast": broadcast.toJson(),
        "producers": List<dynamic>.from(producers.map((x) => x.toJson())),
        "licensors": List<dynamic>.from(licensors.map((x) => x.toJson())),
        "studios": List<dynamic>.from(studios.map((x) => x.toJson())),
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
        "explicit_genres": List<dynamic>.from(explicitGenres.map((x) => x)),
        "themes": List<dynamic>.from(themes.map((x) => x.toJson())),
        "demographics": List<dynamic>.from(demographics.map((x) => x.toJson())),
    };
}

class Aired {
    final DateTime? from;
    final dynamic to;
    final Prop prop;
    final String string;

    Aired({
        required this.from,
        required this.to,
        required this.prop,
        required this.string,
    });

    factory Aired.fromRawJson(String str) => Aired.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Aired.fromJson(Map<String, dynamic> json) => Aired(
        from: json["from"] == null ? null : DateTime.parse(json["from"]),
        to: json["to"],
        prop: Prop.fromJson(json["prop"]),
        string: json["string"],
    );

    Map<String, dynamic> toJson() => {
        "from": from?.toIso8601String(),
        "to": to,
        "prop": prop.toJson(),
        "string": string,
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
    final String? day;
    final String? time;
    final String? timezone;
    final String? string;

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

class Demographic {
    final int malId;
    final DemographicType type;
    final String name;
    final String url;

    Demographic({
        required this.malId,
        required this.type,
        required this.name,
        required this.url,
    });

    factory Demographic.fromRawJson(String str) => Demographic.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Demographic.fromJson(Map<String, dynamic> json) => Demographic(
        malId: json["mal_id"],
        type: demographicTypeValues.map[json["type"]]!,
        name: json["name"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "mal_id": malId,
        "type": demographicTypeValues.reverse[type],
        "name": name,
        "url": url,
    };
}

enum DemographicType {
    ANIME
}

final demographicTypeValues = EnumValues({
    "anime": DemographicType.ANIME
});

enum Duration {
    THE_23_MIN,
    UNKNOWN
}

final durationValues = EnumValues({
    "23 min": Duration.THE_23_MIN,
    "Unknown": Duration.UNKNOWN
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

enum Rating {
    PG_13_TEENS_13_OR_OLDER,
    R_17_VIOLENCE_PROFANITY
}

final ratingValues = EnumValues({
    "PG-13 - Teens 13 or older": Rating.PG_13_TEENS_13_OR_OLDER,
    "R - 17+ (violence & profanity)": Rating.R_17_VIOLENCE_PROFANITY
});

enum Season {
    FALL,
    SPRING,
    WINTER
}

final seasonValues = EnumValues({
    "fall": Season.FALL,
    "spring": Season.SPRING,
    "winter": Season.WINTER
});

enum Source {
    LIGHT_NOVEL,
    MANGA,
    ORIGINAL,
    WEB_MANGA
}

final sourceValues = EnumValues({
    "Light novel": Source.LIGHT_NOVEL,
    "Manga": Source.MANGA,
    "Original": Source.ORIGINAL,
    "Web manga": Source.WEB_MANGA
});

enum Status {
    NOT_YET_AIRED
}

final statusValues = EnumValues({
    "Not yet aired": Status.NOT_YET_AIRED
});

class Title {
    final TitleType type;
    final String title;

    Title({
        required this.type,
        required this.title,
    });

    factory Title.fromRawJson(String str) => Title.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Title.fromJson(Map<String, dynamic> json) => Title(
        type: titleTypeValues.map[json["type"]]!,
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "type": titleTypeValues.reverse[type],
        "title": title,
    };
}

enum TitleType {
    DEFAULT,
    ENGLISH,
    JAPANESE,
    SYNONYM
}

final titleTypeValues = EnumValues({
    "Default": TitleType.DEFAULT,
    "English": TitleType.ENGLISH,
    "Japanese": TitleType.JAPANESE,
    "Synonym": TitleType.SYNONYM
});

class Trailer {
    final String? youtubeId;
    final String? url;
    final String? embedUrl;
    final Images images;

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
        "images": images.toJson(),
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

enum DatumType {
    MOVIE,
    TV
}

final datumTypeValues = EnumValues({
    "Movie": DatumType.MOVIE,
    "TV": DatumType.TV
});

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
