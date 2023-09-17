// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:kimoi/src/UI/providers/animes/anime_repository_provider.dart';
// import 'package:kimoi/src/UI/providers/animes/next_and_before_anime_provider.dart';
// import 'package:kimoi/src/UI/providers/storage/watching_provider.dart';
// import 'package:kimoi/src/UI/screens/screens.dart';

// import '../../domain/domain.dart';
// import '../../infrastructure/infrastructure.dart';
// import '../providers/animes/anime_info_provider.dart';
// import '../providers/storage/favorites_animes_provider.dart';

// final infoProvider = FutureProvider.family((ref, String url) {
//   final animeRepoProvider = ref.watch(animeRepositoryProvider);
//   return animeRepoProvider.getAnimeInfo(url);
// });

// class GeneralBottomSheet extends ConsumerStatefulWidget {
//   const GeneralBottomSheet({
//     super.key,
//     required this.anime,
//   });

//   final Anime anime;

//   @override
//   GeneralBottomSheetState createState() => GeneralBottomSheetState();
// }

// class GeneralBottomSheetState extends ConsumerState<GeneralBottomSheet> {
//   final datasource = AnimeRepositoryImpl(AnimeMacDatasource());

//   var channel = const MethodChannel("extractors");

//   @override
//   void initState() {
//     super.initState();
//     ref.read(animeProvider.notifier).update((state) => widget.anime);
//   }

//   @override
//   Widget build(
//     BuildContext context,
//   ) {
//     final textStyle = Theme.of(context).textTheme;
//     final isFavoriteFuture =
//         ref.watch(isFavoriteProvider(widget.anime.animeTitle));

//     final chapter = widget.anime.chapterUrl!.split('-').last;

//     return Column(children: [
//       Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: Text(
//                 widget.anime.animeTitle,
//                 style: textStyle.titleMedium,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             Text(
//               "Episodio $chapter",
//               style: textStyle.labelMedium,
//               maxLines: 3,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//       const Divider(indent: 10, endIndent: 10, height: 1),
//       ListTile(
//         leading: const Icon(Icons.play_arrow_rounded),
//         title: const Text('Reproducir'),
//         onTap: () async {
//           showDialog(
//               context: context,
//               builder: (context) => const Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                           width: 40,
//                           height: 40,
//                           child: CircularProgressIndicator()),
//                     ],
//                   ));

//           // final id =
//           //     widget.anime.chapterUrl!.split('/').last;
//           // final chapter = await ref
//           //     .read(isWatchingAnimeProvider.notifier)
//           //     .loadWatchingChapter(id);

//           // if (chapter != null) {
//           //   // ref.read(chapterProvider.notifier).update((state) => chapter);
//           //   // await ref.read(videoProvider.notifier).getVideos().then((value) {
//           //   //   context.pop();
//           //   // });
//           //   // await Future.delayed(const Duration(milliseconds: 10), () {
//           //   //   context.pop();
//           //   // });
//           //   Future.delayed(const Duration(milliseconds: 100), () {
//           //     context.push('/local-player', extra: chapter);
//           //   });
//           // } else {
//           await ref
//               .read(getVideoDataProvider.notifier)
//               .getVideos(widget.anime.chapterUrl!)
//               .then((value) async {
//             final chapter = ref.read(getVideoDataProvider).first;

//             for (var element in chapter.servers) {
//               print('pantalla item: ${element}');
//             }

//             chapter.isWatching = true;
//             chapter.imageUrl = widget.anime.imageUrl;
//             chapter.animeUrl = widget.anime.animeUrl;

//             ref.read(chapterProvider.notifier).update((state) => chapter);
//             await ref.read(videoProvider.notifier).getVideos().then((value) {
//               context.pop();
//             });
//             // await Future.delayed(const Duration(milliseconds: 10), () {
//             //   context.pop();
//             // });
//             Future.delayed(const Duration(milliseconds: 100), () {
//               context.push('/local-player', extra: chapter);
//             });
//           });
//         },
//       ),
//       ListTile(
//         leading: const Icon(Icons.info),
//         title: const Text('Ver Detalles'),
//         onTap: () async {
//           await ref
//               .read(isWatchingAnimeProvider.notifier)
//               .loadLastWatchingChapter(widget.anime.animeTitle)
//               .then((value) {
//             ref.read(lastChapterWProvider.notifier).update((state) => value);
//             context.pop();
//             GoRouter.of(context).push('/anime-screen');
//           });
//           // ref.read(getExtraDataProvider.notifier).getXData(widget.anime);
//         },
//       ),
//       ListTile(
//         leading: const Icon(Icons.favorite),
//         title: const Text('Añadir/Eliminar de favoritos'),
//         onTap: () async {
//           await ref
//               .read(favoriteAnimesProvider.notifier)
//               .toggleFavorite(widget.anime)
//               .then((value) {
//             context.pop();

//             setState(() {});

//             String message = '';

//             isFavoriteFuture.when(
//               loading: () => message = 'Loading',
//               data: (isFavorite) => isFavorite
//                   ? message = 'Eliminado de favoritos'
//                   : message = 'Añadido a favoritos',
//               error: (_, __) => throw UnimplementedError(),
//             );

//             final snackBar = SnackBar(
//               content: Text(message),
//               duration: const Duration(seconds: 1),
//             );
//             ScaffoldMessenger.of(context).showSnackBar(snackBar);
//           });

//           ref.invalidate(isFavoriteProvider(widget.anime.animeTitle));
//         },
//       ),
//       ListTile(
//         leading: const Icon(Icons.remove_red_eye),
//         title: const Text('Marcar como visto/No visto'),
//         onTap: () => context.push('/redirect'),
//       ),
//       ListTile(
//         leading: const Icon(Icons.close),
//         title: const Text('Cerrar'),
//         onTap: () => context.pop(),
//       ),
//     ]);
//   }
// }
