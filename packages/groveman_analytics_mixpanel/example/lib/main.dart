import 'package:flutter/material.dart';
import 'package:groveman_analytics/groveman_analytics.dart';
import 'package:groveman_analytics_mixpanel/groveman_analytics_mixpanel.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

const mixpanelToken = String.fromEnvironment('MIXPANEL_TOKEN');

class ButtonClickedEvent extends AnalyticsEvent {
  ButtonClickedEvent(this.label);

  final String label;

  @override
  String get eventName => 'button_clicked';

  @override
  Map<String, Object>? get properties => {'label': label};
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final mixpanel = await Mixpanel.init(
    mixpanelToken,
    trackAutomaticEvents: true,
  );

  GrovemanAnalytics
    ..plantTree(MixpanelTree(mixpanel))
    ..setSuperProperties({'app_version': '1.0.0'});

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Groveman Analytics Mixpanel Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mixpanel')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            FilledButton.icon(
              onPressed: () =>
                  GrovemanAnalytics.track(ButtonClickedEvent('track')),
              icon: const Icon(Icons.analytics),
              label: const Text('Track event'),
            ),
            FilledButton.icon(
              onPressed: () => GrovemanAnalytics.identify(
                'user_123',
                properties: {'plan': 'pro'},
              ),
              icon: const Icon(Icons.person),
              label: const Text('Identify user'),
            ),
            FilledButton.icon(
              onPressed: GrovemanAnalytics.reset,
              icon: const Icon(Icons.logout),
              label: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
