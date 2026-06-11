import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:groveman_analytics/groveman_analytics.dart';

/// [AnalyticsTree] that sends events to Firebase Analytics.
class FirebaseAnalyticsTree extends AnalyticsTree {
  /// Creates a [FirebaseAnalyticsTree].
  FirebaseAnalyticsTree(this._firebaseAnalytics);

  final FirebaseAnalytics _firebaseAnalytics;

  @override
  Future<void> track(AnalyticsEvent event) => _firebaseAnalytics.logEvent(
        name: event.eventName,
        parameters: event.properties,
      );

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

  /// Not supported on web by Firebase Analytics.
  @override
  Future<void> setSuperProperties(Map<String, Object> properties) =>
      Future.value();

  /// Not supported on web by Firebase Analytics.
  @override
  Future<void> clearSuperProperties() => Future.value();

  @override
  Future<void> enable() =>
      _firebaseAnalytics.setAnalyticsCollectionEnabled(true);

  @override
  Future<void> disable() =>
      _firebaseAnalytics.setAnalyticsCollectionEnabled(false);

  /// Not supported on web by Firebase Analytics.
  @override
  Future<void> reset() => Future.value();
}
