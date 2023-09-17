/*
  ResolveUrl Kodi Addon
    Copyright (C) 2013 Bstrdsmkr
    Additional fixes by mortael, jairoxyz

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Adapted for use in xbmc from:
    https://github.com/beautify-web/js-beautify/blob/master/python/jsbeautifier/unpackers/packer.py

    Unpacker for Dean Edward's p.a.c.k.e.r, a part of javascript beautifier
    by Einar Lielmanis <einar@jsbeautifier.org>

        written by Stefano Sanfilippo <a.little.coder@gmail.com>

    usage:

    if detect(some_string):
        unpacked = unpack(some_string)

    Unpacker for Dean Edward's p.a.c.k.e.r

* */

library jsunpack;

import 'dart:math';

/// P.A.C.K.E.R code decoder
class JsUnpack {
  final String source;
  const JsUnpack(this.source);

  /// return true if contain P.A.C.K.E.R code
  static bool detect(String html) {
    var reg = RegExp(
      r"eval[ ]*\([ ]*function[ ]*\([ ]*p[ ]*,[ ]*a[ ]*,[ ]*c["
      r" ]*,[ ]*k[ ]*,[ ]*e[ ]*,[ ]*",
    );
    return reg.hasMatch(html);
  }

  ///Unpacks P.A.C.K.E.R. packed js code
  String unpack() {
    var lst = _filterargs();
    String payload = lst[0];
    List<String> symtab = lst[1];
    int radix = lst[2];
    int count = lst[3];
    late UnBaser unBaser;

    String getString(int c, {int? a}) {
      a ??= radix;
      var foo = String.fromCharCode(c % a + 161);
      if (c < a) {
        return foo;
      } else {
        return getString(c ~/ a, a: a) + foo;
      }
    }

    if (count != symtab.length) {
      throw ("Malformed p.a.c.k.e.r. symtab.");
    }
    try {
      unBaser = UnBaser(radix);
    } catch (_) {
      throw ("base conversion error");
    }

    payload = payload.replaceAll("\\\\", "\\").replaceAll("\\'", "'");
    var p = RegExp(r'eval\(function\(p,a,c,k,e.+?String\.fromCharCode\(([^)]+)')
        .firstMatch(payload);
    bool pNew = false;
    if (p?.groupCount != 0) {
      pNew = RegExp(r'String\.fromCharCode\(([^)]+)')
              .firstMatch(payload)
              ?.group(0)
              ?.split('+')[0] ==
          '161';
    }
    if (pNew) {
      for (int i = count - 1; i != -1; i--) {
        payload = payload.replaceAll(getString(i), symtab[i]);
      }
      return _replaceJsStrings(_replaceStrings(payload));
    }
    var source = payload;
    var reg = RegExp(
      r"\b\w+\b",
    ).allMatches(payload);
    int correct = 0;
    for (var element in reg) {
      var word = payload.substring(element.start, element.end);
      var lookUp = "";
      if (radix == 1) {
        lookUp = symtab[int.parse(word)];
      } else {
        var v = unBaser.toBase10(word);
        if (v < symtab.length) {
          lookUp = symtab[v];
          if (lookUp.isEmpty) lookUp = word;
        } else {
          lookUp = word;
        }
      }
      source = source.replaceRange(element.start + correct,
          element.start + word.length + correct, lookUp);
      correct += lookUp.length - (element.end - element.start);
    }
    return _replaceStrings(source);
  }

  String _replaceStrings(String source) {
    var re =
        RegExp(r'var *(_\w+)=\["(.*?)"];', dotAll: true).firstMatch(source);
    if (re == null) {
      return source;
    }
    var varname = re.group(0)!;
    var strings = re.group(1)!;
    var startpoint = strings.length;
    var lookup = strings.split('","');
    var variable = '$varname[%d]';
    for (var i = 0; i < lookup.length; i++) {
      var value = lookup.elementAt(i);
      if (value.contains('\\x')) {
        value = value.replaceAll('\\x', '');
        value = _unHexlify(value);
        source = source.replaceAll(
            variable.replaceAll("%d", i.toString()), '"$value"');
      }
    }
    return source.substring(startpoint);
  }

  String _replaceJsStrings(String source) {
    var re = RegExp(r'\\x([0-7][0-9A-F])').firstMatch(source);
    if (re == null) return source;
    for (var i = 0; i < re.groupCount; i++) {
      source =
          source.replaceAll('\\x${re.group(i)!}', _unHexlify(re.group(i)!));
    }
    return "";
  }

  String _unHexlify(String str) {
    var s = "";
    var un = UnBaser(16);
    for (var value in str.codeUnits) {
      s += un.unBase(value);
    }
    return s;
  }

  List<dynamic> _filterargs() {
    var argsRegex = r"}\s*\('(.*)',\s*(.*?),\s*(\d+),\s*'(.*?)'\.split\('\|'\)";
    var all = RegExp(argsRegex).firstMatch(source);
    try {
      var payload = all!.group(1);
      var radix = int.tryParse(all.group(2)!) ?? 36;
      var count = int.parse(all.group(3)!);
      var symtab = all.group(4)!.split("|");
      return [payload, symtab, radix, count];
    } catch (_) {
      throw ('Corrupted p.a.c.k.e.r. data.');
    }
  }
}

class UnBaser {
  static const alphabet = {
    62: '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',
    95: (' !"#\$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        r'[\]^_`abcdefghijklmnopqrstuvwxyz{|}~')
  };
  final int base;
  const UnBaser(this.base);

  String _convert(int num, String base, String out) {
    if (num >= base.length) {
      out = _convert(num ~/ base.length, base, out);
      out = _convert(num % base.length, base, out);
      return out;
    } else {
      var characters = List.generate(
        base.codeUnits.length,
        (index) {
          return String.fromCharCode(base.codeUnits[index]);
        },
      );
      out += characters[num];
      return out;
    }
  }

  int _convert2(String str, String base) {
    num out = 0;

    int i = 0;
    for (var element in str.codeUnits.reversed) {
      out += (base.indexOf(String.fromCharCode(element)) * pow(this.base, i));
      i++;
    }
    return out.toInt();
  }

  ///convert [num] in base[base]
  ///exemple
  ///'''dart
  ///var un = UnBaser(16);
  ///print(un.unBase(384648));//output 5de88
  ///'''
  String unBase(int num) {
    String? toBase;
    if (2 <= base && base < 62) {
      toBase = alphabet[62]!.substring(0, base);
    } else if (62 < base && base < 62) {
      toBase = alphabet[92]!.substring(0, base);
    }
    if (toBase == null) {
      throw ("base not found");
    }
    return _convert(num, toBase, "");
  }

  ///convert [string] in base 10
  ///exemple
  ///'''dart
  ///var un = UnBaser(16);
  ///print(un.toBase10("5de88"));//output 384648
  ///'''
  int toBase10(String string) {
    var allIn = true;
    var base = alphabet[62]!;
    for (var element in string.codeUnits) {
      if (!base.contains(String.fromCharCode(element))) {
        allIn = false;
        break;
      }
    }
    if (!allIn) base = alphabet[95]!;
    return _convert2(string, base);
  }
}