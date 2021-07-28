import 'package:groveman/src/util/stack_trace_util.dart';
import 'package:test/test.dart';

void main() {
  group('StackTraceUtil', () {
    test(
        'given a current stack trace, '
        'when to get a tag, '
        'then expect result is the name file '
        'and line number of the first item stack', () {
      final stackTraceUtil = StackTraceUtil();
      expect(stackTraceUtil.getTag(), 'stack_trace_util_test-12');
    });

    test(
        'given a current stack trace, '
        'when to remove an unnecessary trace '
        'then expected result is without trace of mobile, '
        'web, browser, and line without information', () {
      final stackTraceUtil = StackTraceUtil();
      final stackTraceList = [
        '#1      _Groveman._log (package:groveman/src/groveman.dart:62:46)',
        'packages/groveman/src/debug_tree.dart 50:37',
        'dart-sdk/lib/async/schedule_microtask.dart 49:5',
        'dart:sdk_internal',
        'package:groveman/src/groveman.dart',
        ' ',
      ];
      stackTraceUtil.discardUnnecessaryTrace(stackTraceList);
      expect(stackTraceList, isEmpty);
    });
  });
}
