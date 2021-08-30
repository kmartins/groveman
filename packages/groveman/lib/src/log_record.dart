import 'package:meta/meta.dart';

import 'log_level.dart';

@immutable
class LogRecord {
  final LogLevel level;
  final String message;
  final String tag;
  final Map<String, dynamic>? json;
  final Object? error;
  final StackTrace? stackTrace;

  const LogRecord({
    required this.level,
    required this.message,
    required this.tag,
    this.json,
    this.error,
    this.stackTrace,
  });
}
