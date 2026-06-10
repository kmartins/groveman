import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

final List<MethodCall> methodCallLog = <MethodCall>[];

void setupPostHogMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('posthog_flutter'),
    (MethodCall methodCall) async {
      methodCallLog.add(methodCall);
      return null;
    },
  );
}
