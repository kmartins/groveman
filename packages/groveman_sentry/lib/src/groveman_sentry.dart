import 'package:groveman/groveman.dart';
import 'package:groveman_sentry/src/log_extensions.dart';
import 'package:meta/meta.dart';
import 'package:sentry/sentry.dart';

/// {@template sentry_tree}
/// [Tree] that sends your logs to the Sentry.
///
/// ```dart
/// void main() {
///   Groveman.plantTree(SentryTree());
/// }
/// ```
/// {@endtemplate}
class SentryTree extends Tree {
  /// Log levels that will be sent for the sentry.
  final List<LogLevel> _logLevels;
  Hub _hub = HubAdapter();

  @visibleForTesting
  // ignore: use_setters_to_change_properties
  void setMockHub(Hub mockHub) => _hub = mockHub;

  /// The default log levels are [LogLevel.info], [LogLevel.warning],
  /// [LogLevel.error], and [LogLevel.fatal] if there is a [error]
  /// then it's sent using `captureEvent`, otherwise, with `addBreadcrumb`.
  SentryTree({List<LogLevel>? logLevels})
      : _logLevels = logLevels ??
            [
              LogLevel.info,
              LogLevel.warning,
              LogLevel.error,
              LogLevel.fatal,
            ],
        assert(logLevels?.isNotEmpty ?? true, 'must have at least one level');

  @override
  void log(LogRecord logRecord) {
    final logLevel = logRecord.level;

    if (_logLevels.contains(logLevel)) {
      if (logRecord.error != null) {
        _hub.captureEvent(
          logRecord.toEvent,
          stackTrace: logRecord.stackTrace,
        );
      } else {
        _hub.addBreadcrumb(logRecord.toBreadcrumb);
      }
    }
  }
}
