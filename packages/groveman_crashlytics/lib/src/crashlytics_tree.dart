import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:groveman/groveman.dart';

/// [Tree] that sends your logs to the Crashlytics.
class CrashlyticsTree extends Tree with IdentifierTree {
  /// Instance of the Crashlytics.
  late final _crashlytics = FirebaseCrashlytics.instance;

  /// Log levels that will be sent for the crashlytics.
  final List<LogLevel> _logLevels;

  /// The default log levels  are [LogLevel.info], [LogLevel.warning],
  /// [LogLevel.error], and [LogLevel.fatal] if there is a [error]
  /// then it's sent using `recordError`, otherwise, with `log`.
  CrashlyticsTree({List<LogLevel>? logLevels})
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

  @override
  void clearUser() => _crashlytics.setUserIdentifier('');

  @override
  void setUser(UserIdentifier userIdentifier) => _crashlytics.setUserIdentifier(
        userIdentifier.id ??
            userIdentifier.email ??
            userIdentifier.username ??
            userIdentifier.name ??
            '',
      );

  @override
  void setIdentifiers({
    Map<String, dynamic>? context,
    Map<String, Object>? tags,
  }) {
    if (tags case final tags?) {
      tags.forEach(_crashlytics.setCustomKey);
      this.tags.addAll(tags);
    }
  }

  @override
  void clearIdentifiers({
    List<String>? contextKeys,
    List<String>? tagKeys,
  }) {
    for (final key in tagKeys ?? <String>[]) {
      _crashlytics.setCustomKey(key, '');
    }
    tagKeys?.forEach(tags.remove);
  }

  @override
  void clearAll() {
    _crashlytics.setUserIdentifier('');
    tags.forEach((key, _) => _crashlytics.setCustomKey(key, ''));
    tags.clear();
  }
}
