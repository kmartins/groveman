# Groveman Crashlytics

[![pub][groveman_crashlytics_badge]][groveman_crashlytics_link]
[![License: MIT][license_badge]][license_link]
[![groveman_crashlytics][workflow_badge]][workflow_link]
[![codecov][codecov_badge]][codecov_link]

Tree for the [groveman][groveman].

It sends your logs to the [Firebase Crashlytics][firebase_crahslytics]. 

# Usage

First, configure the **Firebase Crashlytics**, for it, see the [documentation][firebase_crahslytics_doc].

_By default, if use Groveman.captureErrorInCurrentIsolate, its log level is `fatal`, this is configurable._

```dart
Groveman.captureErrorInCurrentIsolate(logLevel: LogLevel.error);
```

Add it in your `pubspec.yaml`:

```yaml
dependencies:
  // Only to send the fatal log levels
  firebase_analytics:
  groveman:
  groveman_crashlytics:
```

Import it where you want to use it e.g, in your main file.

```dart
import 'package:groveman/groveman.dart';
import 'package:groveman_crashlytics/groveman_crashlytics.dart';
```

Initialize crashlytics tree on start of your application.

```dart
void main() {  
  Groveman.plantTree(DebugTree());
  Groveman.captureErrorInZone(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    if (kReleaseMode) {
      Groveman.plantTree(CrashlyticsTree());
    }
    Groveman.captureErrorInCurrentIsolate();
    runApp(const MyApp());
  });
}
```

**Usually, you only send your logs in production**.

By default, the log levels `info`, `warning`, `error`, and `fatal` are sent to Crashlytics.
```dart
Groveman.error(message, error: exception);
```

If the `LogRecord.message` contains an `error`, it will be sent using [crashlytics.recordError][record_error] where `LogRecord.error` is passed as **error**, `LogRecord.stackTrace` is passed as **stackTrace**, `LogRecord.message` is passed as **reason** and **fatal** is `true` if the `LogRecord.level` is also fatal, otherwise, is used [crashlytics.log][log], passing the `LogRecord.message` as **message**.

To custom, pass the levels that desire to send when creating the `Crashlytics Tree`.

```dart
Groveman.plantTree(
    CrashlyticsTree(logLevels: [
        LogLevel.warning,
        LogLevel.info,
    ]),
  );
);
```

## 📝 License

Copyright © 2025 [Kauê Martins](github) </br>
This project is [MIT](license_link) licensed

[groveman_crashlytics_badge]: https://img.shields.io/pub/v/groveman_crashlytics.svg
[groveman_crashlytics_link]: https://pub.dev/packages/groveman_crashlytics
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[codecov_badge]: https://codecov.io/gh/kmartins/groveman/branch/main/graph/badge.svg?flag=groveman_crashlytics
[codecov_link]: https://codecov.io/gh/kmartins/groveman
[workflow_badge]: https://github.com/kmartins/groveman/actions/workflows/groveman_crashlytics.yaml/badge.svg
[workflow_link]: https://github.com/kmartins/groveman/actions/workflows/groveman_crashlytics.yaml
[groveman]: https://pub.dev/packages/groveman
[firebase_crahslytics]: https://firebase.google.com/products/crashlytics
[firebase_analytics_doc]: https://firebase.flutter.dev/docs/analytics/overview/
[firebase_analytics_issue]: https://github.com/FirebaseExtended/flutterfire/issues/7714
[firebase_crahslytics_doc]: https://firebase.flutter.dev/docs/crashlytics/overview
[record_error]: https://firebase.flutter.dev/docs/crashlytics/usage#fatal-crash
[log]: https://firebase.flutter.dev/docs/crashlytics/usage#add-custom-log-messages
[github]: https://github.com/kmartins