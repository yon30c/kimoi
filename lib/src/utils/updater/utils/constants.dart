import 'dart:math';

import 'package:flutter/rendering.dart';

///Converts bytes to readable size
String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}

///returns a random string of the desired [length]
String getRandomString(int length) {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(Random().nextInt(chars.length))));
}

///Print error
void printError(dynamic text) {
  debugPrint('\x1B[31m${text.toString()}\x1B[0m');
}

///Print warning
void printWarning(dynamic text) {
  debugPrint('\x1B[33m${text.toString()}\x1B[0m');
}

///Print info
void printInfo(dynamic text) {
  debugPrint('\x1B[37m${text.toString()}\x1B[0m');
}
