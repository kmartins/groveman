import 'package:groveman/groveman.dart';
import 'package:test/test.dart';

void main() {
  group('LogLevelInterceptor', () {
    const message = 'test message';

    test(
        'given a level in the allowed list, '
        'when the record is intercepted, '
        'then the original record is returned unchanged', () {
      const interceptor = LogLevelInterceptor([LogLevel.warning]);
      const record = LogRecord(level: LogLevel.warning, message: message);

      final result = interceptor.intercept(record);

      expect(identical(result, record), isTrue);
    });

    test(
        'given a level not in the allowed list, '
        'when the record is intercepted, '
        'then null is returned', () {
      const interceptor = LogLevelInterceptor([LogLevel.error]);
      const record = LogRecord(level: LogLevel.debug, message: message);

      expect(interceptor.intercept(record), isNull);
    });

    test(
        'given multiple allowed levels, '
        'when records with those levels are intercepted, '
        'then all pass through', () {
      const interceptor = LogLevelInterceptor(
        [LogLevel.warning, LogLevel.error, LogLevel.fatal],
      );

      for (final level in const [
        LogLevel.warning,
        LogLevel.error,
        LogLevel.fatal,
      ]) {
        final record = LogRecord(level: level, message: message);
        expect(interceptor.intercept(record), isNotNull);
      }
    });

    test(
        'given multiple allowed levels, '
        'when records with disallowed levels are intercepted, '
        'then all are rejected', () {
      const interceptor = LogLevelInterceptor(
        [LogLevel.warning, LogLevel.error, LogLevel.fatal],
      );

      for (final level in const [LogLevel.debug, LogLevel.info]) {
        final record = LogRecord(level: level, message: message);
        expect(interceptor.intercept(record), isNull);
      }
    });
  });

  group('LogLevelInterceptor.reportable', () {
    const message = 'test message';

    test(
        'given no levels argument, '
        'when inspecting the interceptor, '
        'then levels equals info, warning, error and fatal', () {
      final interceptor = LogLevelInterceptor.reportable();

      expect(interceptor.allowedLevels, const [
        LogLevel.info,
        LogLevel.warning,
        LogLevel.error,
        LogLevel.fatal,
      ]);
    });

    test(
        'given no levels argument, '
        'when a debug record is intercepted, '
        'then it is rejected', () {
      final interceptor = LogLevelInterceptor.reportable();
      const record = LogRecord(level: LogLevel.debug, message: message);

      expect(interceptor.intercept(record), isNull);
    });

    test(
        'given no levels argument, '
        'when records with info, warning, error, and fatal levels are intercepted, '
        'then all pass through', () {
      final interceptor = LogLevelInterceptor.reportable();

      for (final level in const [
        LogLevel.info,
        LogLevel.warning,
        LogLevel.error,
        LogLevel.fatal,
      ]) {
        final record = LogRecord(level: level, message: message);
        expect(interceptor.intercept(record), isNotNull);
      }
    });

    test(
        'given custom levels, '
        'when records with those levels are intercepted, '
        'then all pass through', () {
      final interceptor = LogLevelInterceptor.reportable(
        allowedLevels: [LogLevel.error, LogLevel.fatal],
      );

      for (final level in const [LogLevel.error, LogLevel.fatal]) {
        final record = LogRecord(level: level, message: message);
        expect(interceptor.intercept(record), isNotNull);
      }
    });

    test(
        'given custom levels, '
        'when records with disallowed levels are intercepted, '
        'then all are rejected', () {
      final interceptor = LogLevelInterceptor.reportable(
        allowedLevels: [LogLevel.error, LogLevel.fatal],
      );

      for (final level in const [
        LogLevel.debug,
        LogLevel.info,
        LogLevel.warning
      ]) {
        final record = LogRecord(level: level, message: message);
        expect(interceptor.intercept(record), isNull);
      }
    });

    test(
        'given an empty levels list, '
        'when the interceptor is created, '
        'then an AssertionError is thrown', () {
      expect(
        () => LogLevelInterceptor.reportable(allowedLevels: []),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
