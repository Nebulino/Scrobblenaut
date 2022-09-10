//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'dart:convert';
import 'dart:typed_data';

// ignore: import_of_legacy_library_into_null_safe
import 'package:convert/convert.dart';
// ignore: import_of_legacy_library_into_null_safe
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
    (value != null || value.toString() != 'null' || value.toString() != '')
        ? true
        : false;
