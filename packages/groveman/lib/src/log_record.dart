import 'package:groveman/src/log_level.dart';
import 'package:meta/meta.dart';

/// A log record represents an event being logged.
@immutable
class LogRecord {
  /// The log level.
  final LogLevel level;

  /// The log message.
  final String message;

  /// Tag for the log message.
  final String? tag;

  /// Extra data to be logged.
  final Map<String, dynamic>? extra;

  /// The error object.
  final Object? error;

  /// The stack trace.
  final StackTrace? stackTrace;

  /// Creates a new [LogRecord].
  const LogRecord({
    required this.level,
    required this.message,
    this.tag,
    this.extra,
    this.error,
    this.stackTrace,
  });
}
