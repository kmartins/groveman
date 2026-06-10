import 'package:groveman_analytics/groveman_analytics.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

/// [AnalyticsTree] that sends events to PostHog.
class PostHogTree extends AnalyticsTree {
  /// Creates a [PostHogTree].
  PostHogTree(this._posthog);

  final Posthog _posthog;

  final Set<String> _superPropertyKeys = {};

  @override
  Future<void> track(AnalyticsEvent event) => _posthog.capture(
        eventName: event.eventName,
        properties: event.properties,
      );

  @override
  Future<void> identify(String userId, {Map<String, Object>? properties}) =>
      _posthog.identify(
        userId: userId,
        userProperties: properties,
      );

  @override
  Future<void> setSuperProperties(Map<String, Object> properties) async {
    await Future.wait(
      properties.entries
          .map((e) => _posthog.register(e.key, e.value)),
    );
    _superPropertyKeys.addAll(properties.keys);
  }

  @override
  Future<void> clearSuperProperties() async {
    await Future.wait(_superPropertyKeys.map(_posthog.unregister));
    _superPropertyKeys.clear();
  }

  @override
  Future<void> enable() => _posthog.enable();

  @override
  Future<void> disable() => _posthog.disable();

  @override
  Future<void> reset() async {
    await _posthog.reset();
    _superPropertyKeys.clear();
  }
}
