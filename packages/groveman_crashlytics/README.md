# Groveman Crashlytics

[![License: MIT][license_badge]][license_link]
[![groveman_crashlytics][workflow_badge]][workflow_link]
[![codecov](https://codecov.io/gh/kmartins/groveman/branch/main/graph/badge.svg?token=9OHL7Q2V5A)](https://codecov.io/gh/kmartins/groveman)


Tree for the [groveman][groveman].

It sends your logs to the [Firebase Crashlytics][firebase_crahslytics]. 

# Usage

First, configure the **Firebase Crashlytics**, for it, see the [documentation][firebase_crahslytics_doc].

**Configure [Firebase Analytics][firebase_analytics_doc] if you want to send fatal log levels - [issue][firebase_analytics_issue].**

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

If the log contains an `error` then it is sent using [crashlytics.recordError][record_error] (`fatal` is **true** only if the log level is also), otherwise, using [crashlytics.log][log].

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

Copyright © 2021 [Kauê Martins](github)

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
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