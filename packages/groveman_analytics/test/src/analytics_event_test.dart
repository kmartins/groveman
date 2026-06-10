import 'package:groveman_analytics/groveman_analytics.dart';
import 'package:test/test.dart';

class PurchaseEvent extends AnalyticsEvent {
  PurchaseEvent(this.value);

  final double value;

  @override
  String get eventName => 'purchase_completed';

  @override
  Map<String, Object> get properties => {'value': value};
}

class SimpleEvent extends AnalyticsEvent {
  @override
  String get eventName => 'app_opened';
}

void main() {
  group('AnalyticsEvent', () {
    test('exposes eventName', () {
      expect(PurchaseEvent(99.9).eventName, 'purchase_completed');
    });

    test('exposes properties', () {
      expect(PurchaseEvent(99.9).properties, {'value': 99.9});
    });

    test('defaults properties to null', () {
      expect(SimpleEvent().properties, isNull);
    });
  });
}
