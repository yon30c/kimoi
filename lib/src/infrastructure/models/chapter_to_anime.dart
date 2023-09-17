import 'package:kimoi/src/domain/domain.dart';

Anime chapterToAnime(Chapter chapter) => Anime(
    animeUrl: chapter.animeUrl!,
    imageUrl: chapter.imageUrl!,
    animeTitle: chapter.title,
    chapterInfo: chapter.chapter,
    chapterUrl: chapter.chapterUrl,
    release: '',
    type: '');
