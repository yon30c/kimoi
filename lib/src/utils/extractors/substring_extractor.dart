class SubstringExtractor {
  final String _text;

  SubstringExtractor({required String text}) : _text = text;

  int startIndex = 0;

  skipOver(String str) {
    final index = _text.indexOf(str, startIndex);
    if (index == -1) return;
    startIndex = index + str.length;
  }

  String substringBefore(String str) {
    final index = _text.indexOf(str, startIndex);
    if (index == -1) return "";
    final result = _text.substring(startIndex, index);
    startIndex = index + str.length;
    return result;
  }

  String substringBetween(String left, String right) {
    final index = _text.indexOf(left, startIndex);
    if (index == -1) return "";
    final leftIndex = index + left.length;
    final rightIndex = _text.indexOf(right, leftIndex);
    if (rightIndex == -1) return "";
    startIndex = rightIndex + right.length;
    return _text.substring(leftIndex, rightIndex);
  }
}
