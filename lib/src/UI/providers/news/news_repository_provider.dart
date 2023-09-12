import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimoi/src/infrastructure/datasources/kudasai_news_datasource.dart';
import 'package:kimoi/src/infrastructure/repositories/news_repository_impl.dart';

final newsRepositoryProvider =
    Provider((ref) => NewRepositoryImpl(KudasaiNewsDatasource()));
