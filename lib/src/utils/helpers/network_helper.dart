import 'package:http/http.dart' as http;

class NetworkHelper {
  http.Client client = http.Client();
  http.Client cloudflareClient = http.Client();
}
