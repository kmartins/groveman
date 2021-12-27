import 'package:groveman/groveman.dart';
import 'package:test/test.dart';

void callDebug() {
  () {
    Groveman.debug('debug');
  }();
}

void callInfo() => Groveman.info('info');

void callWarning() => Groveman.warning('warning');

void callError() => Groveman.error('error');

void callFatal() => Groveman.fatal('fatal');

class AssertTree extends Tree {
  String? message;
  String? tag;
  LogLevel? level;
  Map<String, dynamic>? json;
  Object? error;
  StackTrace? stackTrace;

  @override
  void log(LogRecord logRecord) {
    message = logRecord.message;
    level = logRecord.level;
    tag = logRecord.tag;
    json = logRecord.json;
    error = logRecord.error;
    stackTrace = logRecord.stackTrace;
  }
}

class SecondAssertTree extends AssertTree {}

void main() {
  group('Groveman', () {
    const message = 'Welcome to the jungle';
    const tag = 'Jungle';
    const json = <String, Object>{
      'name': 'Jungle',
      'trees': 50,
    };
    const error = 'JungleError';
    final stackTrace = StackTrace.current;

    tearDown(() => Groveman.clearAll());

    test(
        'given none tree was planted, '
        'when any log is called, '
        'none trees are notified', () {
      final assertTree = AssertTree();
      final secondAssertTree = SecondAssertTree();

      Groveman.info(message);
      expect(assertTree.message, isNull);
      expect(secondAssertTree.message, isNull);
    });

    test(
        'given a tree planted, '
        'when DEBUG log is called, '
        'the tree is notified', () {
      final assertTree = AssertTree();
      Groveman.plantTree(assertTree);

      callDebug();
      expect(assertTree.tag, 'groveman_test-8');

      Groveman.debug(
        message,
        tag: tag,
        json: json,
        error: error,
        stackTrace: stackTrace,
      );
      expect(assertTree.level, LogLevel.debug);
      expect(assertTree.message, message);
      expect(assertTree.tag, tag);
      expect(assertTree.json, json);
      expect(assertTree.error, error);
      expect(assertTree.stackTrace, stackTrace);
    });

    test(
        'given a tree planted, '
        'when INFO log is called, '
        'the tree is notified', () {
      final assertTree = AssertTree();
      Groveman.plantTree(assertTree);

      callInfo();
      expect(assertTree.tag, 'groveman_test-12');

      Groveman.info(
        message,
        tag: tag,
        json: json,
        error: error,
        stackTrace: stackTrace,
      );
      expect(assertTree.level, LogLevel.info);
      expect(assertTree.message, message);
      expect(assertTree.tag, tag);
      expect(assertTree.json, json);
      expect(assertTree.error, error);
      expect(assertTree.stackTrace, stackTrace);
    });

    test(
        'given a tree planted, '
        'when WARNING log is called, '
        'the tree is notified', () {
      final assertTree = AssertTree();
      Groveman.plantTree(assertTree);

      callWarning();
      expect(assertTree.tag, 'groveman_test-14');

      Groveman.warning(
        message,
        tag: tag,
        json: json,
        error: error,
        stackTrace: stackTrace,
      );
      expect(assertTree.level, LogLevel.warning);
      expect(assertTree.message, message);
      expect(assertTree.tag, tag);
      expect(assertTree.json, json);
      expect(assertTree.error, error);
      expect(assertTree.stackTrace, stackTrace);
    });

    test(
        'given a tree planted, '
        'when ERROR log is called, '
        'then the tree is notified', () {
      final assertTree = AssertTree();
      Groveman.plantTree(assertTree);

      callError();
      expect(assertTree.tag, 'groveman_test-16');

      Groveman.error(
        message,
        tag: tag,
        json: json,
        error: error,
        stackTrace: stackTrace,
      );
      expect(assertTree.level, LogLevel.error);
      expect(assertTree.message, message);
      expect(assertTree.tag, tag);
      expect(assertTree.json, json);
      expect(assertTree.error, error);
      expect(assertTree.stackTrace, stackTrace);
    });

    test(
        'given a tree planted, '
        'when FATAL log is called, '
        'then the tree is notified', () {
      final assertTree = AssertTree();
      Groveman.plantTree(assertTree);

      callFatal();
      expect(assertTree.tag, 'groveman_test-18');

      Groveman.fatal(
        message,
        tag: tag,
        json: json,
        error: error,
        stackTrace: stackTrace,
      );
      expect(assertTree.level, LogLevel.fatal);
      expect(assertTree.message, message);
      expect(assertTree.tag, tag);
      expect(assertTree.json, json);
      expect(assertTree.error, error);
      expect(assertTree.stackTrace, stackTrace);
    });

    test(
        'given a tree already planted, '
        'when trying plant the same tree, '
        'then only last tree is planted', () {
      final assertTree = AssertTree();
      final assertTree2 = AssertTree();
      Groveman.plantTree(assertTree);
      Groveman.plantTree(assertTree2);

      Groveman.info(message);
      expect(assertTree.message, isNull);
      expect(assertTree2.message, message);
    });

    test(
        'given 2 trees planted, '
        'when any log is called, '
        'all the trees are notified', () {
      final assertTree = AssertTree();
      final secondAssertTree = SecondAssertTree();
      Groveman.plantTree(assertTree);
      Groveman.plantTree(secondAssertTree);

      Groveman.info(message);
      expect(assertTree.message, message);
      expect(secondAssertTree.message, message);
    });

    test(
        'given 2 trees planted, '
        'when cutting off all the trees, '
        'none trees are notified', () {
      final assertTree = AssertTree();
      final secondAssertTree = SecondAssertTree();
      Groveman.plantTree(assertTree);
      Groveman.plantTree(secondAssertTree);

      Groveman.clearAll();
      Groveman.info(message);
      expect(assertTree.message, isNull);
      expect(secondAssertTree.message, isNull);
    });

    test(
        'given a zone, '
        'when threw an uncaught exception, '
        'then the result is a log with an error and exception', () {
      final assertTree = AssertTree();
      const error = 'Error';
      Groveman.plantTree(assertTree);

      Groveman.captureErrorInZone(() => throw error);
      expect(assertTree.level, LogLevel.error);
      expect(assertTree.message, 'Uncaught exception');
      expect(assertTree.tag, 'zone');
      expect(assertTree.error, error);
      expect(assertTree.stackTrace.toString(), contains('main'));

      Groveman.captureErrorInZone(
        () => throw error,
        logLevel: LogLevel.fatal,
        message: 'Fatal',
        tag: 'Zone',
      );
      expect(assertTree.level, LogLevel.fatal);
      expect(assertTree.tag, 'Zone');
      expect(assertTree.message, 'Fatal');
    });

    test(
        'given a current isolate, '
        'when threw an uncaught exception, '
        'then the result is a log with an error and exception', () {
      final assertTree = AssertTree();
      final exception = StateError('error');
      final stackTrace = StackTrace.current;
      final error = [exception, stackTrace];
      Groveman.plantTree(assertTree);
      Groveman.captureErrorInCurrentIsolate();

      Groveman.handleIsolateError(
        LogLevel.fatal,
        'Isolate',
        'Uncaught exception',
        error,
      );
      expect(assertTree.level, LogLevel.fatal);
      expect(assertTree.tag, 'Isolate');
      expect(assertTree.message, 'Uncaught exception');
      expect(assertTree.error, exception);
      expect(assertTree.stackTrace, stackTrace);
    });
  });
}
