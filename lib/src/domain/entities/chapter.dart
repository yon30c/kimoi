import 'package:isar/isar.dart';

part 'chapter.g.dart';

@collection
class Chapter {
  Id? isarId = Isar.autoIncrement;
  final String id;
  final String title;
  String? animeUrl;
  String? imageUrl;
  List<String> servers;
  String chapterInfo;
  final String chapter;
  final int chapterNumber;
  final String chapterUrl;
  bool isCompleted;
  bool isWatching;
  int position;
  int duration;

  Chapter(
      {required this.title,
      required this.id,
      this.duration = 0,
      this.animeUrl,
      this.isarId,
      this.imageUrl,
      required this.chapterUrl,
      this.position = 0,
      this.isCompleted = false,
      this.isWatching = false,
      required this.chapterNumber,
      required this.servers,
      required this.chapterInfo,
      required this.chapter});
}
