import 'package:groveman/groveman.dart';
import 'package:groveman_sentry/groveman_sentry.dart';
import 'package:sentry/sentry.dart';
import 'package:test/test.dart';

import 'mock_hub.dart';

Matcher isBreadcrumbCalled({
  required SentryLevel level,
  required String message,
  Map<String, dynamic>? data,
}) =>
    isA<Breadcrumb>()
      ..having((crumb) => crumb.level, 'level', level)
      ..having((crumb) => crumb.message, 'message', message)
      ..having((crumb) => crumb.level, 'data', data);

Matcher isCapturedExceptionCalled({
  required Object error,
  StackTrace? stackTrace,
}) =>
    isA<CaptureExceptionCall>()
      ..having((captured) => captured.throwable, 'throwable', error)
      ..having((captured) => captured.stackTrace, 'stackTrace', stackTrace);

void main() {
  final mockHub = MockHub();

  tearDown(() {
    mockHub.addBreadcrumbCalls.clear();
    mockHub.captureExceptionCalls.clear();
  });

  group('SentryTree', () {
    group('default levels', () {
      setUp(() => Groveman.plantTree(SentryTree()..hub = mockHub));
      tearDownAll(Groveman.clearAll);

      test(
          'given the default log level, '
          'when the log does not have an error, '
          'without json and is a default level, '
          'then the log is sent using addBreadcrumb '
          'only with the level and the message', () {
        const message = 'message';

        Groveman.info(message);
        Groveman.warning(message);
        Groveman.error(message);
        Groveman.fatal(message);

        expect(mockHub.addBreadcrumbCalls.length, 4);
        expect(
            mockHub.addBreadcrumbCalls.map((add) => add.crumb).toList(),
            <Matcher>[
              isBreadcrumbCalled(message: message, level: SentryLevel.info),
              isBreadcrumbCalled(message: message, level: SentryLevel.warning),
              isBreadcrumbCalled(message: message, level: SentryLevel.error),
              isBreadcrumbCalled(message: message, level: SentryLevel.fatal),
            ]);
      });

      test(
          'given the default log level, '
          'when the log does not have an error, '
          'with json and is a default level, '
          'then the log is sent using addBreadcrumb '
          'only with the level, message and the json', () {
        const message = 'message';
        const json = {'message': 'json', 'value': 100};

        Groveman.info(message, json: json);
        Groveman.warning(message, json: json);
        Groveman.error(message, json: json);
        Groveman.fatal(message, json: json);

        expect(mockHub.addBreadcrumbCalls.length, 4);
        expect(
            mockHub.addBreadcrumbCalls.map((add) => add.crumb).toList(),
            <Matcher>[
              isBreadcrumbCalled(
                message: message,
                data: json,
                level: SentryLevel.info,
              ),
              isBreadcrumbCalled(
                message: message,
                data: json,
                level: SentryLevel.warning,
              ),
              isBreadcrumbCalled(
                message: message,
                data: json,
                level: SentryLevel.error,
              ),
              isBreadcrumbCalled(
                message: message,
                data: json,
                level: SentryLevel.fatal,
              ),
            ]);
      });

      test(
          'given the default log level, '
          'when the log has an error, without '
          'stack trace and is a default level, '
          'then the log is sent to using captureException '
          'only with the error', () {
        const message = 'message';
        const exception = 'exception';

        Groveman.info(message, error: exception);
        Groveman.warning(message, error: exception);
        Groveman.error(message, error: exception);
        Groveman.fatal(message, error: exception);

        expect(mockHub.captureExceptionCalls.length, 4);
        expect(mockHub.captureExceptionCalls, <Matcher>[
          isCapturedExceptionCalled(error: exception),
          isCapturedExceptionCalled(error: exception),
          isCapturedExceptionCalled(error: exception),
          isCapturedExceptionCalled(error: exception),
        ]);
      });

      test(
          'given the default log level, '
          'when the log has an error, tack trace and is a default level, '
          'then the log is sent to using captureException '
          'only with the error', () {
        const message = 'message';
        const exception = 'exception';
        final stackTrace = StackTrace.fromString(message);

        Groveman.info(message, error: exception, stackTrace: stackTrace);
        Groveman.warning(message, error: exception, stackTrace: stackTrace);
        Groveman.error(message, error: exception, stackTrace: stackTrace);
        Groveman.fatal(message, error: exception, stackTrace: stackTrace);

        expect(mockHub.captureExceptionCalls.length, 4);
        expect(mockHub.captureExceptionCalls, <Matcher>[
          isCapturedExceptionCalled(error: exception, stackTrace: stackTrace),
          isCapturedExceptionCalled(error: exception, stackTrace: stackTrace),
          isCapturedExceptionCalled(error: exception, stackTrace: stackTrace),
          isCapturedExceptionCalled(error: exception, stackTrace: stackTrace),
        ]);
      });

      test(
          'given the default log level, '
          'when debug log level is called '
          'then the log not is sent to Sentry', () {
        const message = 'message';
        const exception = 'exception';
        final stackTrace = StackTrace.fromString(message);
        const json = {'message': 'json', 'value': 100};

        Groveman.debug(message, json: json);
        Groveman.debug(message);
        Groveman.debug(message, error: exception);
        Groveman.debug(message, error: exception, stackTrace: stackTrace);
        expect(mockHub.addBreadcrumbCalls, []);
      });
    });

    group('custom levels', () {
      tearDown(Groveman.clearAll);
      test(
          'given the custom log level, '
          'when one theses log is called '
          'then the log is sent using addBreadcrumb', () {
        const message = 'message';
        const message2 = 'message2';
        const json = {'message': 'json', 'value': 100};
        Groveman.plantTree(
          SentryTree(
            logLevels: [
              LogLevel.debug,
              LogLevel.warning,
            ],
          )..hub = mockHub,
        );

        Groveman
          ..debug(message, json: json)
          ..warning(message)
          ..warning(message2)
          ..info(message)
          ..error(message);

        expect(mockHub.addBreadcrumbCalls.length, 3);
        expect(
            mockHub.addBreadcrumbCalls.map((add) => add.crumb).toList(),
            <Matcher>[
              isBreadcrumbCalled(
                message: message,
                data: json,
                level: SentryLevel.debug,
              ),
              isBreadcrumbCalled(message: message, level: SentryLevel.warning),
              isBreadcrumbCalled(message: message2, level: SentryLevel.warning),
            ]);
      });

      test(
          'given the custom log level, '
          'when none log level is passed '
          'then the result is an assert error', () {
        expect(() => SentryTree(logLevels: []), throwsA(isA<AssertionError>()));
      });
    });
  });
}
