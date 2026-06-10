# Groveman Analytics Mixpanel

[![pub][groveman_analytics_mixpanel_badge]][groveman_analytics_mixpanel_link]
[![License: MIT][license_badge]][license_link]

[AnalyticsTree][groveman_analytics] for [groveman_analytics][groveman_analytics] that sends events to [Mixpanel][mixpanel].

## Usage

First, configure **Mixpanel Flutter**, see the [documentation][mixpanel_doc].

Add it in your `pubspec.yaml`:

```yaml
dependencies:
  groveman_analytics:
  groveman_analytics_mixpanel:
  mixpanel_flutter:
```

Import it where you want to use it e.g, in your main file.

```dart
import 'package:groveman_analytics/groveman_analytics.dart';
import 'package:groveman_analytics_mixpanel/groveman_analytics_mixpanel.dart';
```

Initialize and plant the tree on start of your application.

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final mixpanel = await Mixpanel.init(
    'YOUR_MIXPANEL_TOKEN',
    trackAutomaticEvents: true,
  );

  GrovemanAnalytics.plantTree(MixpanelTree(mixpanel));
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

## API mapping

| `AnalyticsTree` | Mixpanel |
|---|---|
| `track(event)` | `track(eventName, properties)` |
| `identify(userId, properties)` | `identify(userId)` + `getPeople().set(key, value)` |
| `setSuperProperties(properties)` | `registerSuperProperties(properties)` |
| `clearSuperProperties()` | `clearSuperProperties()` |
| `enable()` | `optInTracking()` |
| `disable()` | `optOutTracking()` |
| `reset()` | `reset()` |

## Super properties

Properties automatically attached to every event sent to Mixpanel.

```dart
await GrovemanAnalytics.setSuperProperties({
  'app_version': '1.0.0',
  'environment': 'production',
});
```

## User identification

```dart
await GrovemanAnalytics.identify(
  'user_123',
  properties: {'plan': 'pro'},
);
```

User properties are set via `getPeople().set` in Mixpanel.

## Data Collection

```dart
// User declined consent — stops all data collection
await GrovemanAnalytics.disable();

// User accepted consent — resumes data collection
await GrovemanAnalytics.enable();
```

## 📝 License

Copyright © 2026 [Kauê Martins](https://github.com/kmartins).<br />
This project is [MIT](https://opensource.org/licenses/MIT) licensed.

[groveman_analytics_mixpanel_badge]: https://img.shields.io/pub/v/groveman_analytics_mixpanel.svg
[groveman_analytics_mixpanel_link]: https://pub.dev/packages/groveman_analytics_mixpanel
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[groveman_analytics]: https://pub.dev/packages/groveman_analytics
[mixpanel]: https://mixpanel.com
[mixpanel_doc]: https://developer.mixpanel.com/docs/flutter
