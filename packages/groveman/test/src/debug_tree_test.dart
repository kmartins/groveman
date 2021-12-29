import 'dart:convert';

import 'package:groveman/groveman.dart';
import 'package:groveman/src/util/stack_trace_util.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockDebugTree extends Mock implements DebugTree {}

class FakeLogRecord extends Fake implements LogRecord {}

void main() {
  const tag = 'Test';
  const message = 'Jungle';
  const error = 'Error';
  const json = <String, Object>{
    'name': 'Jungle',
    'trees': 50,
  };

  group('DebugTree', () {
    setUpAll(() {
      registerFallbackValue(FakeLogRecord());
    });

    test(
        'given that the stackTrace is bigger 1, '
        'when the tree is created with a methodCount or '
        'errorMethodCount smaller than 1, '
        'then the result is an assert error', () {
      expect(() => DebugTree(methodCount: 0), throwsA(isA<AssertionError>()));
      expect(
        () => DebugTree(errorMethodCount: 0),
        throwsA(isA<AssertionError>()),
      );
    });

    test(
        'given that the log has level with text, '
        'when to get prefix, '
        'then the result is a text with the type of the log level', () {
      final debugTree = DebugTree();
      expect(debugTree.formattedLogPrefix(LogLevel.debug), 'Debug');
      expect(debugTree.formattedLogPrefix(LogLevel.info), 'Info');
      expect(debugTree.formattedLogPrefix(LogLevel.warning), 'Warning');
      expect(debugTree.formattedLogPrefix(LogLevel.error), 'Error');
      expect(debugTree.formattedLogPrefix(LogLevel.fatal), 'Fatal');
    });

    test(
        'given that the log has level with emoji, '
        'when to get prefix, '
        'then the result is a emoji with the type of the log level', () {
      final debugTree = DebugTree(showEmoji: true);
      expect(debugTree.formattedLogPrefix(LogLevel.debug), '🐛');
      expect(debugTree.formattedLogPrefix(LogLevel.info), '💡');
      expect(debugTree.formattedLogPrefix(LogLevel.warning), '🔔');
      expect(debugTree.formattedLogPrefix(LogLevel.error), '👾');
      expect(debugTree.formattedLogPrefix(LogLevel.fatal), '🔥');
    });

    test(
        'given that the log has a color, '
        'when the log message is formatted, '
        'then the result is a text with the color of level', () {
      final debugTree = DebugTree(showTag: false, showColor: true);
      const logRecord =
          LogRecord(level: LogLevel.error, message: message, tag: tag);
      expect(
        debugTree.formattedLogMessage(logRecord),
        '\x1B[38;5;${196}m$message',
      );
    });

    test(
        'given that the log has message, but not tag, '
        'when the log message is formatted, '
        'then the result is message', () {
      final debugTree = DebugTree(showTag: false);
      const logRecord =
          LogRecord(level: LogLevel.debug, message: message, tag: tag);
      expect(debugTree.formattedLogMessage(logRecord), message);
    });

    test(
        'given that the log has tag and message, '
        'when the log message is formatted, '
        'then the result is [tag]: message', () {
      final debugTree = DebugTree();
      const logRecord =
          LogRecord(level: LogLevel.debug, message: message, tag: tag);
      expect(debugTree.formattedLogMessage(logRecord), '[$tag]: $message');
    });

    test(
        'given that the log has message and without tag, '
        'when the log message is formatted, '
        'then the result is the tag with name file '
        'and line number of the first item stack ', () {
      final debugTree = DebugTree();
      const logRecord = LogRecord(level: LogLevel.debug, message: message);
      expect(
        debugTree.formattedLogMessage(logRecord),
        '[debug_tree_test-103]: $message',
      );
    });

    test(
        'given that the log is a debug and '
        'has tag, message, stack trace the method count is 1 '
        'when the log message is formatted, '
        'then the result is [tag]: message stackTrace(1)', () {
      final debugTree = DebugTree(methodCount: 1);
      final stackTrace = StackTrace.current;
      final stackTraceList = stackTrace.toString().split('\n');
      StackTraceUtil().discardUnnecessaryTrace(stackTraceList);
      final stackTraceMessage = stackTraceList.sublist(0, 1).join('\n');
      final logRecord = LogRecord(
        level: LogLevel.debug,
        message: message,
        tag: tag,
        stackTrace: stackTrace,
      );
      expect(
        debugTree.formattedLogMessage(logRecord),
        '[$tag]: $message\n$stackTraceMessage',
      );
    });

    test(
        'given that the log is a error and '
        'has tag, message, json, error, stack trace '
        'and the error method count is 1 '
        'when the log message is formatted, '
        'then the result is [tag]: message json error stackTrace(1)', () {
      final debugTree = DebugTree(errorMethodCount: 1);
      const encoder = JsonEncoder.withIndent('   ');
      final stackTrace = StackTrace.current;
      final stackTraceList = stackTrace.toString().split('\n');
      StackTraceUtil().discardUnnecessaryTrace(stackTraceList);
      final stackTraceMessage = stackTraceList.sublist(0, 1).join('\n');
      final logRecord = LogRecord(
        level: LogLevel.error,
        message: message,
        tag: tag,
        json: json,
        error: error,
        stackTrace: stackTrace,
      );
      expect(
        debugTree.formattedLogMessage(logRecord),
        '[$tag]: $message\n${encoder.convert(json)}'
        '\n$error\n$stackTraceMessage',
      );
    });

    test(
        'given that the log is a fatal and '
        'has tag, message, json, error, stack trace '
        'and the error method count is 2 '
        'when the log message is formatted, '
        'then the result is [tag]: message json error stackTrace(2)', () {
      final debugTree = DebugTree(errorMethodCount: 2);
      const encoder = JsonEncoder.withIndent('   ');
      final stackTrace = StackTrace.current;
      final stackTraceList = stackTrace.toString().split('\n');
      StackTraceUtil().discardUnnecessaryTrace(stackTraceList);
      final stackTraceMessage = stackTraceList.sublist(0, 2).join('\n');
      final logRecord = LogRecord(
        level: LogLevel.fatal,
        message: message,
        tag: tag,
        json: json,
        error: error,
        stackTrace: stackTrace,
      );
      expect(
        debugTree.formattedLogMessage(logRecord),
        '[$tag]: $message\n${encoder.convert(json)}'
        '\n$error\n$stackTraceMessage',
      );
    });

    test(
        'given that the log is a debug and '
        'has tag, message and the method count is  '
        'bigger than stack trace lines when the log message is formatted, '
        'then the result is [tag]: message json error stackTrace(entire)', () {
      final debugTree = DebugTree(methodCount: 100);
      final stackTrace = StackTrace.current;
      final stackTraceList = stackTrace.toString().split('\n');
      StackTraceUtil().discardUnnecessaryTrace(stackTraceList);
      final stackTraceMessage = stackTraceList.join('\n');
      final logRecord = LogRecord(
        level: LogLevel.debug,
        message: message,
        tag: tag,
        stackTrace: stackTrace,
      );
      expect(
        debugTree.formattedLogMessage(logRecord),
        '[$tag]: $message\n$stackTraceMessage',
      );
    });

    test(
        'when the groveman throwing a log, '
        'then the debug tree receive this log', () {
      final mockDebugTree = MockDebugTree();
      final debugTree = DebugTree();
      Groveman.plantTree(mockDebugTree);
      Groveman.plantTree(debugTree);
      const logRecord =
          LogRecord(level: LogLevel.debug, message: message, tag: tag);
      when(() => mockDebugTree.log(logRecord)).thenReturn(null);
      Groveman.debug(message, tag: tag);
      final captured = verify(() => mockDebugTree.log(captureAny())).captured;
      final logRecordCaptured = captured.last as LogRecord;
      expect(logRecordCaptured.message, message);
      expect(logRecordCaptured.level, LogLevel.debug);
      expect(logRecordCaptured.tag, tag);
    });
  });
}
