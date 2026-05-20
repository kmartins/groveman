import 'package:collection/collection.dart';
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

  static const _unset = Object();

  /// Creates a new [LogRecord].
  const LogRecord({
    required this.level,
    required this.message,
    this.tag,
    this.extra,
    this.error,
    this.stackTrace,
  });

  /// Creates a copy of this [LogRecord] with the given fields replaced.
  LogRecord copyWith({
    LogLevel? level,
    String? message,
    Object? tag = _unset,
    Object? extra = _unset,
    Object? error = _unset,
    Object? stackTrace = _unset,
  }) =>
      LogRecord(
        level: level ?? this.level,
        message: message ?? this.message,
        tag: identical(tag, _unset) ? this.tag : tag as String?,
        extra: identical(extra, _unset)
            ? this.extra
            : extra as Map<String, dynamic>?,
        error: identical(error, _unset) ? this.error : error,
        stackTrace:
            identical(stackTrace, _unset) ? this.stackTrace : stackTrace as StackTrace?,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogRecord &&
          runtimeType == other.runtimeType &&
          level == other.level &&
          message == other.message &&
          tag == other.tag &&
          const MapEquality<String, dynamic>().equals(extra, other.extra) &&
          error == other.error &&
          stackTrace == other.stackTrace;

  @override
  int get hashCode => Object.hash(
        level,
        message,
        tag,
        const MapEquality<String, dynamic>().hash(extra),
        error,
        stackTrace,
      );
}
