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
  Breadcrumb get toBreadcrumb => Breadcrumb(
        level: level.toSentryLevel,
        message: message,
        data: extra,
      );

  /// Converts from [LogRecord] to [SentryEvent].
  SentryEvent get toEvent {
    final sentryTag = tag;
    return SentryEvent(
      level: level.toSentryLevel,
      message: SentryMessage(message),
      contexts: extra != null ? Contexts.fromJson(extra!) : null,
      throwable: error,
      tags: sentryTag != null ? {'groveman_tag': sentryTag} : null,
      logger: 'groveman',
    );
  }
}
