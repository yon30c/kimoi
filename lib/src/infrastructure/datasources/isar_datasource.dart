import 'package:isar/isar.dart';
import 'package:kimoi/src/domain/datasources/local_storage_datasource.dart';
import 'package:kimoi/src/domain/entities/anime.dart';
import 'package:kimoi/src/domain/entities/chapter.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasource extends LocalStorageDatasource {
  late Future<Isar> db;

  IsarDatasource() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([AnimeSchema, ChapterSchema],
          inspector: true, directory: dir.path);
    }

    return Future.value(Isar.getInstance());
  }

  @override
  Future<bool> isAnimeFavorite(String title) async {
    final isar = await db;

    final Anime? isFavoriteAnime =
        await isar.animes.filter().animeTitleEqualTo(title).findFirst();

    return isFavoriteAnime != null;
  }

  @override
  Future<List<Anime>> loadAnimes({int limit = 10, offset = 0}) async {
    final isar = await db;
    return isar.animes.where().offset(offset).limit(limit).findAll();
  }

  @override
  Future<void> toggleFavorite(Anime anime) async {
    final isar = await db;

    final favoriteAnime = await isar.animes
        .filter()
        .animeTitleEqualTo(anime.animeTitle)
        .findFirst();

    if (favoriteAnime != null) {
      // Borrar
      await isar.writeTxn(() async {
        await isar.animes.delete(favoriteAnime.id);
      });
      return;
    }

    // Insertar
    await isar.writeTxn(() async {
      await isar.animes.put(anime);
    });
  }

  @override
  Future<void> onWatching(Chapter chapter) async {
    final isar = await db;

    final isWatching =
        await isar.chapters.filter().idEqualTo(chapter.id).findFirst();

    if (isWatching != null) {
      // editar
      // chapter.isarId = isWatching.isarId;
      await isar.writeTxn(() async {
        await isar.chapters.delete(isWatching.isarId!);
        await isar.chapters.put(chapter);
      });
      return;
    }
    // Insertar
    await isar.writeTxn(() async {
      await isar.chapters.put(chapter);
    });
  }

  @override
  Future<Chapter?> loadWatchingAnime(String id) async {
    final isar = await db;

    final isWatching = await isar.chapters.filter().idEqualTo(id).findFirst();

    if (isWatching != null) {
      return isWatching;
    }
    return null;
  }

  @override
  Future<Chapter?> loadLastWatchedChapterAnime(String title) async {
    final isar = await db;
    final isWatching =
        await isar.chapters.filter().titleEqualTo(title).findAll();

    if (isWatching.isNotEmpty) {
      return isWatching.last;
    }
    return null;
  }

  @override
  Future<List<Chapter>> loadWatchedHistory({int limit = 10, offset = 0}) async {
    final isar = await db;

    final chapt = isar.chapters
        .where()
        .sortByDateDesc()
        .offset(offset)
        .limit(limit)
        .findAll();

    return chapt;
    // isar.chapters.where(sort: Sort.desc).findAll();
  }

  @override
  Future<void> clearHistory() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.chapters.clear();
    });
  }

  @override
  Future<void> removeWatchetChapter(Chapter chapter) async {
    final isar = await db;
    await isar
        .writeTxn(() async => await isar.chapters.delete(chapter.isarId!));
  }
}
