import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimoi/src/infrastructure/datasources/isar_datasource.dart';
import 'package:kimoi/src/infrastructure/repositories/local_storage_repository_impl.dart';

final localStorageRepositoryProvider =
    Provider((ref) => LocalStorageRepositoryImpl(IsarDatasource()));
