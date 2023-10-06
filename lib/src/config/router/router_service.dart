import 'package:shared_preferences/shared_preferences.dart';

class RouterService {
  static late SharedPreferences prefs;

  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  String getInitialLocation() {
    final slocation = prefs.getInt('location');

    String location = "/";

    switch (slocation) {
      case 0:
        location = "/";
        break;
      case 1:
        location = "/anime";
        break;
      case 2:
        location = "/favorite";
        break;
      case 3:
        location = "/explorar";
        break;
      default:
    }

    return location;
  }

  Future<String> initialLocation() async => getInitialLocation();

  Future<void> updateInitialLocation(String location) async {
    int selectedLocation;
    switch (location) {
      case "/":
        selectedLocation = 0;
        break;
      case "/anime":
        selectedLocation = 1;
        break;
      case "/favorite":
        selectedLocation = 2;
        break;
      case "/explorar":
        selectedLocation = 3;
        break;
      default:
        selectedLocation = 0;
        break;
    }
    prefs.setInt('location', selectedLocation);
  }
}
