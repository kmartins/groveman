import 'package:groveman_analytics/groveman_analytics.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

/// [AnalyticsTree] that sends events to Mixpanel.
class MixpanelTree extends AnalyticsTree {
  /// Creates a [MixpanelTree] with the given [Mixpanel] instance.
  MixpanelTree(this._mixpanel);

  final Mixpanel _mixpanel;

  @override
  Future<void> track(AnalyticsEvent event) =>
      _mixpanel.track(event.eventName, properties: event.properties);

  @override
  Future<void> identify(String userId,
      {Map<String, Object>? properties}) async {
    await _mixpanel.identify(userId);
    properties?.forEach((key, value) => _mixpanel.getPeople().set(key, value));
  }

  @override
  Future<void> setSuperProperties(Map<String, Object> properties) =>
      _mixpanel.registerSuperProperties(properties);

  @override
  Future<void> clearSuperProperties() => _mixpanel.clearSuperProperties();

  @override
  Future<void> enable() async => _mixpanel.optInTracking();

  @override
  Future<void> disable() async => _mixpanel.optOutTracking();

  @override
  Future<void> reset() => _mixpanel.reset();
}
