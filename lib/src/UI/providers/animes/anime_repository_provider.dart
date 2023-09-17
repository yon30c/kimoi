import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infrastructure/infrastructure.dart';

final animeRepositoryProvider =
    Provider((ref) => AnimeRepositoryImpl(MonoschinosDatasource()));
