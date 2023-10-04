

import 'package:isar/isar.dart';

part 'searched_anime.g.dart';

@collection
class SearchedAnime {
  Id id = Isar.autoIncrement;
  final String animeTitle;
  final String animeUrl;
  final String imageUrl;
  String? chapterUrl;
  final String? chapterInfo;
  final String? type;
  final String? release;
  DateTime? date;

  SearchedAnime({
    this.type,
    this.release,
    this.date,
    this.chapterUrl,
    this.chapterInfo,
    required this.animeUrl,
    required this.imageUrl,
    required this.animeTitle,
  });
}
