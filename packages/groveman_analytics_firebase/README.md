# Groveman Analytics Firebase

[![pub][groveman_analytics_firebase_badge]][groveman_analytics_firebase_link]
[![License: MIT][license_badge]][license_link]

[AnalyticsTree][groveman_analytics] for [groveman_analytics][groveman_analytics] that sends events to [Firebase Analytics][firebase_analytics].

## Usage

First, configure **Firebase Analytics**, see the [documentation][firebase_analytics_doc].

Add it in your `pubspec.yaml`:

```yaml
dependencies:
  firebase_analytics:
  firebase_core:
  groveman_analytics:
  groveman_analytics_firebase:
```

Import it where you want to use it e.g, in your main file.

```dart
import 'package:groveman_analytics/groveman_analytics.dart';
import 'package:groveman_analytics_firebase/groveman_analytics_firebase.dart';
```

Initialize and plant the tree on start of your application.

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  GrovemanAnalytics.plantTree(FirebaseAnalyticsTree(FirebaseAnalytics.instance));
  runApp(const MyApp());
}
```

Define your events and start tracking:

```dart
class PurchaseCompletedEvent extends AnalyticsEvent {
  PurchaseCompletedEvent(this.value);

  final double value;

  @override
  String get eventName => 'purchase_completed';

  @override
  Map<String, dynamic>? get properties => {'value': value};
}

await GrovemanAnalytics.track(PurchaseCompletedEvent(99.9));
```

> **Note:** Firebase Analytics event names must be ≤ 40 characters and property names ≤ 40 characters. Property values are automatically converted to `String` for `setUserProperty`.

## API mapping

| `AnalyticsTree` | Firebase Analytics |
|---|---|
| `track(event)` | `logEvent(name, parameters)` |
| `identify(userId, properties)` | `setUserId(id)` + `setUserProperty(name, value)` per property |
| `setSuperProperties(properties)` | `setDefaultEventParameters(parameters)` |
| `clearSuperProperties()` | `setDefaultEventParameters(null)` |
| `enable()` | `setAnalyticsCollectionEnabled(true)` |
| `disable()` | `setAnalyticsCollectionEnabled(false)` |
| `reset()` | `resetAnalyticsData()` |

## Super properties

Sets default parameters automatically included in every event logged to Firebase Analytics.

```dart
await GrovemanAnalytics.setSuperProperties({
  'app_version': '1.0.0',
  'environment': 'production',
});

// Clears all default event parameters
await GrovemanAnalytics.clearSuperProperties();
```

## User identification

```dart
await GrovemanAnalytics.identify(
  'user_123',
  properties: {'plan': 'pro'},
);
```

User properties are set via `setUserProperty`. All values are converted to `String`.

## Enable and disable data collection

```dart
// User declined consent — disables analytics collection
await GrovemanAnalytics.disable();

// User accepted consent — re-enables analytics collection
await GrovemanAnalytics.enable();
```

## 📝 License

Copyright © 2026 [Kauê Martins](https://github.com/kmartins).<br />
This project is [MIT](https://opensource.org/licenses/MIT) licensed.

[groveman_analytics_firebase_badge]: https://img.shields.io/pub/v/groveman_analytics_firebase.svg
[groveman_analytics_firebase_link]: https://pub.dev/packages/groveman_analytics_firebase
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[groveman_analytics]: https://pub.dev/packages/groveman_analytics
[firebase_analytics]: https://firebase.google.com/products/analytics
[firebase_analytics_doc]: https://firebase.flutter.dev/docs/analytics/overview
