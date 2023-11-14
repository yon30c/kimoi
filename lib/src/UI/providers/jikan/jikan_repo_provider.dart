import 'package:kimoi/src/infrastructure/datasources/jikan_datasource_impl.dart';
import 'package:kimoi/src/infrastructure/repositories/jikan_repository_impl.dart';
import 'package:riverpod/riverpod.dart';

final jikanRepoProvider =
    Provider((ref) => JikanRepositoryImpl(JikanDatasourceImpl()));
