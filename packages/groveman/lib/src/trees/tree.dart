import 'package:groveman/src/log_record.dart';

/// A tree is a destination for log messages.
abstract class Tree {
  /// Logs a [LogRecord].
  void log(LogRecord logRecord);
}
