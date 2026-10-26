//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

/// The credentials used by the examples.
///
/// Nothing secret lives in this repository: every value comes from a
/// `--define` at run time and falls back to a placeholder, so the examples
/// type-check on a fresh clone and a real key can never be committed.
///
/// ```bash
/// dart run \
///   --define=LASTFM_API_KEY=... \
///   --define=LASTFM_API_SECRET=... \
///   --define=LASTFM_USERNAME=... \
///   --define=LASTFM_PASSWORD=... \
///   --define=LASTFM_SESSION_KEY=... \
///   example/scrobblenaut_example.dart
/// ```
class APIValues {
  static const String api = String.fromEnvironment(
    'LASTFM_API_KEY',
    defaultValue: 'YOUR_LASTFM_API_KEY',
  );

  static const String secret = String.fromEnvironment(
    'LASTFM_API_SECRET',
    defaultValue: 'YOUR_LASTFM_API_SECRET',
  );

  static const String username = String.fromEnvironment(
    'LASTFM_USERNAME',
    defaultValue: 'YOUR_LASTFM_USERNAME',
  );

  static const String password = String.fromEnvironment(
    'LASTFM_PASSWORD',
    defaultValue: 'YOUR_LASTFM_PASSWORD',
  );

  static const String sessionKey = String.fromEnvironment(
    'LASTFM_SESSION_KEY',
    defaultValue: 'YOUR_LASTFM_SESSION_KEY',
  );
}
