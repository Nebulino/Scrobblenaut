<h1 align="center">Scrobblenaut</h1>

<div align="center">
Just a Last.FM API Wrapper for Dart.
A package to interact with the official 

[Last.FM API](https://last.fm/api/).

[![Dart Version](https://img.shields.io/badge/Dart-2.12.1-blue.svg?style=flat-square&logo=dart)](https://dart.dev)
[![Build Status](https://img.shields.io/travis/Nebulino/Scrobblenaut/master?style=flat-square&logo=travis)](https://travis-ci.org/github/Nebulino/Scrobblenaut)
[![Last.FM](https://img.shields.io/badge/API-v.2.0-00aced.svg?style=flat-square&logo=last.fm)](https://www.last.fm/api/)
[![Nebulino](https://img.shields.io/badge/💬%20Telegram-Nebulino-blue.svg?style=flat-square)](https://t.me/Nebulino/)

</div>

## Disclaimer

I'm doing it just for fun, so... use at your own risk.

I hope it will become something great.

^-^
## Usage

First build the .g files for Serializable (if you clone the repo):

```pub run build_runner build```

A simple usage example:

```dart
import 'package:scrobblenaut/scrobblenaut.dart';

// A simple example...
// For more, check the example folder.
void main() async {
  final lastFMAuth = await LastFM.noAuth(apiKey: APIValues.API);
  final scrobblenaut = Scrobblenaut(lastFM: lastFMAuth);
  
  // Start using the Wrapper...
}

```

## Get Scrobblenaut

Add Scrobblenaut dependency on `pubspec.yaml`:

From GitHub (for example: branch-name >> dev-build):
```yaml
dependencies:
  scrobblenaut:
    git: https://github.com/Nebulino/Scrobblenaut.git
      ref: branch-name
```

From pub.dev:

```yaml
dependencies:
  scrobblenaut: ^version-number
```

## Features and bugs

### Status

All the methods are available.
Needs more time to check for problems caused by a bad information management from the API side.
For example: 

  - Tracks duration information taken from an album like method is different from a Track duration taken from a 
track info query.

  - Some variables can have strange content such as FIXME on some Track duration.

  - Many more. For now with my tests, this is the best I can handle. I just need more track and usage of my package
to track different type of errors that can occurs.

### Future of the package after all methods implemented

It's still a long way.
I have some ideas, and I'm going to continue to support it, just stay tuned.

### For the documentation

For now, You have to download the repo and run *dartdoc* on the console,
on the root of the package. When I upload this package on *pub.dev* you can use the documentation from there directly.

There's 2 type of usage:
  - with authentication;
  - without authentication.

Please file feature requests and bugs at the [issue tracker][tracker].

##### Copyright © 2020 Nebulino

[tracker]: https://github.com/Nebulino/Scrobblenaut/issues
