import 'package:firebase_core/firebase_core.dart';
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
}
