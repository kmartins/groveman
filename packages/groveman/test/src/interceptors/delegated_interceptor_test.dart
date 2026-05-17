import 'package:groveman/groveman.dart';
import 'package:test/test.dart';

void main() {
  group('DelegatedGrovemanInterceptor', () {
    const record = LogRecord(level: LogLevel.info, message: 'test');

    test(
        'given a function that returns the record, '
        'when the record is intercepted, '
        'then the original record is returned', () {
      final interceptor = DelegatedGrovemanInterceptor((r) => r);

      expect(interceptor.intercept(record), same(record));
    });

    test(
        'given a function that returns null, '
        'when the record is intercepted, '
        'then null is returned', () {
      final interceptor = DelegatedGrovemanInterceptor((_) => null);

      expect(interceptor.intercept(record), isNull);
    });

    test(
        'given a function that transforms the record, '
        'when the record is intercepted, '
        'then the transformed record is returned', () {
      final interceptor = DelegatedGrovemanInterceptor(
        (r) => LogRecord(level: r.level, message: 'transformed'),
      );

      final result = interceptor.intercept(record);

      expect(result?.message, 'transformed');
    });

    test(
        'given a function that conditionally rejects, '
        'when records with allowed levels are intercepted, '
        'then they pass through', () {
      final interceptor = DelegatedGrovemanInterceptor(
        (r) => r.level.index >= LogLevel.warning.index ? r : null,
      );

      const warning = LogRecord(level: LogLevel.warning, message: 'warn');
      expect(interceptor.intercept(warning), same(warning));
    });

    test(
        'given a function that conditionally rejects, '
        'when records with disallowed levels are intercepted, '
        'then null is returned', () {
      final interceptor = DelegatedGrovemanInterceptor(
        (r) => r.level.index >= LogLevel.warning.index ? r : null,
      );

      const debug = LogRecord(level: LogLevel.debug, message: 'dbg');
      expect(interceptor.intercept(debug), isNull);
    });
  });
}
