import 'package:flutter/material.dart';
import 'package:kimoi/src/config/source/source_service.dart';
import 'package:kimoi/src/domain/datasources/anime_datasource.dart';
import 'package:kimoi/src/infrastructure/datasources/anime_mac_datasource.dart';
import 'package:kimoi/src/infrastructure/datasources/monoschinos_datasource.dart';

class SourceController with ChangeNotifier {
  final SourceService _sourceService;
  late AnimeDatasource _initialDatasource;
  SourceController(this._sourceService);

  AnimeDatasource get initialDatasource => _initialDatasource;

  Future<void> loadInitialDatasource() async {
    _initialDatasource = await _sourceService.initialDatasource();
    notifyListeners();
  }

  Future<void> updateInitialDatasource(String? newL) async {
    if (newL == null) return;

    AnimeDatasource newLocation = _initialDatasource;

    switch (newL) {
      case "MonosChinos":
        newLocation = MonoschinosDatasource();
        break;
      case "AnimeMac":
        newLocation = AnimeMacDatasource();
        break;
      case "JkAnime":
        throw UnimplementedError();
      case "AnimeFlv":
        throw UnimplementedError();
    }

    if (newLocation == _initialDatasource) return;

    _initialDatasource = newLocation;
    notifyListeners();

    await _sourceService.updateInitialLocation(newL);
  }
}
