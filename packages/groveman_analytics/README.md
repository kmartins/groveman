# Groveman Analytics

[![pub][groveman_analytics_badge]][groveman_analytics_link]
[![License: MIT][license_badge]][license_link]

Analytics for **Dart/Flutter** applications, inspired by the same concepts of tree and planting as [groveman][groveman].

Behavior is added through `AnalyticsTree` instances. Install an instance by calling `GrovemanAnalytics.plantTree`. Installation should be done as early as possible, e.g, in the `main` function.

## Usage

Add it in your `pubspec.yaml`:

```yaml
dependencies:
  groveman_analytics:
```

Import it where you want to use it e.g, in your main file.

```dart
import 'package:groveman_analytics/groveman_analytics.dart';
```

Define your analytics events by extending `AnalyticsEvent`:

```dart
class PurchaseCompletedEvent extends AnalyticsEvent {
  PurchaseCompletedEvent(this.value);

  final double value;

  @override
  String get eventName => 'purchase_completed';

  @override
  Map<String, dynamic>? get properties => {'value': value};
}

// Events without properties just omit the override
class AppOpenedEvent extends AnalyticsEvent {
  @override
  String get eventName => 'app_opened';
}
```

Plant a tree and start tracking:

```dart
void main() {
  GrovemanAnalytics.plantTree(MyAnalyticsTree());
  runApp(const MyApp());
}
```

## API

### track

Sends an analytics event to all planted trees.

```dart
await GrovemanAnalytics.track(PurchaseCompletedEvent(99.9));
```

### identify

Associates the current user with all planted trees.

```dart
await GrovemanAnalytics.identify(
  'user_123',
  properties: {'plan': 'pro', 'name': 'John'},
);
```

### setSuperProperties / clearSuperProperties

Properties automatically attached to every event.

```dart
await GrovemanAnalytics.setSuperProperties({
  'app_version': '1.0.0',
  'environment': 'production',
});

await GrovemanAnalytics.clearSuperProperties();
```

### enable / disable

Controls whether analytics data is collected. Useful for GDPR consent flows.

```dart
// User declined consent
await GrovemanAnalytics.disable();

// User accepted consent
await GrovemanAnalytics.enable();
```

### reset

Clears the current user session. Call this on user logout.

```dart
await GrovemanAnalytics.reset();
```

## Creating a custom tree

Extend `AnalyticsTree` to send events to any analytics service:

```dart
class MyAnalyticsTree extends AnalyticsTree {
  @override
  Future<void> track(AnalyticsEvent event) async {
    myService.logEvent(event.eventName, event.properties);
  }

  @override
  Future<void> identify(String userId, {Map<String, dynamic>? properties}) async {
    myService.identify(userId, properties);
  }

  @override
  Future<void> setSuperProperties(Map<String, dynamic> properties) async {
    myService.registerSuperProperties(properties);
  }

  @override
  Future<void> clearSuperProperties() async {
    myService.clearSuperProperties();
  }

  @override
  Future<void> enable() async => myService.enable();

  @override
  Future<void> disable() async => myService.disable();

  @override
  Future<void> reset() async => myService.reset();
}
```

## Officially supported trees

- [groveman_analytics_mixpanel][groveman_analytics_mixpanel_link]
- [groveman_analytics_posthog][groveman_analytics_posthog_link]
- [groveman_analytics_firebase][groveman_analytics_firebase_link]

## 📝 Maintainers

[Kauê Martins](https://github.com/kmartins)

## 🤝 Support

You liked this package? Then give it a ⭐️. If you want to help then:

- Fork this repository
- Send a Pull Request with new features
- Share this package
- Create issues if you find a bug or want to suggest a new extension

**Pull Request title follows [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/). The scope available is `groveman_analytics`.**

## 📝 License

Copyright © 2026 [Kauê Martins](https://github.com/kmartins).<br />
This project is [MIT](https://opensource.org/licenses/MIT) licensed.

[groveman_analytics_badge]: https://img.shields.io/pub/v/groveman_analytics.svg
[groveman_analytics_link]: https://pub.dev/packages/groveman_analytics
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[groveman]: https://pub.dev/packages/groveman
[groveman_analytics_mixpanel_link]: https://pub.dev/packages/groveman_analytics_mixpanel
[groveman_analytics_posthog_link]: https://pub.dev/packages/groveman_analytics_posthog
[groveman_analytics_firebase_link]: https://pub.dev/packages/groveman_analytics_firebase
