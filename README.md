<h1 align="center">Scrobblenaut</h1>

<div align="center">
A simple, modern Last.fm API wrapper for Dart & Flutter.

[![Pub Version](https://img.shields.io/pub/v/scrobblenaut?style=flat-square&logo=dart)](https://pub.dev/packages/scrobblenaut)
[![Dart SDK](https://img.shields.io/badge/Dart-3.0%2B-blue.svg?style=flat-square&logo=dart)](https://dart.dev)
[![Last.FM](https://img.shields.io/badge/API-v.2.0-00aced.svg?style=flat-square&logo=last.fm)](https://www.last.fm/api/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](LICENSE)

</div>

---

## Installation

Add Scrobblenaut to your project:

```bash
dart pub add scrobblenaut
```

Or manually in `pubspec.yaml`:

```yaml
dependencies:
  scrobblenaut: ^3.0.1
```

---

## Usage

### 1. Unauthenticated Requests (Search & Metadata)

For methods that do not require user authorization (e.g. searching artists, albums, tracks, fetching tags or charts):

```dart
import 'package:scrobblenaut/scrobblenaut.dart';

void main() async {
  final lastFM = LastFM.noAuth(apiKey: 'YOUR_API_KEY');
  final scrobblenaut = Scrobblenaut(lastFM: lastFM);

  // Fetch track metadata
  final track = await scrobblenaut.track.getInfo(
    artist: 'Daft Punk',
    track: 'One More Time',
  );

  print('Track listeners: ${track.listeners}');
}
```

### 2. Authenticated Requests (Scrobbling & Now Playing)

You can authenticate using a pre-existing session key, user credentials, or an authorized web/desktop token:

```dart
import 'package:scrobblenaut/scrobblenaut.dart';

void main() async {
  // Option A: Using an existing session key (recommended for apps after first login)
  final lastFM = LastFM.withSessionKey(
    apiKey: 'YOUR_API_KEY',
    apiSecret: 'YOUR_API_SECRET',
    sessionKey: 'YOUR_SESSION_KEY',
  );

  // Option B: Authenticating with credentials via mobile session
  // final lastFM = await LastFM.authenticate(
  //   apiKey: 'YOUR_API_KEY',
  //   apiSecret: 'YOUR_API_SECRET',
  //   username: 'YOUR_USERNAME',
  //   password: 'YOUR_PASSWORD',
  // );

  final scrobblenaut = Scrobblenaut(lastFM: lastFM);

  // Update Now Playing
  await scrobblenaut.track.updateNowPlaying(
    artist: 'Daft Punk',
    track: 'One More Time',
    album: 'Discovery',
  );

  // Scrobble a track
  final response = await scrobblenaut.track.scrobble(
    artist: 'Daft Punk',
    track: 'One More Time',
    album: 'Discovery',
    timestamp: DateTime.now(),
  );

  print('Scrobble accepted: ${response.accepted}');
}
```

#### Authentication Options:
- **`LastFM.withSessionKey(...)`**: Instantiate with an already stored session key (best practice for persisted sessions).
- **`LastFM.authenticateWithToken(...)`**: Exchange an authorized web/desktop token (`auth.getSession`).
- **`LastFM.authenticate(...)`**: Authenticate directly with username and password (`auth.getMobileSession`).

---

## Development

If you are cloning this repository to contribute:

```bash
dart run build_runner build
```

Run tests and analyzer:

```bash
dart test
dart analyze
```

---

## Documentation

Full API documentation is available at [pub.dev/documentation/scrobblenaut](https://pub.dev/documentation/scrobblenaut/latest/).

Please file bug reports and feature requests on [GitHub Issues](https://github.com/Nebulino/Scrobblenaut/issues).

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
