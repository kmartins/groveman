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

  final Map<String, dynamic>? _extra;

  /// Extra data to be logged.
  Map<String, dynamic>? get extra {
    final extra = _extra;
    if (extra is UnmodifiableMapView) {
      return extra;
    }
    return extra != null ? UnmodifiableMapView(extra) : null;
  }

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
    this.error,
    this.stackTrace,
    Map<String, dynamic>? extra,
  }) : _extra = extra;

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
        stackTrace: identical(stackTrace, _unset)
            ? this.stackTrace
            : stackTrace as StackTrace?,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      runtimeType == other.runtimeType &&
          other is LogRecord &&
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
