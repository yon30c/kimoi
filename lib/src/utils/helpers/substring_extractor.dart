

class SubstringExtractor {
  String text;
  int startIndex = 0;

  SubstringExtractor(this.text);

  void skipOver(String str) {
    final index = text.indexOf(str, startIndex);
    if (index != -1) {
      startIndex = index + str.length;
    }
  }

  String substringBefore(String str) {
    final index = text.indexOf(str, startIndex);
    if (index == -1) {
      return "";
    }
    final result = text.substring(startIndex, index);
    startIndex = index + str.length;
    return result;
  }

  String substringBetween(String left, String right) {
    final index = text.indexOf(left, startIndex);
    if (index == -1) {
      return "";
    }
    final leftIndex = index + left.length;
    final rightIndex = text.indexOf(right, leftIndex);
    if (rightIndex == -1) {
      return "";
    }
    startIndex = rightIndex + right.length;
    return text.substring(leftIndex, rightIndex);
  }
}
