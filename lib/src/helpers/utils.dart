//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' show md5;

/// Generate a MD5 string by a given value.
String generateMD5(String value) {
  var content = Utf8Encoder().convert(value);
  var digest = md5.convert(content);
  return hex.encode(digest.bytes);
}

/// Generate a string from a list.
/// The LastFM way.
String generateStringFromList(List list) {
  return list.join(',');
}

/// Format the text in unicode
String formatUnicode({required dynamic text}) {
  if (text is Uint8List) {
    return utf8.decode(text);
  } else if (text is String) {
    return utf8.decode(utf8.encode(text));
  } else {
    return text.toString();
  }
}

/// It helps checking if it's a xml.
/// The only type of response are XML and JSON, so...
bool isXml(dynamic object) {
  if (object.toString().startsWith('<')) {
    return true;
  }
  return false;
}

/// It helps checking if a field can be parsed in a known way.
bool isValidParsableStringField(dynamic value) =>
    value != null && value.toString() != 'null' && value.toString().isNotEmpty;

/// Safely parses a Last.fm response node that can be either a `List` of items or a
/// single `Map` (when only 1 result exists in Last.fm XML-to-JSON engine).
List<T>? parseLastFMList<T>(
  dynamic rawNode,
  T Function(Map<String, dynamic> item) fromJson,
) {
  if (rawNode == null) return null;
  if (rawNode is List) {
    return rawNode
        .map((item) => fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }
  if (rawNode is Map) {
    return [fromJson(Map<String, dynamic>.from(rawNode))];
  }
  return null;
}
