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

class AssertTree extends Tree with IdentifierTree {
  String? message;
  String? tag;
  LogLevel? level;
  Map<String, dynamic>? extra;
  Object? error;
  StackTrace? stackTrace;
  UserIdentifier? userIdentifier;

  @override
  void log(LogRecord logRecord) {
    message = logRecord.message;
    level = logRecord.level;
    tag = logRecord.tag;
    extra = logRecord.extra;
    error = logRecord.error;
    stackTrace = logRecord.stackTrace;
  }

  @override
  void clearUser() => userIdentifier = null;

  @override
  void setUser(UserIdentifier userIdentifier) =>
      this.userIdentifier = userIdentifier;

  @override
  void setIdentifiers(
      {Map<String, dynamic> context = const {},
      Map<String, Object> tags = const {}}) {
    this.tags.addAll(tags);
    this.context.addAll(context);
  }

  @override
  void clearAll({bool isReset = false}) {
    tags.clear();
    context.clear();
    if (isReset) {
      userIdentifier = null;
    }
  }

  @override
  void clearIdentifiers(
      {List<String> contextKeys = const [], List<String> tagKeys = const []}) {
    tagKeys.forEach(tags.remove);
    contextKeys.forEach(context.remove);
  }
}

class SecondAssertTree extends AssertTree {}

void main() {
  group('Groveman', () {
    const message = 'Welcome to the jungle';
    const tag = 'Jungle';
    const extra = <String, Object>{
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
      expect(assertTree.tag, isNull);

      Groveman.debug(
        message,
        tag: tag,
        extra: extra,
        error: error,
        stackTrace: stackTrace,
      );
      expect(assertTree.level, LogLevel.debug);
      expect(assertTree.message, message);
      expect(assertTree.tag, tag);
      expect(assertTree.extra, extra);
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
      expect(assertTree.tag, isNull);

      Groveman.info(
        message,
        tag: tag,
        extra: extra,
        error: error,
        stackTrace: stackTrace,
      );
      expect(assertTree.level, LogLevel.info);
      expect(assertTree.message, message);
      expect(assertTree.tag, tag);
      expect(assertTree.extra, extra);
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
      expect(assertTree.tag, isNull);

      Groveman.warning(
        message,
        tag: tag,
        extra: extra,
        error: error,
        stackTrace: stackTrace,
      );
      expect(assertTree.level, LogLevel.warning);
      expect(assertTree.message, message);
      expect(assertTree.tag, tag);
      expect(assertTree.extra, extra);
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
      expect(assertTree.tag, isNull);

      Groveman.error(
        message,
        tag: tag,
        extra: extra,
        error: error,
        stackTrace: stackTrace,
      );
      expect(assertTree.level, LogLevel.error);
      expect(assertTree.message, message);
      expect(assertTree.tag, tag);
      expect(assertTree.extra, extra);
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
      expect(assertTree.tag, isNull);

      Groveman.fatal(
        message,
        tag: tag,
        extra: extra,
        error: error,
        stackTrace: stackTrace,
      );
      expect(assertTree.level, LogLevel.fatal);
      expect(assertTree.message, message);
      expect(assertTree.tag, tag);
      expect(assertTree.extra, extra);
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
        'given a planted tree, when user identifier is updated or cleared, '
        'then the tree should reflect those changes', () {
      final assertTree = AssertTree();
      Groveman.plantTree(assertTree);

      Groveman.setUserIdentifier(UserIdentifier(id: '123456'));
      expect(assertTree.userIdentifier?.id, '123456');
      Groveman.setUserIdentifier(UserIdentifier(id: '1'));
      expect(assertTree.userIdentifier?.id, '1');
      Groveman.clearUserIdentifier();
      expect(assertTree.userIdentifier, isNull);
    });

    test(
        'given a planted tree, '
        'when setIdentifiers is called, '
        'then the tree should have the context and tags', () {
      final assertTree = AssertTree();
      Groveman.plantTree(assertTree);

      const context = {'key': 'value'};
      const tags = {'tag': 'value'};
      Groveman.setIdentifiers(context: context, tags: tags);

      expect(assertTree.context, context);
      expect(assertTree.tags, tags);
    });

    test(
        'given a planted tree with identifiers, '
        'when clearIdentifiers is called, '
        'then the tree should have the identifiers cleared', () {
      final assertTree = AssertTree();
      Groveman.plantTree(assertTree);

      Groveman.setIdentifiers(
        context: {'key1': 'value1', 'key2': 'value2'},
        tags: {'tag1': 'value1', 'tag2': 'value2'},
      );
      Groveman.clearIdentifiers(contextKeys: ['key1'], tagKeys: ['tag1']);

      expect(assertTree.context, {'key2': 'value2'});
      expect(assertTree.tags, {'tag2': 'value2'});
    });

    test(
        'given a planted tree with identifiers, '
        'when clearAllIdentifiers is called with isReset as false, '
        'then the tree should have the identifiers cleared but not the user',
        () {
      final assertTree = AssertTree();
      Groveman.plantTree(assertTree);

      Groveman.setUserIdentifier(UserIdentifier(id: '123456'));
      Groveman.setIdentifiers(
          context: {'key': 'value'}, tags: {'tag': 'value'});
      Groveman.clearAllIdentifiers();

      expect(assertTree.context, isEmpty);
      expect(assertTree.tags, isEmpty);
      expect(assertTree.userIdentifier, isNotNull);
    });

    test(
        'given a planted tree with identifiers, '
        'when clearAllIdentifiers is called with isReset as true, '
        'then the tree should have all identifiers and user cleared', () {
      final assertTree = AssertTree();
      Groveman.plantTree(assertTree);

      Groveman.setUserIdentifier(UserIdentifier(id: '123456'));
      Groveman.setIdentifiers(
          context: {'key': 'value'}, tags: {'tag': 'value'});
      Groveman.clearAllIdentifiers(isReset: true);

      expect(assertTree.context, isEmpty);
      expect(assertTree.tags, isEmpty);
      expect(assertTree.userIdentifier, isNull);
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
      final handleIsolateMock = HandleIsolateMock();
      Groveman.plantTree(assertTree);
      Groveman.setMockHandleIsolate(handleIsolateMock);
      Groveman.captureErrorInCurrentIsolate();

      handleIsolateMock.callError(error);

      expect(assertTree.level, LogLevel.fatal);
      expect(assertTree.tag, 'isolate');
      expect(assertTree.message, 'Uncaught exception');
      expect(assertTree.error, exception);
      expect(assertTree.stackTrace, stackTrace);
    });
  });
}

class HandleIsolateMock extends HandleIsolate {
  HandleIsolateError? _handleIsolateError;

  @override
  void handleError(HandleIsolateError handleIsolateError) =>
      _handleIsolateError = handleIsolateError;

  void callError(dynamic error) => _handleIsolateError?.call(error);
}
