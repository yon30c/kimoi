import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimoi/src/infrastructure/models/extra_data.dart';

import '../../../domain/domain.dart';
import 'anime_repository_provider.dart';

final animeProvider = StateProvider<Anime?>((ref) => null);
final animeInfProvider = StateProvider<AnimeInfo?>((ref) => null);
final extraDataProvider = StateProvider<XData?>((ref) => null);




// Proveedor de informacion de la pantalla de detalles
final getAnimeInfoProvider =
    StateNotifierProvider<AnimeInfoNotifier, List<AnimeInfo>>((ref) {
  final getAnimeInfo = ref.watch(animeRepositoryProvider).getAnimeInfo;
  return AnimeInfoNotifier(getAnimeInfo);
});

class AnimeInfoNotifier extends StateNotifier<List<AnimeInfo>> {
  AnimeInfoNotifier(this.getAnimeInfo) : super([]);

  final Future<AnimeInfo> Function(String) getAnimeInfo;

  bool isLoading = false;

  Future<void> getAnimeInf(String url) async {
    if (isLoading) return;

    isLoading = true;
    AnimeInfo animes = await getAnimeInfo(url);

    state = [animes];
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
}

final getPreviusVideoData = StateNotifierProvider<ChapterInfoNotifier, List<Chapter>>((ref) {
  final getChapterInfo = ref.watch(animeRepositoryProvider).getChapterData;
  return ChapterInfoNotifier(getChapterInfo);
});

final getNextVideoData = StateNotifierProvider<ChapterInfoNotifier, List<Chapter>>((ref) {
  final getChapterInfo = ref.watch(animeRepositoryProvider).getChapterData;
  return ChapterInfoNotifier(getChapterInfo);
});

// Proveedor de la informacion del video
final getVideoDataProvider =
    StateNotifierProvider<ChapterInfoNotifier, List<Chapter>>((ref) {
  final getChapterInfo = ref.watch(animeRepositoryProvider).getChapterData;
  return ChapterInfoNotifier(getChapterInfo);
});

class ChapterInfoNotifier extends StateNotifier<List<Chapter>> {
  ChapterInfoNotifier(this.getChapterInfo) : super([]);

  final Future<List<Chapter>> Function(String) getChapterInfo;

  bool isLoading = false;

  Future<void> getVideos(String url) async {
    if (isLoading) return;
    isLoading = true;

    final animes = await getChapterInfo(url);
    state = animes;

    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
}


final getExtraDataProvider =
    StateNotifierProvider<ExtraDataNotifier, List<XData>>((ref) {
  final getAnimeInfo = ref.watch(animeRepositoryProvider).getExtraData;
  return ExtraDataNotifier(getAnimeInfo);
});

class ExtraDataNotifier extends StateNotifier<List<XData>> {
  ExtraDataNotifier(this.getAnimeInfo) : super([]);

  final Future<XData> Function(Anime, String) getAnimeInfo;

  bool isLoading = false;

  Future<void> getXData(Anime anime, String title) async {
    if (isLoading) return;

    isLoading = true;
    XData animes = await getAnimeInfo(anime, title);

    state = [animes];
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
}


class Info extends ChangeNotifier{

  

}