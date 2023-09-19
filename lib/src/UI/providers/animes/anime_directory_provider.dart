import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/domain.dart';
import '../providers.dart';

final animeDirectoryProvider =
    StateNotifierProvider<AnimeDirectoryNotifier, List<Anime>>((ref) {
  final getDirectory = ref.watch(animeRepositoryProvider).getDirectory;
  return AnimeDirectoryNotifier(getDirectory);
});

typedef GetDirectoryCallback = Future<List<Anime>> Function(
    {int? estado,
    int? estreno,
    String? genero,
    int? idioma,
    int? p,
    String? q,
    String? tipo});

class AnimeDirectoryNotifier extends StateNotifier<List<Anime>> {
  AnimeDirectoryNotifier(this.getDirectory) : super([]);

  final GetDirectoryCallback getDirectory;

  bool isLoading = false;
  int currentPage = 0;

  Future<void> getAnimes(
      {int? estado,
      int? estreno,
      String? genero,
      int? idioma,
      int? p,
      String? q,
      String? tipo}) async {
    if (isLoading) return;

    isLoading = true;

    currentPage++;
    print(currentPage);

    List<Anime> animes = [];

    animes = await getDirectory(
        estado: estado,
        estreno: estreno,
        idioma: idioma,
        genero: genero,
        p: currentPage,
        q: q,
        tipo: tipo);

    state = [...state, ...animes];

    await Future.delayed(const Duration(milliseconds: 300));

    isLoading = false;
  }
}
