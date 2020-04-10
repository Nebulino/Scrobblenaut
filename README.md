<h1 align="center">Scrobblenaut</h1>

<div align="center">
Just a Last.FM API Wrapper for Dart.
A package to interact with the official 

[Last.FM API](https://last.fm/api/).

[![Dart Version](https://img.shields.io/badge/Dart-2.7.2-blue.svg?style=flat-square&logo=dart)](https://dart.dev)
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
void main() async {
  final scrobblenaut = Scrobblenaut(apiKey: 'Key', apiSecret: 'Secret');
}

```

## Get Scrobblenaut

Add Scrobblenaut dependency on `pubspec.yaml`:

From GitHub:
```yaml
dependencies:
  scrobblenaut:
    git: https://github.com/Nebulino/Scrobblenaut.git
      ref: branch-name
```

From pub.dev:

##### Coming soon... I hope...

## Features and bugs

#### WARNING 
THIS IS NOT FULLY USABLE.
IT'S A WORK IN PROGRESS, FEEL FREE TO SHARE YOUR THOUGHTS HOW TO MAKE IT BETTER. 

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/Nebulino/Scrobblenaut/issues

##### Copyright © 2020 Nebulino
