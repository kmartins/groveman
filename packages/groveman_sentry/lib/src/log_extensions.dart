import 'package:groveman/groveman.dart';
import 'package:sentry/sentry.dart';

/// Useful methods to use [LogLevel] with the [Sentry]
extension LogLevelExtension on LogLevel {
  /// Converts from [LogLevel] to [SentryLevel].
  SentryLevel get toSentryLevel {
    switch (this) {
      case LogLevel.info:
        return SentryLevel.info;
      case LogLevel.warning:
        return SentryLevel.warning;
      case LogLevel.error:
        return SentryLevel.error;
      case LogLevel.fatal:
        return SentryLevel.fatal;
      default:
        return SentryLevel.debug;
    }
  }
}

/// Useful methods to use [LogRecord] with the [Sentry]
extension LogRecordExtension on LogRecord {
  /// Converts from [LogRecord] to [Breadcrumb].
  Breadcrumb get toBreadcrumb {
    return Breadcrumb(
      level: level.toSentryLevel,
      message: message,
      data: json,
    );
  }
}
