import 'package:groveman/src/interceptors/groveman_interceptor.dart';
import 'package:groveman/src/log_record.dart';

/// {@template groveman.DelegatedGrovemanInterceptor}
/// A [GrovemanInterceptor] implementation that delegates to a function.
///
/// This allows creating interceptors inline without defining a class:
///
/// ```dart
/// // Filter logs by level
/// final levelFilter = DelegatedGrovemanInterceptor(
///   (record) => record.level.index >= LogLevel.warning.index ? record : null,
/// );
///
/// // Redact sensitive data
/// final redactor = DelegatedGrovemanInterceptor((record) {
///   if (record.message.contains('password')) {
///     return LogRecord(
///       level: record.level,
///       message: record.message.replaceAll(RegExp(r'password=\S+'), 'password=***'),
///       tag: record.tag,
///       extra: record.extra,
///       error: record.error,
///       stackTrace: record.stackTrace,
///     );
///   }
///   return record;
/// });
/// ```
///
/// For interceptors with state or complex configuration, prefer extending
/// [GrovemanInterceptor] directly.
/// {@endtemplate}
class DelegatedGrovemanInterceptor implements GrovemanInterceptor {
  final LogRecord? Function(LogRecord record) _intercept;

  /// {@macro groveman.DelegatedGrovemanInterceptor}
  ///
  /// The [intercept] function receives a [LogRecord] and should return:
  /// - The record unchanged to pass through
  /// - A new [LogRecord] to transform
  /// - `null` to reject the record and prevent it from reaching trees
  const DelegatedGrovemanInterceptor(
    LogRecord? Function(LogRecord record) intercept,
  ) : _intercept = intercept;

  @override
  LogRecord? intercept(LogRecord record) => _intercept.call(record);
}
