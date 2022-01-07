# Groveman Sentry

[![pub][groveman_sentry_badge]][groveman_sentry_link]
[![License: MIT][license_badge]][license_link]
[![groveman_sentry][workflow_badge]][workflow_link]
[![codecov][codecov_badge]][codecov_link]

Tree for the [groveman][groveman].

It sends your logs to the [Sentry][sentry]. 

This works perfectly with 
[sentry-dart](https://pub.dev/packages/sentry) and
[sentry-flutter](https://pub.dev/packages/sentry_flutter) 🙌

# Usage

Add it in your `pubspec.yaml`:

```yaml
dependencies:    
  groveman:
  groveman_sentry:
  sentry: 
  // or
  sentry_flutter: 
```

Import it where you want to use it e.g, in your main file.

```dart
import 'package:groveman/groveman.dart';
import 'package:groveman_sentry/groveman_sentry.dart';
```

Initialize **Sentry** and plant the `SentryTree` at the start of your application.

```dart
import 'package:flutter/widgets.dart';
import 'package:groveman/groveman.dart';
import 'package:groveman_sentry/groveman_sentry.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() {  
  Groveman.plantTree(DebugTree());
  Groveman.captureErrorInZone(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SentryFlutter.init(
      (options) {
        options.dsn = 'https://example@sentry.io/add-your-dsn-here';
      },
    );    
    if (kReleaseMode) {
      Groveman.plantTree(SentryTree());
    }
    Groveman.captureErrorInCurrentIsolate();
    runApp(const MyApp());
  });
}
```

**Usually, you only send your logs in production**.

By default, the log levels `info`, `warning`, `error`, and `fatal` are sent to Sentry.
```dart
Groveman.error(message, error: exception);
```

If the `LogRecord.error` is not null, it will be sent using `captureEvent`, otherwise, is used [addBreadcrumb][add_breadcrumb].

`LogRecord` converted in **SentryEvent**:
- `LogRecord.level` -> **SentryLevel**
- `LogRecord.message` -> **SentryMessage(message)**
- `LogRecord.json` -> **extra**
- `LogRecord.error` -> **throwable**
- `LogRecord.tag` -> **tags**

`groveman` is sent as **logger** in `SentryEvent`. </br>
The `LogRecord.stackTrace` is only sent in `captureEvent`.

`LogRecord` converted in **Breadcrumb**:
- `LogRecord.level` -> **SentryLevel**
- `LogRecord.message` -> **message**
- `LogRecord.json` -> **data**

To custom, pass the levels that desire to send when creating the `SentryTree`.

```dart
Groveman.plantTree(
    SentryTree(logLevels: [
        LogLevel.warning,
        LogLevel.info,
    ]),
  );
);
```

## 📝 License

Copyright © 2022 [Kauê Martins](github) </br>
This project is [MIT](license_link) licensed

[groveman_sentry_badge]: https://img.shields.io/pub/v/groveman_sentry.svg
[groveman_sentry_link]: https://pub.dev/packages/groveman_sentry
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[codecov_badge]: https://codecov.io/gh/kmartins/groveman/branch/main/graph/badge.svg?flag=groveman_sentry
[codecov_link]: https://codecov.io/gh/kmartins/groveman
[workflow_badge]: https://github.com/kmartins/groveman/actions/workflows/groveman_sentry.yaml/badge.svg
[workflow_link]: https://github.com/kmartins/groveman/actions/workflows/groveman_sentry.yaml
[groveman]: https://pub.dev/packages/groveman
[sentry]: https://sentry.io
[sentry_dart]: https://pub.dev/packages/sentry
[sentry_flutter]: https://pub.dev/packages/sentry_flutter
[add_breadcrumb]: https://docs.sentry.io/platforms/flutter/enriching-events/breadcrumbs/
[github]: https://github.com/kmartins