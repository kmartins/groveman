import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:groveman/groveman.dart';

/// [Tree] that sends your logs to the Crashlytics.
class CrashlyticsTree extends Tree {
  /// Instance of the Crashlytics.
  late final _crashlytics = FirebaseCrashlytics.instance;

  /// Log levels that will be sent for the crashlytics.
  final List<LogLevel> _logLevels;

  /// The default log levels  are [LogLevel.info], [LogLevel.warning],
  /// [LogLevel.error], and [LogLevel.fatal] if there is a [error]
  /// then it's sent using `recordError`, otherwise, with `log`.
  CrashlyticsTree({List<LogLevel>? logLevels})
    : _logLevels =
          logLevels ??
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
        _crashlytics.recordError(
          logRecord.error,
          logRecord.stackTrace,
          reason: logRecord.message,
          fatal: logLevel == LogLevel.fatal,
        );
      } else {
        _crashlytics.log(logRecord.message);
      }
    }
  }
}
