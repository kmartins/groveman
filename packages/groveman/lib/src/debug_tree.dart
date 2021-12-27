import 'dart:convert';
import 'dart:developer' as developer;

import 'package:groveman/src/groveman.dart';
import 'package:groveman/src/log_level.dart';
import 'package:groveman/src/log_record.dart';
import 'package:groveman/src/util/ansi_color.dart';
import 'package:groveman/src/util/stack_trace_util.dart';

class DebugTree extends Tree {
  final bool showEmoji;
  final bool showColor;
  final bool showTag;
  final int methodCount;
  final int errorMethodCount;

  final _defaultAnsiColor = AnsiColor();
  final _defaultPrefix = '🤔';
  final _defaultLevelName = 'Debug';
  final _stackTraceUtil = StackTraceUtil();
  final _encoder = const JsonEncoder.withIndent('   ');

  final _levelName = {
    LogLevel.debug: 'Debug',
    LogLevel.info: 'Info',
    LogLevel.warning: 'Warning',
    LogLevel.error: 'Error',
    LogLevel.fatal: 'Fatal',
  };

  final _levelPrefixes = {
    LogLevel.debug: '🐛',
    LogLevel.info: '💡',
    LogLevel.warning: '🔔',
    LogLevel.error: '👾',
    LogLevel.fatal: '🔥',
  };

  final _levelColors = {
    LogLevel.debug: AnsiColor(foregroundColor: AnsiColor.grey(0.5)),
    LogLevel.info: AnsiColor(foregroundColor: 35),
    LogLevel.warning: AnsiColor(foregroundColor: 214),
    LogLevel.error: AnsiColor(foregroundColor: 196),
    LogLevel.fatal: AnsiColor(foregroundColor: 199),
  };

  DebugTree({
    this.showEmoji = false,
    this.showColor = false,
    this.showTag = true,
    this.methodCount = 2,
    this.errorMethodCount = 8,
  })  : assert(methodCount > 0),
        assert(errorMethodCount > 0);

  @override
  void log(LogRecord logRecord) {
    developer.log(
      formattedLogMessage(logRecord),
      name: formattedLogPrefix(logRecord.level),
    );
  }

  String formattedLogMessage(LogRecord logRecord) {
    final stackTrace = logRecord.stackTrace;
    final level = logRecord.level;
    final stackTraceMessage = _getStackTraceMessage(stackTrace, level);
    final ansiColor = _getAnsiColor(level);

    return _formatPrint(
      ansiColor,
      logRecord.message,
      logRecord.tag,
      logRecord.json,
      logRecord.error?.toString(),
      stackTraceMessage,
    );
  }

  String formattedLogPrefix(LogLevel level) {
    return showEmoji
        ? _levelPrefixes[level] ?? _defaultPrefix
        : _levelName[level] ?? _defaultLevelName;
  }

  String? _getStackTraceMessage(StackTrace? stackTrace, LogLevel level) {
    if (stackTrace != null) {
      if (isError(level)) {
        return _formatStackTrace(stackTrace, errorMethodCount);
      } else {
        return _formatStackTrace(stackTrace, methodCount);
      }
    }

    return null;
  }

  bool isError(LogLevel logLevel) =>
      logLevel.index == LogLevel.error.index ||
      logLevel.index == LogLevel.fatal.index;

  AnsiColor _getAnsiColor(LogLevel level) {
    return showColor
        ? _levelColors[level] ?? _defaultAnsiColor
        : _defaultAnsiColor;
  }

  String _formatStackTrace(StackTrace stackTrace, int methodCount) {
    final lines = stackTrace.toString().split('\n');
    _stackTraceUtil.discardUnnecessaryTrace(lines);
    if (methodCount > lines.length) {
      return lines.join('\n');
    }

    return lines.sublist(0, methodCount).join('\n');
  }

  String _formatLines(AnsiColor color, String value) {
    final buffer = StringBuffer();
    for (final line in value.split('\n')) {
      buffer.write('\n');
      buffer.write(color(line));
    }

    return buffer.toString();
  }

  String _formatPrint(
    AnsiColor color,
    String message,
    String tag,
    Map<String, dynamic>? json,
    String? error,
    String? stackTrace,
  ) {
    final buffer = StringBuffer();

    if (showTag) {
      buffer.write(color('[$tag]: '));
    }

    buffer.write(color(message));

    if (json != null) {
      final prettyJson = _encoder.convert(json);
      buffer.write(_formatLines(color, prettyJson));
    }

    if (error != null) {
      buffer.write('\n');
      buffer.write(color(error));
    }

    if (stackTrace != null) {
      buffer.write(_formatLines(color, stackTrace));
    }

    return buffer.toString();
  }
}
