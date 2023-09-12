
class XData {
  final int malId;
  final String url;
  final String imageUrl;
  final String smallImageUrl;
  final String largeImageUrl;
  final String? trailer;
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
  final String studios;
  final List<String> genres;

  XData({
    required this.malId,
    required this.imageUrl,
    required this.largeImageUrl,
    required this.smallImageUrl,
    required this.url,
    required this.trailer,
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
}
