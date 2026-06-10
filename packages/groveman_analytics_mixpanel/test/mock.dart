import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: implementation_imports
import 'package:mixpanel_flutter/codec/mixpanel_message_codec.dart';

final List<MethodCall> methodCallLog = <MethodCall>[];

void setupMixpanelMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel(
      'mixpanel_flutter',
      StandardMethodCodec(MixpanelMessageCodec()),
    ),
    (MethodCall methodCall) async {
      methodCallLog.add(methodCall);
      return null;
    },
  );
}
