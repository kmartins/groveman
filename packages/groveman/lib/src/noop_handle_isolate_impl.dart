import 'package:groveman/groveman.dart';

/// Isolate doesn't work in browser
class HandleIsolateImpl extends HandleIsolate {
  @override
  void handleError(HandleIsolateError handleIsolateError) {}
}
