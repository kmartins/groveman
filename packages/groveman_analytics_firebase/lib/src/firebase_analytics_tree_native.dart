import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:groveman_analytics/groveman_analytics.dart';

/// [AnalyticsTree] that sends events to Firebase Analytics.
class FirebaseAnalyticsTree extends AnalyticsTree {
  /// Creates a [FirebaseAnalyticsTree].
  ///
  /// Uses [FirebaseAnalytics.instance] if no [analytics] is provided.
  FirebaseAnalyticsTree(this._firebaseAnalytics);

  final FirebaseAnalytics _firebaseAnalytics;

  @override
  Future<void> track(AnalyticsEvent event) => _firebaseAnalytics.logEvent(
      name: event.eventName, parameters: event.properties);

  @override
  Future<void> identify(String userId,
      {Map<String, Object>? properties}) async {
    await _firebaseAnalytics.setUserId(id: userId);
    if (properties != null) {
      await Future.wait(
        properties.entries.map(
          (e) => _firebaseAnalytics.setUserProperty(
            name: e.key,
            value: e.value.toString(),
          ),
        ),
      );
    }
  }

  @override
  Future<void> setSuperProperties(Map<String, Object> properties) =>
      _firebaseAnalytics.setDefaultEventParameters(properties);

  @override
  Future<void> clearSuperProperties() =>
      _firebaseAnalytics.setDefaultEventParameters(null);

  @override
  Future<void> enable() =>
      _firebaseAnalytics.setAnalyticsCollectionEnabled(true);

  @override
  Future<void> disable() =>
      _firebaseAnalytics.setAnalyticsCollectionEnabled(false);

  @override
  Future<void> reset() => _firebaseAnalytics.resetAnalyticsData();
}
