import 'package:flutter_test/flutter_test.dart';
import 'package:groveman_analytics/groveman_analytics.dart';
import 'package:groveman_analytics_posthog/groveman_analytics_posthog.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

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
  setupPostHogMocks();

  final tree = PostHogTree(Posthog());

  tearDown(methodCallLog.clear);

  group('PostHogTree', () {
    test(
        'given an event with properties, '
        'when track is called, '
        'then sends capture to PostHog', () async {
      await tree.track(_TestEvent());

      expect(
        methodCallLog,
        contains(isMethodCall('capture', arguments: {
          'eventName': 'test_event',
          'properties': {'screen': 'home'},
        })),
      );
    });

    test(
        'given an event without properties, '
        'when track is called, '
        'then sends capture without properties', () async {
      await tree.track(_SimpleEvent());

      expect(
        methodCallLog,
        contains(
            isMethodCall('capture', arguments: {'eventName': 'simple_event'})),
      );
    });

    test(
        'given a userId, '
        'when identify is called, '
        'then sends userId to PostHog', () async {
      await tree.identify('user_123');

      expect(
        methodCallLog,
        contains(isMethodCall('identify', arguments: {'userId': 'user_123'})),
      );
    });

    test(
        'given a userId with properties, '
        'when identify is called, '
        'then sends userId and user properties to PostHog', () async {
      await tree.identify('user_123', properties: {'plan': 'pro'});

      expect(
        methodCallLog,
        contains(isMethodCall('identify', arguments: {
          'userId': 'user_123',
          'userProperties': {'plan': 'pro'},
        })),
      );
    });

    test(
        'given super properties, '
        'when setSuperProperties is called, '
        'then registers each property in PostHog', () async {
      await tree.setSuperProperties({'app_version': '1.0.0'});

      expect(
        methodCallLog,
        contains(isMethodCall('register', arguments: {
          'key': 'app_version',
          'value': '1.0.0',
        })),
      );
    });

    test(
        'given previously set super properties, '
        'when clearSuperProperties is called, '
        'then unregisters each property from PostHog', () async {
      await tree.setSuperProperties({'app_version': '1.0.0'});
      methodCallLog.clear();

      await tree.clearSuperProperties();

      expect(
        methodCallLog,
        contains(isMethodCall('unregister', arguments: {'key': 'app_version'})),
      );
    });

    test(
        'when enable is called, '
        'then enables PostHog', () async {
      await tree.enable();

      expect(
        methodCallLog,
        contains(isMethodCall('enable', arguments: null)),
      );
    });

    test(
        'when disable is called, '
        'then disables PostHog', () async {
      await tree.disable();

      expect(
        methodCallLog,
        contains(isMethodCall('disable', arguments: null)),
      );
    });

    test(
        'when reset is called, '
        'then resets PostHog', () async {
      await tree.reset();

      expect(
        methodCallLog,
        contains(isMethodCall('reset', arguments: null)),
      );
    });

    test(
        'given previously set super properties, '
        'when reset is called, '
        'then clears super properties so clearSuperProperties does nothing',
        () async {
      await tree.setSuperProperties({'app_version': '1.0.0'});
      await tree.reset();
      methodCallLog.clear();

      await tree.clearSuperProperties();

      expect(
        methodCallLog,
        isNot(contains(isMethodCall('unregister', arguments: anything))),
      );
    });
  });
}
