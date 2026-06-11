import 'package:firebase_analytics_platform_interface/firebase_analytics_platform_interface.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeFirebaseAnalyticsApi {
  String? lastEventName;
  Map<String, Object?>? lastEventParameters;
  String? lastUserId;
  final Map<String, String?> userProperties = {};
  bool? collectionEnabled;
  bool wasReset = false;
  Map<String, Object?>? defaultEventParameters;
  bool defaultEventParametersCleared = false;

  void reset() {
    lastEventName = null;
    lastEventParameters = null;
    lastUserId = null;
    userProperties.clear(); // ignore: cascade_invocations
    collectionEnabled = null;
    wasReset = false;
    defaultEventParameters = null;
    defaultEventParametersCleared = false;
  }
}

void setupFirebaseAnalyticsMocks(FakeFirebaseAnalyticsApi api) {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    MethodChannelFirebaseAnalytics.channel,
    (MethodCall call) async => false,
  );

  _mockPigeonVoid('logEvent', (args) {
    final event = (args[0]! as Map<Object?, Object?>).cast<String, Object?>();
    api.lastEventName = event['eventName'] as String?;
    api.lastEventParameters = (event['parameters'] as Map<Object?, Object?>?)
        ?.cast<String, Object?>();
  });

  _mockPigeonVoid('setUserId', (args) {
    api.lastUserId = args[0] as String?;
  });

  _mockPigeonVoid('setUserProperty', (args) {
    api.userProperties[args[0]! as String] = args[1] as String?;
  });

  _mockPigeonVoid('setAnalyticsCollectionEnabled', (args) {
    api.collectionEnabled = args[0] as bool?;
  });

  _mockPigeonVoid('resetAnalyticsData', (_) {
    api.wasReset = true;
  });

  _mockPigeonVoid('setDefaultEventParameters', (args) {
    final params = (args[0] as Map<Object?, Object?>?)?.cast<String, Object?>();
    if (params == null) {
      api.defaultEventParametersCleared = true;
      api.defaultEventParameters = null;
    } else {
      api.defaultEventParameters = params;
    }
  });
}

void _mockPigeonVoid(
  String method,
  void Function(List<Object?>) handler,
) {
  const prefix =
      'dev.flutter.pigeon.firebase_analytics_platform_interface.FirebaseAnalyticsHostApi';
  final channel = BasicMessageChannel<Object?>(
    '$prefix.$method',
    const StandardMessageCodec(),
  );
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockDecodedMessageHandler<Object?>(channel, (message) async {
    handler(message == null ? [] : message as List<Object?>);
    return <Object?>[null];
  });
}
