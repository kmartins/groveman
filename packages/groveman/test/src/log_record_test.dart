import 'package:groveman/src/log_level.dart';
import 'package:groveman/src/log_record.dart';
import 'package:test/test.dart';

void main() {
  const level = LogLevel.debug;
  const message = 'Jungle';
  const tag = 'Test';
  const extra = <String, dynamic>{'name': 'Jungle', 'trees': 50};
  const error = 'Error';
  final stackTrace = StackTrace.fromString('stackTrace');

  group('LogRecord', () {
    group('equality', () {
      test(
          'given two records with the same values, '
          'when compared, '
          'then they are equal', () {
        final record = LogRecord(
          level: level,
          message: message,
          tag: tag,
          extra: extra,
          error: error,
          stackTrace: stackTrace,
        );
        final other = LogRecord(
          level: level,
          message: message,
          tag: tag,
          extra: extra,
          error: error,
          stackTrace: stackTrace,
        );

        expect(record, other);
      });

      test(
          'given the same instance, '
          'when compared, '
          'then they are equal', () {
        const record = LogRecord(level: level, message: message);

        expect(record, record);
      });

      test(
          'given two records with extra maps with the same content '
          'but different instances, '
          'when compared, '
          'then they are equal', () {
        const record = LogRecord(
          level: level,
          message: message,
          extra: {'name': 'Jungle', 'trees': 50},
        );
        const other = LogRecord(
          level: level,
          message: message,
          extra: {'name': 'Jungle', 'trees': 50},
        );

        expect(record, equals(other));
      });

      test(
          'given two records with different levels, '
          'when compared, '
          'then they are not equal', () {
        const record = LogRecord(level: LogLevel.debug, message: message);
        const other = LogRecord(level: LogLevel.error, message: message);

        expect(record, isNot(other));
      });

      test(
          'given two records with different messages, '
          'when compared, '
          'then they are not equal', () {
        const record = LogRecord(level: level, message: 'a');
        const other = LogRecord(level: level, message: 'b');

        expect(record, isNot(other));
      });

      test(
          'given two records with different tags, '
          'when compared, '
          'then they are not equal', () {
        const record = LogRecord(level: level, message: message, tag: 'A');
        const other = LogRecord(level: level, message: message, tag: 'B');

        expect(record, isNot(other));
      });

      test(
          'given two records with different extra maps, '
          'when compared, '
          'then they are not equal', () {
        const record = LogRecord(
          level: level,
          message: message,
          extra: {'key': 1},
        );
        const other = LogRecord(
          level: level,
          message: message,
          extra: {'key': 2},
        );

        expect(record, isNot(other));
      });

      test(
          'given two records with different errors, '
          'when compared, '
          'then they are not equal', () {
        const record =
            LogRecord(level: level, message: message, error: 'ErrorA');
        const other =
            LogRecord(level: level, message: message, error: 'ErrorB');

        expect(record, isNot(other));
      });

      test(
          'given two records with different stack traces, '
          'when compared, '
          'then they are not equal', () {
        final record = LogRecord(
          level: level,
          message: message,
          stackTrace: StackTrace.fromString('a'),
        );
        final other = LogRecord(
          level: level,
          message: message,
          stackTrace: StackTrace.fromString('b'),
        );

        expect(record, isNot(other));
      });
    });

    group('hashCode', () {
      test(
          'given two records with the same values, '
          'when hashCode is compared, '
          'then they are equal', () {
        final record = LogRecord(
          level: level,
          message: message,
          tag: tag,
          extra: extra,
          error: error,
          stackTrace: stackTrace,
        );
        final other = LogRecord(
          level: level,
          message: message,
          tag: tag,
          extra: extra,
          error: error,
          stackTrace: stackTrace,
        );

        expect(record.hashCode, other.hashCode);
      });

      test(
          'given two records with extra maps with the same content '
          'but different instances, '
          'when hashCode is compared, '
          'then they are equal', () {
        const record = LogRecord(
          level: level,
          message: message,
          extra: {'name': 'Jungle', 'trees': 50},
        );
        const other = LogRecord(
          level: level,
          message: message,
          extra: {'name': 'Jungle', 'trees': 50},
        );

        expect(record.hashCode, other.hashCode);
      });
    });

    group('copyWith', () {
      test(
          'given a record, '
          'when copyWith is called without arguments, '
          'then the result is equal to the original', () {
        final original = LogRecord(
          level: level,
          message: message,
          tag: tag,
          extra: extra,
          error: error,
          stackTrace: stackTrace,
        );

        expect(original.copyWith(), original);
      });

      test(
          'given a record, '
          'when copyWith is called with a new level, '
          'then the result has the new level', () {
        const original = LogRecord(level: level, message: message);

        expect(
          original.copyWith(level: LogLevel.error),
          const LogRecord(level: LogLevel.error, message: message),
        );
      });

      test(
          'given a record, '
          'when copyWith is called with a new message, '
          'then the result has the new message', () {
        const original = LogRecord(level: level, message: message);

        expect(
          original.copyWith(message: 'new message'),
          const LogRecord(level: level, message: 'new message'),
        );
      });

      test(
          'given a record with a tag, '
          'when copyWith is called with tag as null, '
          'then the result has null tag', () {
        const original = LogRecord(level: level, message: message, tag: tag);

        expect(original.copyWith(tag: null).tag, isNull);
      });

      test(
          'given a record with extra, '
          'when copyWith is called with extra as null, '
          'then the result has null extra', () {
        const original = LogRecord(
          level: level,
          message: message,
          extra: extra,
        );

        expect(original.copyWith(extra: null).extra, isNull);
      });

      test(
          'given a record with an error, '
          'when copyWith is called with error as null, '
          'then the result has null error', () {
        const original = LogRecord(
          level: level,
          message: message,
          error: error,
        );

        expect(original.copyWith(error: null).error, isNull);
      });

      test(
          'given a record with a stackTrace, '
          'when copyWith is called with stackTrace as null, '
          'then the result has null stackTrace', () {
        final original = LogRecord(
          level: level,
          message: message,
          stackTrace: stackTrace,
        );

        expect(original.copyWith(stackTrace: null).stackTrace, isNull);
      });
    });
  });
}
