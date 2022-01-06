import 'dart:isolate';

import 'package:groveman/groveman.dart';

/// The class import is only done if not is on the web.
/// Adds a listening that is called when occurring an error in the isolate.
class HandleIsolateImpl extends HandleIsolate {
  @override
  void handleError(HandleIsolateError handleIsolateError) {
    Isolate.current.addErrorListener(
      RawReceivePort(
        handleIsolateError,
      ).sendPort,
    );
  }
}
