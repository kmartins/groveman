import 'package:groveman_analytics/src/analytics_event.dart';
import 'package:groveman_analytics/src/analytics_tree.dart';
import 'package:meta/meta.dart';

/// An analytics facade.
// ignore: non_constant_identifier_names
final GrovemanAnalytics = _GrovemanAnalytics();

final class _GrovemanAnalytics {
  final Map<Type, AnalyticsTree> _trees = {};

  /// Plants an analytics tree.
  void plantTree<T extends AnalyticsTree>(T tree) {
    _trees[T] = tree;
  }

  /// Tracks an [AnalyticsEvent] across all planted trees.
  Future<void> track(AnalyticsEvent event) =>
      Future.wait(_trees.values.map((tree) => tree.track(event)));

  /// Identifies the current user across all planted trees.
  Future<void> identify(String userId, {Map<String, Object>? properties}) =>
      Future.wait(
        _trees.values
            .map((tree) => tree.identify(userId, properties: properties)),
      );

  /// Sets super properties across all planted trees.
  Future<void> setSuperProperties(Map<String, Object> properties) =>
      Future.wait(
        _trees.values.map((tree) => tree.setSuperProperties(properties)),
      );

  /// Clears all super properties across all planted trees.
  Future<void> clearSuperProperties() =>
      Future.wait(_trees.values.map((tree) => tree.clearSuperProperties()));

  /// Enables analytics data collection across all planted trees.
  Future<void> enable() =>
      Future.wait(_trees.values.map((tree) => tree.enable()));

  /// Disables analytics data collection across all planted trees.
  Future<void> disable() =>
      Future.wait(_trees.values.map((tree) => tree.disable()));

  /// Resets the current user session across all planted trees.
  Future<void> reset() =>
      Future.wait(_trees.values.map((tree) => tree.reset()));

  @visibleForTesting
  void clearAll() => _trees.clear();
}
