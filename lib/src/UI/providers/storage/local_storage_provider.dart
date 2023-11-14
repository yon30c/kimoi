import 'package:kimoi/src/infrastructure/datasources/isar_datasource.dart';
import 'package:kimoi/src/infrastructure/repositories/local_storage_repository_impl.dart';
import 'package:riverpod/riverpod.dart';

final localStorageRepositoryProvider =
    Provider((ref) => LocalStorageRepositoryImpl(IsarDatasource()));
