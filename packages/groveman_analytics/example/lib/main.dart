import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:groveman_analytics/groveman_analytics.dart';

class ButtonClickedEvent extends AnalyticsEvent {
  ButtonClickedEvent(this.label);

  final String label;

  @override
  String get eventName => 'button_clicked';

  @override
  Map<String, dynamic>? get properties => {'label': label};
}

void main() {
  GrovemanAnalytics.plantTree(_DebugAnalyticsTree());
  GrovemanAnalytics.setSuperProperties({'app_version': '1.0.0'});
  runApp(const MyApp());
}

class _DebugAnalyticsTree extends AnalyticsTree {
  @override
  Future<void> track(AnalyticsEvent event) async {
    log('[Analytics] track: ${event.eventName} ${event.properties}');
  }

  @override
  Future<void> identify(String userId,
      {Map<String, dynamic>? properties}) async {
    log('[Analytics] identify: $userId $properties');
  }

  @override
  Future<void> setSuperProperties(Map<String, dynamic> properties) async {
    log('[Analytics] setSuperProperties: $properties');
  }

  @override
  Future<void> clearSuperProperties() async =>
      log('[Analytics] clearSuperProperties');

  @override
  Future<void> enable() async => log('[Analytics] enabled');

  @override
  Future<void> disable() async => log('[Analytics] disabled');

  @override
  Future<void> reset() async => log('[Analytics] reset');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Groveman Analytics Example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Groveman Analytics')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            FilledButton.icon(
              onPressed: () => GrovemanAnalytics.track(
                ButtonClickedEvent('track'),
              ),
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
            FilledButton.icon(
              onPressed: GrovemanAnalytics.disable,
              icon: const Icon(Icons.block),
              label: const Text('Disable'),
            ),
            FilledButton.icon(
              onPressed: GrovemanAnalytics.enable,
              icon: const Icon(Icons.check_circle),
              label: const Text('Enable'),
            ),
          ],
        ),
      ),
    );
  }
}
