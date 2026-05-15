import 'package:groveman/src/interceptors/groveman_interceptor.dart';
import 'package:groveman/src/log_level.dart';
import 'package:groveman/src/log_record.dart';

/// An interceptor that filters log records by level.
///
/// Records whose [LogRecord.level] is not contained in [allowedLevels] are rejected
/// (i.e. `null` is returned). All other records pass through unchanged.
///
/// ```dart
/// Groveman.addInterceptor(
///   const LogLevelInterceptor([LogLevel.warning, LogLevel.error, LogLevel.fatal]),
/// );
/// ```
final class LogLevelInterceptor implements GrovemanInterceptor {
  /// The log allowedLevels allowed to pass through. Records with other allowedLevels are
  /// rejected.
  final List<LogLevel> allowedLevels;

  /// Creates a [LogLevelInterceptor] with a custom set of [allowedLevels].
  const LogLevelInterceptor(this.allowedLevels);

  /// Creates a [LogLevelInterceptor] pre-configured for error reporting tools
  /// (e.g. Crashlytics, Sentry).
  ///
  /// Defaults to [LogLevel.info], [LogLevel.warning], [LogLevel.error], and
  /// [LogLevel.fatal], excluding [LogLevel.debug].
  /// If [allowedLevels] is provided, it must be non-empty.
  LogLevelInterceptor.reportable({
    this.allowedLevels = const [
      LogLevel.info,
      LogLevel.warning,
      LogLevel.error,
      LogLevel.fatal,
    ],
  }) : assert(allowedLevels.isNotEmpty, 'must have at least one level');

  @override
  LogRecord? intercept(LogRecord record) =>
      allowedLevels.contains(record.level) ? record : null;
}
