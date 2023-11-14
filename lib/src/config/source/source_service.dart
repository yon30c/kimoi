import 'package:kimoi/src/domain/datasources/anime_datasource.dart';
import 'package:kimoi/src/infrastructure/datasources/anime_mac_datasource.dart';
import 'package:kimoi/src/infrastructure/datasources/monoschinos_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SourceService {
  static late SharedPreferences prefs;

  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  AnimeDatasource getInitialDatasource() {
    final slocation = prefs.getString('source');
    switch (slocation) {
      case "MonosChinos":
        return MonoschinosDatasource();
      case "AnimeMac":
        return AnimeMacDatasource();
      default:
        return MonoschinosDatasource();
    }
  }

  Future<AnimeDatasource> initialDatasource() async => getInitialDatasource();

  Future<void> updateInitialLocation(String location) async {
    String selectedLocation;
    switch (location) {
      case "MonosChinos":
        selectedLocation = "MonosChinos";
        break;
      case "AnimeMac":
        selectedLocation = "AnimeMac";
        break;

      default:
        selectedLocation = "MonosChinos";
        break;
    }
    prefs.setString('source', selectedLocation);
  }
}
