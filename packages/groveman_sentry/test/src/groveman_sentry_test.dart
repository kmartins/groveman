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
    const TypeMatcher<Breadcrumb>()
        .having((crumb) => crumb.level?.name, 'level', level.name)
        .having((crumb) => crumb.message, 'message', message)
        .having((crumb) => crumb.data, 'data', data);

Matcher isSentryEventCalled({
  required SentryLevel level,
  required String message,
  Map<String, dynamic>? extra,
  Object? error,
  Map<String, String>? tags,
}) =>
    isA<SentryEvent>()
        .having((event) => event.level?.name, 'level', level.name)
        .having((event) => event.message?.formatted, 'message', message)
        .having((event) => event.extra, 'extra', extra)
        .having((event) => event.throwable, 'throwable', error)
        .having((event) => event.tags, 'tags', tags)
        .having((event) => event.logger, 'logger', 'groveman');

Matcher isCapturedEventCalled({
  required SentryLevel level,
  required String message,
  Map<String, dynamic>? extra,
  Object? error,
  Map<String, String>? tags,
  StackTrace? stackTrace,
}) =>
    isA<EventCall>()
        .having(
          (event) => event.sentryEvent,
          'stackTrace',
          isSentryEventCalled(
            level: level,
            message: message,
            extra: extra,
            error: error,
            tags: tags,
          ),
        )
        .having((event) => event.stackTrace, 'stackTrace', stackTrace);

void main() {
  final mockHub = MockHub();

  tearDown(() {
    mockHub.addBreadcrumbCalls.clear();
    mockHub.eventCalls.clear();
  });

  group('SentryTree', () {
    group('default levels', () {
      setUpAll(() => Groveman.plantTree(SentryTree()..setMockHub(mockHub)));
      tearDownAll(Groveman.clearAll);

      test(
          'given the default log level, '
          'when the log does not have an error, '
          'without extra and is a default level, '
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
          'with extra and is a default level, '
          'then the log is sent using addBreadcrumb '
          'only with the level, message and the extra', () {
        const message = 'message';
        const extra = {'message': 'extra', 'value': 100};

        Groveman.info(message, extra: extra);
        Groveman.warning(message, extra: extra);
        Groveman.error(message, extra: extra);
        Groveman.fatal(message, extra: extra);

        expect(mockHub.addBreadcrumbCalls.length, 4);
        expect(
            mockHub.addBreadcrumbCalls.map((add) => add.crumb).toList(),
            <Matcher>[
              isBreadcrumbCalled(
                message: message,
                data: extra,
                level: SentryLevel.info,
              ),
              isBreadcrumbCalled(
                message: message,
                data: extra,
                level: SentryLevel.warning,
              ),
              isBreadcrumbCalled(
                message: message,
                data: extra,
                level: SentryLevel.error,
              ),
              isBreadcrumbCalled(
                message: message,
                data: extra,
                level: SentryLevel.fatal,
              ),
            ]);
      });

      test(
          'given the default log level, '
          'when the log has an error, a default level, '
          'a message and without stack trace, '
          'then the log is sent to using captureEvent', () {
        const message = 'message';
        const exception = 'exception';

        Groveman.info(message, error: exception);
        Groveman.warning(message, error: exception);
        Groveman.error(message, error: exception);
        Groveman.fatal(message, error: exception);

        expect(mockHub.eventCalls.length, 4);
        expect(mockHub.eventCalls, <Matcher>[
          isCapturedEventCalled(
            level: SentryLevel.info,
            message: message,
            error: exception,
          ),
          isCapturedEventCalled(
            level: SentryLevel.warning,
            message: message,
            error: exception,
          ),
          isCapturedEventCalled(
            level: SentryLevel.error,
            message: message,
            error: exception,
          ),
          isCapturedEventCalled(
            level: SentryLevel.fatal,
            message: message,
            error: exception,
          ),
        ]);
      });

      test(
          'given the default log level, '
          'when the log has an error, default level, '
          'message, tag, extra and without stack trace, '
          'then the log is sent to using captureEvent', () {
        const message = 'message';
        const exception = 'exception';
        const extra = {'message': 'extra', 'value': 100};

        Groveman.info(
          message,
          tag: LogLevel.info.name,
          error: exception,
          extra: extra,
        );
        Groveman.warning(
          message,
          tag: LogLevel.warning.name,
          error: exception,
          extra: extra,
        );
        Groveman.error(
          message,
          tag: LogLevel.error.name,
          error: exception,
          extra: extra,
        );
        Groveman.fatal(
          message,
          tag: LogLevel.fatal.name,
          error: exception,
          extra: extra,
        );

        expect(mockHub.eventCalls.length, 4);
        expect(mockHub.eventCalls, <Matcher>[
          isCapturedEventCalled(
            level: SentryLevel.info,
            message: message,
            error: exception,
            tags: {'groveman_tag': LogLevel.info.name},
            extra: extra,
          ),
          isCapturedEventCalled(
            level: SentryLevel.warning,
            message: message,
            error: exception,
            tags: {'groveman_tag': LogLevel.warning.name},
            extra: extra,
          ),
          isCapturedEventCalled(
            level: SentryLevel.error,
            message: message,
            error: exception,
            tags: {'groveman_tag': LogLevel.error.name},
            extra: extra,
          ),
          isCapturedEventCalled(
            level: SentryLevel.fatal,
            message: message,
            error: exception,
            tags: {'groveman_tag': LogLevel.fatal.name},
            extra: extra,
          ),
        ]);
      });

      test(
          'given the default log level, '
          'when the log has an error, a default level, '
          'a message and stack trace, '
          'then the log is sent to using captureEvent', () {
        const message = 'message';
        const exception = 'exception';
        final stackTrace = StackTrace.fromString(message);

        Groveman.info(message, error: exception, stackTrace: stackTrace);
        Groveman.warning(message, error: exception, stackTrace: stackTrace);
        Groveman.error(message, error: exception, stackTrace: stackTrace);
        Groveman.fatal(message, error: exception, stackTrace: stackTrace);

        expect(mockHub.eventCalls.length, 4);
        expect(mockHub.eventCalls, <Matcher>[
          isCapturedEventCalled(
            level: SentryLevel.info,
            message: message,
            error: exception,
            stackTrace: stackTrace,
          ),
          isCapturedEventCalled(
            level: SentryLevel.warning,
            message: message,
            error: exception,
            stackTrace: stackTrace,
          ),
          isCapturedEventCalled(
            level: SentryLevel.error,
            message: message,
            error: exception,
            stackTrace: stackTrace,
          ),
          isCapturedEventCalled(
            level: SentryLevel.fatal,
            message: message,
            error: exception,
            stackTrace: stackTrace,
          ),
        ]);
      });

      test(
          'given the default log level, '
          'when debug log level is called '
          'then the log not is sent to Sentry', () {
        const message = 'message';
        const exception = 'exception';
        final stackTrace = StackTrace.fromString(message);
        const extra = {'message': 'extra', 'value': 100};

        Groveman.debug(message, extra: extra);
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
        const extra = {'message': 'extra', 'value': 100};
        Groveman.plantTree(
          SentryTree(
            logLevels: [
              LogLevel.debug,
              LogLevel.warning,
            ],
          )..setMockHub(mockHub),
        );

        Groveman
          ..debug(message, extra: extra)
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
                data: extra,
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
