import 'package:groveman/src/log_record.dart';

/// {@template groveman.GrovemanInterceptor}
/// Intercepts log records before they reach a tree.
///
/// Interceptors can:
/// - **Pass through**: Return the record unchanged
/// - **Transform**: Return a modified copy of the record (e.g., redaction, enrichment)
/// - **Reject**: Return `null` to prevent the record from being logged
///
/// Interceptors are executed in the order they were planted. Each interceptor
/// receives the output of the previous one. If any interceptor returns `null`,
/// the chain stops and no tree receives the record.
/// {@endtemplate}
///
/// ## Example: Level Filter
///
/// ```dart
/// class LevelInterceptor extends GrovemanInterceptor {
///   final LogLevel minLevel;
///   LevelInterceptor(this.minLevel);
///
///   @override
///   LogRecord? intercept(LogRecord record) {
///     return record.level.index >= minLevel.index ? record : null;
///   }
/// }
/// ```
///
/// ## Example: Redaction
///
/// ```dart
/// class RedactSecretsInterceptor extends GrovemanInterceptor {
///   @override
///   LogRecord? intercept(LogRecord record) {
///     final redacted = record.message.replaceAll(
///       RegExp(r'password=\S+'),
///       'password=***',
///     );
///     return LogRecord(
///       level: record.level,
///       message: redacted,
///       tag: record.tag,
///       extra: record.extra,
///       error: record.error,
///       stackTrace: record.stackTrace,
///     );
///   }
/// }
/// ```
abstract interface class GrovemanInterceptor {
  /// {@macro groveman.GrovemanInterceptor}
  const GrovemanInterceptor();

  /// Intercepts a log record.
  ///
  /// Return the [record] unchanged to pass through, a modified copy to
  /// transform, or `null` to reject (prevent the record from reaching trees).
  LogRecord? intercept(LogRecord record);
}
