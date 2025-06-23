import 'package:groveman/src/handle_isolate_impl.dart';
import 'package:test/test.dart';

void main() {
  group('HandleIsolateImpl', () {
    test('creates an instance and passes '
        'a function in handleError', () {
      final handleIsolate = HandleIsolateImpl();
      handleIsolate.handleError((_) {});
    });
  });
}
