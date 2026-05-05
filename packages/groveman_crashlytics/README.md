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

## Identifier Tree

`CrashlyticsTree` implements the `IdentifierTree` mixin, which allows you to enrich your Crashlytics reports with user and custom key data. See [Customize crash reports][crashlytics_customize] for more details.

### Set user

```dart
Groveman.setUserIdentifier(
  UserIdentifier(
    id: '1',
    email: 'user@example.com',
    username: 'username',
    name: 'User Name',
  ),
);
```

The first non-null value among `id`, `email`, `username`, and `name` is passed to [`setUserIdentifier`][crashlytics_set_user].

### Set custom keys (tags)

```dart
Groveman.setIdentifiers(
  tags: {
    'environment': 'production',
    'version': '1.1.0',
  },
);
```

Tags are set as Crashlytics custom keys via [`setCustomKey`][crashlytics_custom_keys].

> **Note:** Crashlytics does not support context — only `tags` are applied.

### Clear identifiers

Crashlytics does not support removing user identifiers or custom keys directly — clearing sets them to an empty string, as described in the [documentation][crashlytics_customize].

```dart
// Clears the user
Groveman.clearUserIdentifier();

// Clears specific tag keys
Groveman.clearIdentifiers(
  tagKeys: ['environment'],
);

// Clears all user and custom keys
Groveman.clearAllIdentifiers();
```

## 📝 License

Copyright © 2026 [Kauê Martins](github) </br>
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
[crashlytics_customize]: https://firebase.flutter.dev/docs/crashlytics/usage
[crashlytics_set_user]: https://firebase.flutter.dev/docs/crashlytics/usage#set-user-identifiers
[crashlytics_custom_keys]: https://firebase.flutter.dev/docs/crashlytics/usage#add-custom-keys
[github]: https://github.com/kmartins