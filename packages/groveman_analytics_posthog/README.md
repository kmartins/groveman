# Groveman Analytics PostHog

[![pub][groveman_analytics_posthog_badge]][groveman_analytics_posthog_link]
[![License: MIT][license_badge]][license_link]

[AnalyticsTree][groveman_analytics] for [groveman_analytics][groveman_analytics] that sends events to [PostHog][posthog].

## Usage

First, configure **PostHog Flutter**, see the [documentation][posthog_doc].

Add it in your `pubspec.yaml`:

```yaml
dependencies:
  groveman_analytics:
  groveman_analytics_posthog:
  posthog_flutter:
```

Import it where you want to use it e.g, in your main file.

```dart
import 'package:groveman_analytics/groveman_analytics.dart';
import 'package:groveman_analytics_posthog/groveman_analytics_posthog.dart';
```

Initialize and plant the tree on start of your application.

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = PostHogConfig('YOUR_POSTHOG_API_KEY');
  await Posthog().setup(config);

  GrovemanAnalytics.plantTree(PostHogTree(Posthog()));
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

| `AnalyticsTree` | PostHog |
|---|---|
| `track(event)` | `capture(eventName, properties)` |
| `identify(userId, properties)` | `identify(userId, userProperties)` |
| `setSuperProperties(properties)` | `register(key, value)` per property |
| `clearSuperProperties()` | `unregister(key)` per property |
| `enable()` | `enable()` |
| `disable()` | `disable()` |
| `reset()` | `reset()` |

## Super properties

Properties automatically attached to every event sent to PostHog. Internally uses `register`/`unregister` per key, since PostHog Flutter does not expose a bulk clear method.

```dart
await GrovemanAnalytics.setSuperProperties({
  'app_version': '1.0.0',
  'environment': 'production',
});

await GrovemanAnalytics.clearSuperProperties();
```

## User identification

```dart
await GrovemanAnalytics.identify(
  'user_123',
  properties: {'plan': 'pro'},
);
```

Calling `identify` again with the same userId **merges** properties — PostHog does not replace them.

## Enable and disable data collection

```dart
// User declined consent — stops all data collection
await GrovemanAnalytics.disable();

// User accepted consent — resumes data collection
await GrovemanAnalytics.enable();
```

## 📝 License

Copyright © 2026 [Kauê Martins](https://github.com/kmartins).<br />
This project is [MIT](https://opensource.org/licenses/MIT) licensed.

[groveman_analytics_posthog_badge]: https://img.shields.io/pub/v/groveman_analytics_posthog.svg
[groveman_analytics_posthog_link]: https://pub.dev/packages/groveman_analytics_posthog
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[groveman_analytics]: https://pub.dev/packages/groveman_analytics
[posthog]: https://posthog.com
[posthog_doc]: https://posthog.com/docs/libraries/flutter
