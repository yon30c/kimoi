extension StringExtension on String {
  String substringAfter(String delimiter, {String missingDelimiterValue = ''}) {
    final index = indexOf(delimiter);
    return index == -1
        ? missingDelimiterValue
        : substring(index + delimiter.length);
  }

  String substringBefore(String delimiter,
      {String missingDelimiterValue = ''}) {
    final index = indexOf(delimiter);
    return index == -1 ? missingDelimiterValue : substring(0, index);
  }

  String substringBeforeLast(String delimiter,
      {String missingDelimiterValue = ''}) {
    final index = lastIndexOf(delimiter);
    return index == -1 ? missingDelimiterValue : substring(0, index);
  }

  String substringAfterLast(String delimiter,
      {String missingDelimiterValue = ''}) {
    final index = lastIndexOf(delimiter);
    return index == -1
        ? missingDelimiterValue
        : substring(index + delimiter.length);
  }

  String extractLink(String attr) {
    return substringAfter("$attr\\\":\\\"")
        .substringBefore("\\\"")
        .replaceAll("\\\\u0026", "&");
  }
}

extension IterableExtension<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E value) f) {
    var index = 0;
    return map((value) => f(index++, value));
  }
}
