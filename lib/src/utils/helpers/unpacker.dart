import 'substring_extractor.dart';

class Unpacker {
  static String unpack(String script, [String? left, String? right]) {
    final packed = SubstringExtractor(script)
        .substringBetween("}('", ".split('|'),0,{}))")
        .replaceAll("'", '"');


    final parser = SubstringExtractor(packed);


    final data = (left != null && right != null)
        ? parser.substringBetween(left, right)
        : parser.substringBefore("',");

    if (data.isEmpty) {
      return "";
    }

    final dictionary = parser.substringBetween("'", "'").split("|");
    final size = dictionary.length;

    return wordRegex.allMatches(data).map((match) {
      final key = match.group(0)!;
      final index = parseRadix62(key);
      if (index >= size) {
        return key;
      }
      return dictionary[index].isEmpty ? key : dictionary[index];
    }).join();
  }

  static final RegExp wordRegex = RegExp(r'\w+');

  static int parseRadix62(String str) {
    var result = 0;
    for (final ch in str.runes) {
      result = result * 62 + _parseCharRadix62(ch);
    }
    return result;
  }

  static int _parseCharRadix62(int code) {
    if (code >= '0'.codeUnitAt(0) && code <= '9'.codeUnitAt(0)) {
      return code - '0'.codeUnitAt(0); // 0-9
    } else if (code >= 'a'.codeUnitAt(0) && code <= 'z'.codeUnitAt(0)) {
      return code - 'a'.codeUnitAt(0) + 10; // a-z
    } else if (code >= 'A'.codeUnitAt(0) && code <= 'Z'.codeUnitAt(0)) {
      return code - 'A'.codeUnitAt(0) + 36; // A-Z
    } else {
      return 0;
    }
  }
}
