# Groveman

<a href="https://pub.dev/packages/groveman"><img src="https://img.shields.io/pub/v/groveman.svg" alt="Pub"></a>
[![License: MIT][license_badge]][license_link]
[![groveman](https://github.com/kmartins/groveman/actions/workflows/groveman.yaml/badge.svg)](https://github.com/kmartins/groveman/actions/workflows/groveman.yaml)
[![codecov](https://codecov.io/gh/kmartins/groveman/branch/main/graph/badge.svg?token=9OHL7Q2V5A)](https://codecov.io/gh/kmartins/groveman)

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT

Logging for **Dart/Flutter** applications.

It's very similar to Android logging library called [Timber](https://github.com/JakeWharton/timber) and also with the package for Dart/Flutter called [Fimber](https://github.com/magillus/flutter-fimber) that implements the same concept of the tree and planting logging tree.

Behavior is added through `Tree` instances. You can install an instance by calling Groveman.plantTree. Installation of Trees should be done as early as possible, e.g, in the function `main`.

There are no Tree implementations installed by default because, second `Timber`, every time you log in production, a puppy dies.

There is a `tree` for the debug mode called `DebugTree`, it's totally configurable.

The logging is formed by the **level, tag, message, json, error and stack trace**.

## Levels

For define severity of a logging. The level is set to one of five values, which are, in order of severity:

- fatal
- error
- warning 
- info 
- debug

## Usage

Add it in your `pubspec.yaml`:

```yaml
dependencies:
  groveman: any
```

Import it where you want to use it e.g, in your main file.

```dart
import 'package:groveman/groveman.dart';
```

Initialize logging tree on start of your application.

```dart
void main(){
  Groveman.plantTree(DebugTree());

  //log
  Groveman.debug();
  Groveman.info('info', tag: 'info');
  Groveman.warning('error', tag: 'info', json: <String, Object>{
      'name': 'Jungle',
      'trees': 50,
    },
  );
  Groveman.error('info', tag: 'info', error: Error());
  Groveman.fatal('info', tag: 'info', stackTrace: StackTrace.current);
}
```

You can plant a tree depending on the mode, e.g debug and production.

```dart
void main(){
  if (kReleaseMode) {
    Groveman.plantTree(CrashlyticsTree());
  } else {
    Groveman.plantTree(DebugTree());
  }
}
```

Configure to capture exception in Zone and in current Isolate

```dart
void main(){
  Groveman.captureErrorInZone(() => runApp(MyApp()));
  Groveman.captureErrorInCurrentIsolate();
}
```

Look at the example app to see `Groveman` in action.

## Debug Tree

Uses the dart:developer [log()](https://api.flutter.dev/flutter/dart-developer/log.html) function to show logging.

In your **tests** it's not shown. Only in **debug mode**.

**Format of the output**
```
[Log Level] [tag]: message
json
Error
StackTrace
```

![output](https://raw.githubusercontent.com/kmartins/groveman/master/assets/output.png)

The json will be showed formatted.

If the tag is not provided, the implementation will automatically figure out from which file and line it's being called and use that **file name and line as its tag**.
You can set to not show the tag.
```dart
Groveman.plantTree(DebugTree(showTag: false));
``` 

The log level text can be replaced for emoji.

```dart
Groveman.plantTree(DebugTree(showEmoji: true));
```

Sets method count, used when there is the stack trace.
```dart
// Log Level - debug, info, warning
Groveman.plantTree(DebugTree(methodCount: 2));
// Log Level - error, fatal
Groveman.plantTree(DebugTree(errorMethodCount: 2));
```

Still is possible to colorize your logs.

```dart
Groveman.plantTree(DebugTree(showColor: true));
```

There is a problem with the show of the stack trace in flutter web, you can see here https://github.com/flutter/flutter/issues/79176

## Others Trees

There are no others trees in this package yet.
However,  you can create your, just extend the `Tree` class. 
Take a look at the `DebugTree` code to know more.

## 📝 Maintainers

[Kauê Martins](https://github.com/kmartins)

## 🤝 Support

You liked this package? Then give it a ⭐️. If you want to help then:

- Fork this repository
- Send a Pull Request with new features
- Share this package
- Create issues if you find a bug or want to suggest a new extension

**Pull Request title follows [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/). The scope available is `groveman`.**

## 📝 License

Copyright © 2021 [Kauê Martins](https://github.com/kmartins).<br />
This project is [MIT](https://opensource.org/licenses/MIT) licensed.