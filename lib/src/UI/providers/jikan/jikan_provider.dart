import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimoi/src/UI/providers/jikan/jikan_repo_provider.dart';
import 'package:kimoi/src/infrastructure/models/jikan_upcoming.dart' as jk;

typedef AnimeCallback = Future<jk.JikanUpcoming> Function(int page);

final upcomingProvider =
    StateNotifierProvider<AnimeNotifier, List<jk.UpDatum>>((ref) {
  final fetchMoreAnimes = ref.watch(jikanRepoProvider).getSeasonUpcoming;
  return AnimeNotifier(fetchMoreAnimes: fetchMoreAnimes);
});

class AnimeNotifier extends StateNotifier<List<jk.UpDatum>> {
  AnimeNotifier({required this.fetchMoreAnimes}) : super([]);

  final AnimeCallback fetchMoreAnimes;

  bool isLoading = false;
  int currentPage = 0;

  bool hasNextPage = true;

  Future<void> getAnimes() async {
    if (isLoading) return;

    isLoading = true;

    List<jk.UpDatum> animes = [];

    if (hasNextPage) {
      currentPage++;
    } else {
      return;
    }

    final res = await fetchMoreAnimes(currentPage);

    hasNextPage = res.pagination.hasNextPage;

    animes = res.data;

    state = [...state, ...animes];

    await Future.delayed(const Duration(milliseconds: 300));

    isLoading = false;
  }
}
