import 'package:kimoi/src/infrastructure/datasources/kudasai_news_datasource.dart';
import 'package:kimoi/src/infrastructure/repositories/news_repository_impl.dart';
import 'package:riverpod/riverpod.dart';

final newsRepositoryProvider =
    Provider((ref) => NewRepositoryImpl(KudasaiNewsDatasource()));
