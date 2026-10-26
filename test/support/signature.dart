import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert';

/// Last.fm's documented signing algorithm, written out independently of the
/// library: sort the parameters by name, concatenate `name + value` for each,
/// append the secret and take the md5 hex digest. `api_sig` itself, and
/// `format`, are not part of the signature.
String expectedSignature(Map<String, String> parameters, String secret) {
  final names =
      parameters.keys.where((k) => k != 'api_sig' && k != 'format').toList()
        ..sort();
  final payload = StringBuffer();
  for (final name in names) {
    payload
      ..write(name)
      ..write(parameters[name]);
  }
  payload.write(secret);
  return crypto.md5.convert(utf8.encode(payload.toString())).toString();
}
