// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:kimoi/src/domain/entities/anime.dart';

// import '../../UI/items/general_button_sheet.dart';
// import '../../UI/providers/animes/anime_info_provider.dart';

// void showButtonSheet(BuildContext context,
//     {required Anime anime, required WidgetRef ref}) {

//   ref.read(animeProvider.notifier).update((state) => anime);


//   showModalBottomSheet(
//     showDragHandle: true,
//       context: context,
//       builder: (context) {
//         return GeneralBottomSheet( anime: anime);
//       });
// }
