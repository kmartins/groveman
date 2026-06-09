import 'package:groveman_analytics/groveman_analytics.dart';
import 'package:test/test.dart';

class ButtonClickedEvent extends AnalyticsEvent {
  ButtonClickedEvent(this.screen);

  final String screen;

  @override
  String get eventName => 'button_clicked';

  @override
  Map<String, dynamic> get properties => {'screen': screen};
}

class AssertAnalyticsTree extends AnalyticsTree {
  AnalyticsEvent? lastEvent;
  String? userId;
  Map<String, dynamic>? userProperties;
  bool wasReset = false;
  bool isEnabled = true;
  Map<String, dynamic> superProperties = {};

  @override
  Future<void> track(AnalyticsEvent event) async => lastEvent = event;

  @override
  Future<void> identify(String userId,
      {Map<String, dynamic>? properties}) async {
    this.userId = userId;
    userProperties = properties;
  }

  @override
  Future<void> setSuperProperties(Map<String, dynamic> properties) async =>
      superProperties.addAll(properties);

  @override
  Future<void> clearSuperProperties() async => superProperties.clear();

  @override
  Future<void> enable() async => isEnabled = true;

  @override
  Future<void> disable() async => isEnabled = false;

  @override
  Future<void> reset() async {
    userId = null;
    userProperties = null;
    wasReset = true;
  }
}

class SecondAssertAnalyticsTree extends AssertAnalyticsTree {}

void main() {
  group('GrovemanAnalytics', () {
    final event = ButtonClickedEvent('home');

    tearDown(() => GrovemanAnalytics.clearAll());

    test(
        'given no tree planted, '
        'when track is called, '
        'no tree is notified', () async {
      final tree = AssertAnalyticsTree();

      await GrovemanAnalytics.track(event);
      expect(tree.lastEvent, isNull);
    });

    test(
        'given a tree planted, '
        'when track is called, '
        'the tree receives the event', () async {
      final tree = AssertAnalyticsTree();
      GrovemanAnalytics.plantTree(tree);

      await GrovemanAnalytics.track(event);
      expect(tree.lastEvent, event);
    });

    test(
        'given two trees planted, '
        'when track is called, '
        'both trees receive the event', () async {
      final tree = AssertAnalyticsTree();
      final second = SecondAssertAnalyticsTree();
      GrovemanAnalytics
        ..plantTree(tree)
        ..plantTree(second);

      await GrovemanAnalytics.track(event);
      expect(tree.lastEvent, event);
      expect(second.lastEvent, event);
    });

    test(
        'given the same tree planted twice, '
        'when track is called, '
        'only the last plant is kept', () async {
      final first = AssertAnalyticsTree();
      final second = AssertAnalyticsTree();
      GrovemanAnalytics
        ..plantTree(first)
        ..plantTree(second);

      await GrovemanAnalytics.track(event);
      expect(first.lastEvent, isNull);
      expect(second.lastEvent, event);
    });

    test(
        'given a tree planted, '
        'when identify is called, '
        'the tree receives the user', () async {
      final tree = AssertAnalyticsTree();
      GrovemanAnalytics.plantTree(tree);

      await GrovemanAnalytics.identify('user_123', properties: {'plan': 'pro'});
      expect(tree.userId, 'user_123');
      expect(tree.userProperties, {'plan': 'pro'});
    });

    test(
        'given a tree planted, '
        'when identify is called without properties, '
        'the tree receives the user with null properties', () async {
      final tree = AssertAnalyticsTree();
      GrovemanAnalytics.plantTree(tree);

      await GrovemanAnalytics.identify('user_123');
      expect(tree.userId, 'user_123');
      expect(tree.userProperties, isNull);
    });

    test(
        'given a tree planted with a user identified, '
        'when reset is called, '
        'the tree resets the user', () async {
      final tree = AssertAnalyticsTree();
      GrovemanAnalytics.plantTree(tree);

      await GrovemanAnalytics.identify('user_123');
      await GrovemanAnalytics.reset();
      expect(tree.wasReset, isTrue);
      expect(tree.userId, isNull);
    });

    test(
        'given a tree planted, '
        'when setSuperProperties is called, '
        'the tree receives the super properties', () async {
      final tree = AssertAnalyticsTree();
      GrovemanAnalytics.plantTree(tree);

      await GrovemanAnalytics.setSuperProperties({'app_version': '1.0.0'});
      expect(tree.superProperties, {'app_version': '1.0.0'});
    });

    test(
        'given a tree with super properties, '
        'when clearSuperProperties is called, '
        'the tree clears the super properties', () async {
      final tree = AssertAnalyticsTree();
      GrovemanAnalytics.plantTree(tree);

      await GrovemanAnalytics.setSuperProperties({'app_version': '1.0.0'});
      await GrovemanAnalytics.clearSuperProperties();
      expect(tree.superProperties, isEmpty);
    });

    test(
        'given a tree planted, '
        'when disable is called, '
        'the tree is disabled', () async {
      final tree = AssertAnalyticsTree();
      GrovemanAnalytics.plantTree(tree);

      await GrovemanAnalytics.disable();
      expect(tree.isEnabled, isFalse);
    });

    test(
        'given a disabled tree, '
        'when enable is called, '
        'the tree is enabled', () async {
      final tree = AssertAnalyticsTree();
      GrovemanAnalytics.plantTree(tree);

      await GrovemanAnalytics.disable();
      await GrovemanAnalytics.enable();
      expect(tree.isEnabled, isTrue);
    });

    test(
        'given trees added, '
        'when clearAll is called, '
        'no tree receives events', () async {
      final tree = AssertAnalyticsTree();
      GrovemanAnalytics.plantTree(tree);

      GrovemanAnalytics.clearAll();
      await GrovemanAnalytics.track(event);

      expect(tree.lastEvent, isNull);
    });
  });
}
