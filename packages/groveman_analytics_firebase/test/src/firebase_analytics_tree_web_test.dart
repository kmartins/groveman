// ignore_for_file: invalid_use_of_internal_member

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:groveman_analytics/groveman_analytics.dart';
// Imports the web implementation directly, bypassing the conditional export.
import 'package:groveman_analytics_firebase/src/firebase_analytics_tree_web.dart';

import '../mock.dart';

class _TestEvent extends AnalyticsEvent {
  @override
  String get eventName => 'test_event';

  @override
  Map<String, Object>? get properties => {'screen': 'home'};
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

  group('FirebaseAnalyticsTree (web)', () {
    test(
        'when setSuperProperties is called, '
        'no call is made to Firebase Analytics', () async {
      await tree.setSuperProperties({'app_version': '1.0.0'});

      expect(fakeApi.defaultEventParameters, isNull);
      expect(fakeApi.defaultEventParametersCleared, isFalse);
    });

    test(
        'when clearSuperProperties is called, '
        'no call is made to Firebase Analytics', () async {
      await tree.clearSuperProperties();

      expect(fakeApi.defaultEventParametersCleared, isFalse);
    });

    test(
        'when reset is called, '
        'no call is made to Firebase Analytics', () async {
      await tree.reset();

      expect(fakeApi.wasReset, isFalse);
    });

    test(
        'when track is called, '
        'the event is logged to Firebase Analytics', () async {
      await tree.track(_TestEvent());

      expect(fakeApi.lastEventName, 'test_event');
    });

    test(
        'when identify is called, '
        'the userId is set in Firebase Analytics', () async {
      await tree.identify('user_123');

      expect(fakeApi.lastUserId, 'user_123');
    });

    test(
        'when enable is called, '
        'analytics collection is enabled in Firebase', () async {
      await tree.enable();

      expect(fakeApi.collectionEnabled, isTrue);
    });

    test(
        'when disable is called, '
        'analytics collection is disabled in Firebase', () async {
      await tree.disable();

      expect(fakeApi.collectionEnabled, isFalse);
    });
  });
}
