import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:groveman_analytics/groveman_analytics.dart';
import 'package:groveman_analytics_firebase/groveman_analytics_firebase.dart';

import '../mock.dart';

class _TestEvent extends AnalyticsEvent {
  @override
  String get eventName => 'test_event';

  @override
  Map<String, Object>? get properties => {'screen': 'home'};
}

class _SimpleEvent extends AnalyticsEvent {
  @override
  String get eventName => 'simple_event';
}

void main() {
  final fakeApi = FakeFirebaseAnalyticsApi();
  setupFirebaseAnalyticsMocks(fakeApi);

  late FirebaseAnalyticsTree tree;

  setUpAll(() async {
    await Firebase.initializeApp();
    tree = FirebaseAnalyticsTree(FirebaseAnalytics.instance);
  });

  tearDown(fakeApi.reset);

  group('FirebaseAnalyticsTree', () {
    test(
        'given an event with properties, '
        'when track is called, '
        'then logs the event to Firebase Analytics', () async {
      await tree.track(_TestEvent());

      expect(fakeApi.lastEventName, 'test_event');
      expect(fakeApi.lastEventParameters, {'screen': 'home'});
    });

    test(
        'given an event without properties, '
        'when track is called, '
        'then logs the event with null parameters', () async {
      await tree.track(_SimpleEvent());

      expect(fakeApi.lastEventName, 'simple_event');
      expect(fakeApi.lastEventParameters, isNull);
    });

    test(
        'given a userId, '
        'when identify is called, '
        'then sets the userId in Firebase Analytics', () async {
      await tree.identify('user_123');

      expect(fakeApi.lastUserId, 'user_123');
    });

    test(
        'given a userId with properties, '
        'when identify is called, '
        'then sets userId and user properties in Firebase Analytics', () async {
      await tree.identify('user_123', properties: {'plan': 'pro'});

      expect(fakeApi.lastUserId, 'user_123');
      expect(fakeApi.userProperties['plan'], 'pro');
    });

    test(
        'given super properties, '
        'when setSuperProperties is called, '
        'then sets default event parameters in Firebase Analytics', () async {
      await tree.setSuperProperties({'app_version': '1.0.0'});

      expect(fakeApi.defaultEventParameters, {'app_version': '1.0.0'});
    });

    test(
        'when clearSuperProperties is called, '
        'then clears default event parameters in Firebase Analytics', () async {
      await tree.clearSuperProperties();

      expect(fakeApi.defaultEventParametersCleared, isTrue);
      expect(fakeApi.defaultEventParameters, isNull);
    });

    test(
        'when enable is called, '
        'then enables analytics collection in Firebase', () async {
      await tree.enable();

      expect(fakeApi.collectionEnabled, isTrue);
    });

    test(
        'when disable is called, '
        'then disables analytics collection in Firebase', () async {
      await tree.disable();

      expect(fakeApi.collectionEnabled, isFalse);
    });

    test(
        'when reset is called, '
        'then resets analytics data in Firebase', () async {
      await tree.reset();

      expect(fakeApi.wasReset, isTrue);
    });
  });
}
