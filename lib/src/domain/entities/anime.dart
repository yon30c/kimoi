import 'package:isar/isar.dart';

part 'anime.g.dart';

@collection
class Anime {
  Id id = Isar.autoIncrement;
  final String animeTitle;
  final String animeUrl;
  final String imageUrl;
  String? chapterUrl;
  final String? chapterInfo;
  final String? type;
  final String? release;

  Anime({
    this.type,
    this.release,
    this.chapterUrl,
    this.chapterInfo,
    required this.animeUrl,
    required this.imageUrl,
    required this.animeTitle,
  });
}
