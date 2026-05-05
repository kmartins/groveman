import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:groveman/groveman.dart';
import 'package:groveman_crashlytics/groveman_crashlytics.dart';

import '../mock.dart';
import '../utils.dart';

void main() {
  setupFirebaseCrashlyticsMocks();

  setUpAll(Firebase.initializeApp);

  tearDown(() {
    Groveman.clearAll();
    methodCallLog.clear();
  });

  group('GrovemanCrashlytics', () {
    test(
        'given the default log level, '
        'when the log does not have an error and is a default level, '
        'then the log is sent to Crashlytics.log', () {
      const message = 'message';
      Groveman.plantTree(CrashlyticsTree());

      Groveman.info(message);
      Groveman.warning(message);
      Groveman.error(message);
      Groveman.fatal(message);

      final matcher =
          isMethodCall('Crashlytics#log', arguments: {'message': message});
      expect(methodCallLog, <Matcher>[
        matcher,
        matcher,
        matcher,
        matcher,
      ]);
    });

    test(
        'given the default log level, '
        'when the log has an error and is a default level, '
        'then the log is sent to Crashlytics.recordError', () {
      const message = 'message';
      const exception = 'exception';
      final stack = StackTrace.current;
      Groveman.plantTree(CrashlyticsTree());

      Groveman.info(message, error: exception, stackTrace: stack);
      Groveman.warning(message, error: exception, stackTrace: stack);
      Groveman.error(message, error: exception, stackTrace: stack);

      final matcher = isMethodCall(
        'Crashlytics#recordError',
        arguments: {
          'exception': exception,
          'reason': message,
          'information': '',
          'fatal': false,
          'stackTraceElements': getStackTraceElements(stack),
          'buildId': '',
          'loadingUnits': [],
        },
      );

      expect(methodCallLog, <Matcher>[
        matcher,
        matcher,
        matcher,
      ]);
    });

    test(
        'given the default log level, '
        'when the log has an error and is fatal, '
        'then the log is sent to Crashlytics.record as fatal', () {
      const message = 'message';
      const exception = 'exception';
      final stack = StackTrace.current;
      Groveman.plantTree(CrashlyticsTree());

      Groveman.fatal(message, error: exception, stackTrace: stack);
      expect(
        methodCallLog,
        <Matcher>[
          isMethodCall(
            'Crashlytics#recordError',
            arguments: {
              'exception': exception,
              'reason': message,
              'information': '',
              'fatal': true,
              'stackTraceElements': getStackTraceElements(stack),
              'buildId': '',
              'loadingUnits': [],
            },
          ),
        ],
      );
    });

    test(
        'given the default log level, '
        'when debug log level is called '
        'then the log not is sent to Crashlytics', () {
      const message = 'message';
      Groveman.plantTree(CrashlyticsTree());

      Groveman.debug(message);
      expect(methodCallLog, []);
    });

    test(
        'given the custom log level, '
        'when one theses log is called '
        'then the log is sent to Crashlytics.log', () {
      const message = 'message';
      const message2 = 'message2';
      const exception = 'exception';
      final stack = StackTrace.current;
      Groveman.plantTree(
        CrashlyticsTree(
          logLevels: [
            LogLevel.debug,
            LogLevel.warning,
            LogLevel.info,
          ],
        ),
      );

      Groveman
        ..debug(message)
        ..warning(message)
        ..warning(message2)
        ..info(message, error: exception, stackTrace: stack)
        ..error(message);

      expect(methodCallLog, <Matcher>[
        isMethodCall('Crashlytics#log', arguments: {'message': message}),
        isMethodCall('Crashlytics#log', arguments: {'message': message}),
        isMethodCall('Crashlytics#log', arguments: {'message': message2}),
        isMethodCall(
          'Crashlytics#recordError',
          arguments: {
            'exception': exception,
            'reason': message,
            'information': '',
            'fatal': false,
            'stackTraceElements': getStackTraceElements(stack),
            'buildId': '',
            'loadingUnits': [],
          },
        ),
      ]);
    });

    test(
        'given the custom log level, '
        'when none log level is passed '
        'then the result is an assert error', () {
      expect(() => CrashlyticsTree(logLevels: []), throwsAssertionError);
    });
  });

  group('IdentifierTree', () {
    late CrashlyticsTree crashlyticsTree;

    setUp(() {
      crashlyticsTree = CrashlyticsTree();
      Groveman.plantTree(crashlyticsTree);
    });

    tearDown(() {
      Groveman.clearAll();
      methodCallLog.clear();
    });

    test(
        'given a user identifier, '
        'when setUserIdentifier is called, '
        'then the user is sent to Crashlytics', () {
      final user = UserIdentifier(id: '123');

      Groveman.setUserIdentifier(user);

      expect(
        methodCallLog,
        contains(
          isMethodCall(
            'Crashlytics#setUserIdentifier',
            arguments: {'identifier': '123'},
          ),
        ),
      );
    });

    test(
        'given a previously set user, '
        'when clearUserIdentifier is called, '
        'then the user is cleared in Crashlytics', () {
      Groveman.clearUserIdentifier();
      expect(
        methodCallLog,
        contains(
          isMethodCall(
            'Crashlytics#setUserIdentifier',
            arguments: {'identifier': ''},
          ),
        ),
      );
    });

    test(
        'given custom context and tags, '
        'when setIdentifiers is called, '
        'then tags are sent to Crashlytics as custom keys', () {
      const tags = {'tag': 'value', 'number': 1};

      crashlyticsTree.setIdentifiers(tags: tags);
      expect(crashlyticsTree.context, isEmpty);
      expect(crashlyticsTree.tags, tags);
      expect(methodCallLog, <Matcher>[
        isA<MethodCall>()
            .having((c) => c.method, 'method', 'Crashlytics#setCustomKey')
            .having(
                (c) => c.arguments,
                'arguments',
                allOf(containsPair('key', 'tag'),
                    containsPair('value', 'value'))),
        isA<MethodCall>()
            .having((c) => c.method, 'method', 'Crashlytics#setCustomKey')
            .having(
                (c) => c.arguments,
                'arguments',
                allOf(
                    containsPair('key', 'number'), containsPair('value', '1'))),
      ]);
    });

    test(
        'given existing identifiers, '
        'when clearIdentifiers is called with context keys, '
        'then those keys are cleared in Crashlytics', () {
      crashlyticsTree
          .setIdentifiers(context: {'key1': 'value1', 'key2': 'value2'});
      crashlyticsTree.clearIdentifiers(contextKeys: ['key1']);
      expect(crashlyticsTree.context, isEmpty);
      expect(crashlyticsTree.tags, isEmpty);
      expect(methodCallLog, isEmpty);
    });

    test(
        'given existing identifiers, '
        'when clearIdentifiers is called with tag keys, '
        'then those keys are cleared in Crashlytics', () {
      crashlyticsTree.setIdentifiers(tags: {'key1': 'value1'});
      crashlyticsTree.clearIdentifiers(tagKeys: ['key1']);
      expect(crashlyticsTree.context, isEmpty);
      expect(crashlyticsTree.tags, isEmpty);
      expect(methodCallLog, <Matcher>[
        isMethodCall(
          'Crashlytics#setCustomKey',
          arguments: {'key': 'key1', 'value': 'value1'},
        ),
        isMethodCall(
          'Crashlytics#setCustomKey',
          arguments: {'key': 'key1', 'value': ''},
        ),
      ]);
    });

    test(
        'given existing identifiers, '
        'when clearAll is called, '
        'then user is cleared and all tags are cleared in Crashlytics', () {
      crashlyticsTree.setIdentifiers(tags: {'tag': 'value'});
      methodCallLog.clear();

      crashlyticsTree.clearAll();

      expect(crashlyticsTree.context, isEmpty);
      expect(crashlyticsTree.tags, isEmpty);
      expect(methodCallLog, <Matcher>[
        isMethodCall(
          'Crashlytics#setUserIdentifier',
          arguments: {'identifier': ''},
        ),
        isMethodCall(
          'Crashlytics#setCustomKey',
          arguments: {'key': 'tag', 'value': ''},
        ),
      ]);
    });
  });
}
