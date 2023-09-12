import 'package:flutter/material.dart';
import 'package:kimoi/src/UI/screens/home/home_directory.dart';
import 'package:kimoi/src/UI/screens/home/home_favorites.dart';

import '../../infrastructure/models/page_info.dart';
import '../screens/home/home_anime.dart';
import '../screens/home/home_news.dart';

List<PageInfo> pages = const [
  PageInfo(
    item:
        NavigationDestination(icon: Icon(Icons.newspaper), label: "Noticias", ),
    page: HomeNews(),
  ),
  PageInfo(
    item: NavigationDestination(icon: Icon(Icons.video_collection_rounded), label: "Animes"),
    page: HomeAnime(),
  ),
  PageInfo(
    item: NavigationDestination(icon: Icon(Icons.bookmarks_rounded), label: "Mis listas", ),
    page: HomeFavorites(),
  ),
  PageInfo(
      item: NavigationDestination(icon: Icon(Icons.explore), label: "Explorar"),
      page: HomeDirectory()),
];


