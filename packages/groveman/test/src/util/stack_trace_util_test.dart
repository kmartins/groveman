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

    test(
        'given a current stack trace, '
        'when this stack trace is obfuscated '
        'then the result of the info is null ', () {
      final stackTraceUtil = StackTraceUtil();
      const stackTrace = """
        'Warning: This VM has been configured to produce '
        'stack traces that violate the Dart standard.'
        '*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***'
        'pid: 1357, tid: 1415, name 1.ui'
        "build_id: '77d1b910140a2d66b93594aea59469cf'"
        'isolate_dso_base: 75f178181000, vm_dso_base: 75f178181000'
        'isolate_instructions: 75f17818f000, vm_instructions: 75f178183000'
        '    #00 abs 000075f17833027b '
        '_kDartIsolateSnapshotInstructions+0x1a127b'
        """;
      expect(stackTraceUtil.getInfo(stackTrace), isNull);
    });

    test(
        'given a current stack trace, '
        'when this stack trace is not a line number '
        'then the result is the name file '
        'and line number of the first item stack be 0', () {
      final stackTraceUtil = StackTraceUtil();
      const stackTrace = 'file.dart';
      expect(stackTraceUtil.getInfo(stackTrace), 'file-0');
    });
  });
}
