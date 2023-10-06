import 'package:flutter/material.dart';
import 'package:kimoi/src/config/router/router_service.dart';

class RouterController with ChangeNotifier {


  final RouterService _routerService;
  late String _initialLocation;
  RouterController(this._routerService);

  String get initialLocation => _initialLocation;

  Future<void> loadInitialLocation() async {
    _initialLocation = await _routerService.initialLocation();
    notifyListeners();
  }

  Future<void> updateInitialLocation(String? newL) async {
    if (newL == null) return;

    String newLocation = "/";
    switch (newL) {
      case "Noticias":
        newLocation = "/";
        break;
      case "Animes":
        newLocation = "/anime";
        break;
      case "Listas":
        newLocation = "/favorite";
        break;
      case "Explorar":
        newLocation = "/explorar";
        break;
    }

    if (newLocation == _initialLocation) return;

    _initialLocation = newLocation;
    notifyListeners();

    await _routerService.updateInitialLocation(newLocation);
  }
}
