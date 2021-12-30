import 'dart:async';
import 'dart:isolate';

import 'package:groveman/src/log_level.dart';
import 'package:groveman/src/log_record.dart';
import 'package:meta/meta.dart';

// ignore: non_constant_identifier_names
final Groveman = _Groveman();

class _Groveman {
  final Map<String, Tree> _trees = {};

  void plantTree(Tree tree) {
    _trees[tree.toString()] = tree;
  }

  void captureErrorInCurrentIsolate({
    LogLevel logLevel = LogLevel.fatal,
    String tag = 'isolate',
    String message = 'Uncaught exception',
  }) {
    Isolate.current.addErrorListener(
      RawReceivePort(
        (pair) => handleIsolateError(logLevel, tag, message, error),
      ).sendPort,
    );
  }

  R? captureErrorInZone<R>(
    R Function() body, {
    Map<Object?, Object?>? zoneValues,
    ZoneSpecification? zoneSpecification,
    LogLevel logLevel = LogLevel.error,
    String tag = 'zone',
    String message = 'Uncaught exception',
  }) {
    runZonedGuarded<R>(
      body,
      (error, stackTrace) {
        _log(logLevel, tag, message, null, error, stackTrace);
      },
      zoneValues: zoneValues,
      zoneSpecification: zoneSpecification,
    );
  }

  void debug(
    String message, {
    String? tag,
    Map<String, dynamic>? json,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _log(LogLevel.debug, tag, message, json, error, stackTrace);

  void info(
    String message, {
    String? tag,
    Map<String, dynamic>? json,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _log(LogLevel.info, tag, message, json, error, stackTrace);

  void warning(
    String message, {
    String? tag,
    Map<String, dynamic>? json,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _log(LogLevel.warning, tag, message, json, error, stackTrace);

  void error(
    String message, {
    String? tag,
    Map<String, dynamic>? json,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _log(LogLevel.error, tag, message, json, error, stackTrace);

  void fatal(
    String message, {
    String? tag,
    Map<String, dynamic>? json,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _log(LogLevel.fatal, tag, message, json, error, stackTrace);

  void _log(
    LogLevel logLevel,
    String? tag,
    String message,
    Map<String, dynamic>? json,
    Object? error,
    StackTrace? stackTrace,
  ) {
    for (final tree in _trees.values) {
      tree.log(
        LogRecord(
          level: logLevel,
          message: message,
          tag: tag,
          json: json,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @visibleForTesting
  void handleIsolateError(
    LogLevel logLevel,
    String? tag,
    String message,
    dynamic error,
  ) {
    if (error is List<dynamic> && error.length == 2) {
      final exception = error.first;
      final stackTrace = error.last as StackTrace;

      _log(logLevel, tag, message, null, exception, stackTrace);
    }
  }

  @visibleForTesting
  void clearAll() => _trees.clear();
}

abstract class Tree {
  void log(LogRecord logRecord);
}
