
import 'package:kimoi/main.dart';
import 'package:riverpod/riverpod.dart';

import '../../../infrastructure/infrastructure.dart';

final animeRepositoryProvider =
    Provider((ref) => AnimeRepositoryImpl(sourceController.initialDatasource));
