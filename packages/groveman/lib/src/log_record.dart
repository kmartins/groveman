import 'package:groveman/src/log_level.dart';
import 'package:meta/meta.dart';

@immutable
class LogRecord {
  final LogLevel level;
  final String message;
  final String? tag;
  final Map<String, dynamic>? json;
  final Object? error;
  final StackTrace? stackTrace;

  const LogRecord({
    required this.level,
    required this.message,
    this.tag,
    this.json,
    this.error,
    this.stackTrace,
  });
}
