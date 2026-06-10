import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:groveman_analytics/groveman_analytics.dart';
import 'package:groveman_analytics_firebase/groveman_analytics_firebase.dart';

class ButtonClickedEvent extends AnalyticsEvent {
  ButtonClickedEvent(this.label);

  final String label;

  @override
  String get eventName => 'button_clicked';

  @override
  Map<String, Object>? get properties => {'label': label};
}

const _firebaseOptions = FirebaseOptions(
  apiKey: String.fromEnvironment('FIREBASE_API_KEY'),
  appId: String.fromEnvironment('FIREBASE_APP_ID'),
  messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
  projectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: _firebaseOptions);

  GrovemanAnalytics
    ..plantTree(FirebaseAnalyticsTree(FirebaseAnalytics.instance))
    ..setSuperProperties({'app_version': '1.0.0'});

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Groveman Analytics Firebase Example',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Analytics')),
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
