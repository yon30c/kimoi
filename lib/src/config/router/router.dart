import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimoi/src/UI/screens/genres/genre_screen.dart';
import 'package:kimoi/src/UI/screens/player/local_player.dart';
import 'package:kimoi/src/UI/screens/screens.dart';
import 'package:kimoi/src/domain/domain.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _sectionANavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionANav');


final router =
    GoRouter(navigatorKey: _rootNavigatorKey, initialLocation: '/', routes: [
  StatefulShellRoute.indexedStack(
      builder: (context, state, child) {
        return HomeScreen(navigationShell: child);
      },
      branches: [
        StatefulShellBranch(navigatorKey: _sectionANavigatorKey, routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeNews(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/anime',
            builder: (context, state) => const HomeAnime(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/favorite',
            builder: (context, state) => const HomeFavorites(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: '/explorar',
              builder: (context, state) => const HomeDirectory(),
              routes: [
                GoRoute(
                  path: 'genre-screen/:id',
                  builder: (context, state) {
                    final genero = state.pathParameters['id'] ?? 'no-id';
                    return GenreScreen(genero: genero);
                  },
                ),
              ]),
        ])
      ]),
  GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/anime-screen',
      builder: (context, state) {
        return const DetailsScreen();
      }),

  // This screen is displayed on the ShellRoute's Navigator.
  GoRoute(
    parentNavigatorKey: _rootNavigatorKey,
    path: '/local-player',
    builder: (context, state) {
      final videos = state.extra as Chapter;
      return LocalPlayer(videos: videos);
    },
  ),
]);
