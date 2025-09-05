import 'dart:async';

import 'package:groveman/src/log_level.dart';
import 'package:groveman/src/log_record.dart';
import 'package:groveman/src/noop_handle_isolate_impl.dart'
    if (dart.library.io) 'package:groveman/src/handle_isolate_impl.dart';
import 'package:meta/meta.dart';

/// A logging facade.
// ignore: non_constant_identifier_names
final Groveman = _Groveman();

/// A function that handles an error from an isolate.
typedef HandleIsolateError = void Function(
  dynamic error,
);

class _Groveman {
  final Map<String, Tree> _trees = {};
  HandleIsolate _handleIsolate = HandleIsolateImpl();

  /// Plants a tree.
  void plantTree(Tree tree) {
    _trees[tree.toString()] = tree;
  }

  /// Captures an error in the current isolate.
  void captureErrorInCurrentIsolate({
    LogLevel logLevel = LogLevel.fatal,
    String tag = 'isolate',
    String message = 'Uncaught exception',
  }) {
    _handleIsolate.handleError(
      (dynamic error) => handleIsolateError(logLevel, tag, message, error),
    );
  }

  /// Captures an error in a zone.
  R? captureErrorInZone<R>(
    R Function() body, {
    Map<Object?, Object?>? zoneValues,
    ZoneSpecification? zoneSpecification,
    LogLevel logLevel = LogLevel.error,
    String tag = 'zone',
    String message = 'Uncaught exception',
  }) =>
      runZonedGuarded<R>(
        body,
        (error, stackTrace) {
          _log(logLevel, tag, message, null, error, stackTrace);
        },
        zoneValues: zoneValues,
        zoneSpecification: zoneSpecification,
      );

  /// Logs a message at the [LogLevel.debug] level.
  void debug(
    String message, {
    String? tag,
    Map<String, dynamic>? extra,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _log(LogLevel.debug, tag, message, extra, error, stackTrace);

  /// Logs a message at the [LogLevel.info] level.
  void info(
    String message, {
    String? tag,
    Map<String, dynamic>? extra,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _log(LogLevel.info, tag, message, extra, error, stackTrace);

  /// Logs a message at the [LogLevel.warning] level.
  void warning(
    String message, {
    String? tag,
    Map<String, dynamic>? extra,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _log(LogLevel.warning, tag, message, extra, error, stackTrace);

  /// Logs a message at the [LogLevel.error] level.
  void error(
    String message, {
    String? tag,
    Map<String, dynamic>? extra,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _log(LogLevel.error, tag, message, extra, error, stackTrace);

  /// Logs a message at the [LogLevel.fatal] level.
  void fatal(
    String message, {
    String? tag,
    Map<String, dynamic>? extra,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _log(LogLevel.fatal, tag, message, extra, error, stackTrace);

  void _log(
    LogLevel logLevel,
    String? tag,
    String message,
    Map<String, dynamic>? extra,
    Object? error,
    StackTrace? stackTrace,
  ) {
    for (final tree in _trees.values) {
      tree.log(
        LogRecord(
          level: logLevel,
          message: message,
          tag: tag,
          extra: extra,
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
  // ignore: use_setters_to_change_properties
  void setMockHandleIsolate(HandleIsolate handleIsolate) =>
      _handleIsolate = handleIsolate;

  @visibleForTesting
  void clearAll() => _trees.clear();
}

/// A tree is a destination for log messages.
abstract class Tree {
  /// Logs a [LogRecord].
  void log(LogRecord logRecord);
}

/// A handle to an isolate.
abstract class HandleIsolate {
  /// Handles an error from an isolate.
  void handleError(HandleIsolateError handleIsolateError);
}
