import 'package:groveman_analytics/src/analytics_event.dart';

/// A tree is a destination for analytics events.
abstract class AnalyticsTree {
  /// Tracks an [AnalyticsEvent].
  Future<void> track(AnalyticsEvent event);

  /// Identifies the current user.
  Future<void> identify(String userId, {Map<String, dynamic>? properties});

  /// Sets properties that are automatically attached to every event.
  Future<void> setSuperProperties(Map<String, dynamic> properties);

  /// Clears all super properties.
  Future<void> clearSuperProperties();

  /// Enables analytics data collection.
  Future<void> enable();

  /// Disables analytics data collection.
  Future<void> disable();

  /// Resets the current user session.
  Future<void> reset();
}
