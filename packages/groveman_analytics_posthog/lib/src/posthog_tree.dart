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
        properties: event.properties
            ?.map((key, value) => MapEntry(key, value as Object)),
      );

  @override
  Future<void> identify(String userId, {Map<String, dynamic>? properties}) =>
      _posthog.identify(
        userId: userId,
        userProperties:
            properties?.map((key, value) => MapEntry(key, value as Object)),
      );

  @override
  Future<void> setSuperProperties(Map<String, dynamic> properties) async {
    for (final entry in properties.entries) {
      await _posthog.register(entry.key, entry.value as Object);
      _superPropertyKeys.add(entry.key);
    }
  }

  @override
  Future<void> clearSuperProperties() async {
    for (final key in _superPropertyKeys) {
      await _posthog.unregister(key);
    }
    _superPropertyKeys.clear();
  }

  @override
  Future<void> enable() => _posthog.enable();

  @override
  Future<void> disable() => _posthog.disable();

  @override
  Future<void> reset() => _posthog.reset();
}
