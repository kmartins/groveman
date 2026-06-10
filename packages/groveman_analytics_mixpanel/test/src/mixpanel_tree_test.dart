import 'package:flutter_test/flutter_test.dart';
import 'package:groveman_analytics/groveman_analytics.dart';
import 'package:groveman_analytics_mixpanel/groveman_analytics_mixpanel.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

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
  setupMixpanelMocks();

  late Mixpanel mixpanel;
  late MixpanelTree tree;

  setUpAll(() async {
    mixpanel = await Mixpanel.init('test_token', trackAutomaticEvents: false);
    tree = MixpanelTree(mixpanel);
  });

  tearDown(methodCallLog.clear);

  group('MixpanelTree', () {
    test(
        'given an event with properties, '
        'when track is called, '
        'then sends the event to Mixpanel', () async {
      await tree.track(_TestEvent());

      expect(
        methodCallLog,
        contains(
          isMethodCall('track', arguments: {
            'eventName': 'test_event',
            'properties': {'screen': 'home'},
          }),
        ),
      );
    });

    test(
        'given an event without properties, '
        'when track is called, '
        'then sends the event with null properties', () async {
      await tree.track(_SimpleEvent());

      expect(
        methodCallLog,
        contains(isMethodCall('track', arguments: {
          'eventName': 'simple_event',
          'properties': null,
        })),
      );
    });

    test(
        'given a userId, '
        'when identify is called, '
        'then sends the userId to Mixpanel', () async {
      await tree.identify('user_123');

      expect(
        methodCallLog,
        contains(
            isMethodCall('identify', arguments: {'distinctId': 'user_123'})),
      );
    });

    test(
        'given a userId with properties, '
        'when identify is called, '
        'then sets user properties via People.set', () async {
      await tree.identify('user_123', properties: {'plan': 'pro'});

      expect(
        methodCallLog,
        containsAll([
          isMethodCall('identify', arguments: {'distinctId': 'user_123'}),
          isMethodCall('set', arguments: {
            'token': 'test_token',
            'properties': {'plan': 'pro'},
          }),
        ]),
      );
    });

    test(
        'given super properties, '
        'when setSuperProperties is called, '
        'then registers them in Mixpanel', () async {
      await tree.setSuperProperties({'app_version': '1.0.0'});

      expect(
        methodCallLog,
        contains(isMethodCall('registerSuperProperties', arguments: {
          'properties': {'app_version': '1.0.0'},
        })),
      );
    });

    test(
        'when clearSuperProperties is called, '
        'then clears super properties in Mixpanel', () async {
      await tree.clearSuperProperties();

      expect(
        methodCallLog,
        contains(isMethodCall('clearSuperProperties', arguments: null)),
      );
    });

    test(
        'when enable is called, '
        'then opts in tracking in Mixpanel', () async {
      await tree.enable();

      expect(
        methodCallLog,
        contains(isMethodCall('optInTracking', arguments: null)),
      );
    });

    test(
        'when disable is called, '
        'then opts out tracking in Mixpanel', () async {
      await tree.disable();

      expect(
        methodCallLog,
        contains(isMethodCall('optOutTracking', arguments: null)),
      );
    });

    test(
        'when reset is called, '
        'then resets Mixpanel', () async {
      await tree.reset();

      expect(
        methodCallLog,
        contains(isMethodCall('reset', arguments: null)),
      );
    });
  });
}
